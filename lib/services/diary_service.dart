import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import '../data/tarot_diary.dart';

/// 타로 일기 로컬(Hive) + 클라우드(Firestore) 동기화 서비스
class DiaryService {
  static final DiaryService _instance = DiaryService._internal();
  static DiaryService get instance => _instance;
  DiaryService._internal();

  static const String _boxName = 'tarot_diaries';
  static const String _tagBoxName = 'custom_tags';
  Box<TarotDiary>? _diaryBox;
  Box<String>? _tagBox;

  /// 기본 제공 태그 목록
  static const List<String> defaultTags = [
    '연애운',
    '금전운',
    '건강운',
    '직장운',
    '오늘운세',
    '인간관계',
    '자기성찰',
  ];

  /// Hive 초기화 (앱 시작 시 호출)
  Future<void> init() async {
    await Hive.initFlutter();
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(TarotDiaryAdapter());
    }
    _diaryBox = await Hive.openBox<TarotDiary>(_boxName);
    _tagBox = await Hive.openBox<String>(_tagBoxName);
  }

  /// Hive 박스 인스턴스
  Box<TarotDiary> get diaryBox {
    if (_diaryBox == null || !_diaryBox!.isOpen) {
      throw StateError('DiaryService not initialized. Call init() first.');
    }
    return _diaryBox!;
  }

  Box<String> get tagBox {
    if (_tagBox == null || !_tagBox!.isOpen) {
      throw StateError('DiaryService not initialized. Call init() first.');
    }
    return _tagBox!;
  }

  /// 일기 저장 (로컬 + 클라우드)
  Future<void> saveDiary(TarotDiary diary) async {
    // 1. Hive에 즉시 저장
    await diaryBox.put(diary.id, diary);

    // 2. 로그인 상태면 Firestore에도 백업
    await _syncSingleToCloud(diary);
  }

  /// 클라우드(Firestore)에만 자동 저장 (모바일 기기 저장 안 함)
  Future<void> saveToCloudOnly(TarotDiary diary) async {
    await _syncSingleToCloud(diary);
  }

  /// 모바일 기기(Hive)에만 수동 저장 (이미 클라우드에 있다고 가정하거나, 로컬 단독 사용)
  Future<void> saveToLocalOnly(TarotDiary diary) async {
    await diaryBox.put(diary.id, diary);
  }

  /// 일기 삭제
  Future<void> deleteDiary(String diaryId) async {
    await diaryBox.delete(diaryId);

    // Firestore에서도 삭제
    try {
      final user = _getCurrentUser();
      if (user != null) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('diaries')
            .doc(diaryId)
            .delete();
      }
      // 커뮤니티(공개) 컬렉션에서도 삭제
      await FirebaseFirestore.instance
          .collection('community_posts')
          .doc(diaryId)
          .delete()
          .catchError((_) {});
    } catch (e) {
      debugPrint('Error deleting diary from cloud: $e');
    }
  }

  /// 일기 업데이트 (후일담, 태그 등)
  Future<void> updateDiary(TarotDiary diary) async {
    await diaryBox.put(diary.id, diary);
    await _syncSingleToCloud(diary);
  }

  /// 모든 일기 가져오기 (최신순)
  List<TarotDiary> getAllDiaries() {
    final diaries = diaryBox.values.toList();
    diaries.sort((a, b) => b.date.compareTo(a.date));
    return diaries;
  }

  /// 특정 날짜의 일기 가져오기
  List<TarotDiary> getDiariesByDate(DateTime date) {
    return diaryBox.values.where((d) {
      return d.date.year == date.year &&
          d.date.month == date.month &&
          d.date.day == date.day;
    }).toList()
      ..sort((a, b) => b.date.compareTo(a.date));
  }

  /// 특정 태그의 일기 가져오기
  List<TarotDiary> getDiariesByTag(String tag) {
    return diaryBox.values.where((d) => d.tags.contains(tag)).toList()
      ..sort((a, b) => b.date.compareTo(a.date));
  }

  /// 일기가 있는 날짜 목록 (캘린더 마커용)
  Map<DateTime, List<TarotDiary>> getDiaryEvents() {
    final Map<DateTime, List<TarotDiary>> events = {};
    for (final diary in diaryBox.values) {
      final dateKey = DateTime(diary.date.year, diary.date.month, diary.date.day);
      events.putIfAbsent(dateKey, () => []).add(diary);
    }
    return events;
  }

  // ─── 태그 관리 ───

  /// 커스텀 태그 추가
  Future<void> addCustomTag(String tag) async {
    if (!tagBox.values.contains(tag)) {
      await tagBox.add(tag);
    }
  }

  /// 커스텀 태그 삭제
  Future<void> removeCustomTag(String tag) async {
    final key = tagBox.keys.firstWhere(
      (k) => tagBox.get(k) == tag,
      orElse: () => null,
    );
    if (key != null) {
      await tagBox.delete(key);
    }
  }

  /// 전체 태그 목록 (기본 + 커스텀)
  List<String> getAllTags() {
    final customTags = tagBox.values.toList();
    return [...defaultTags, ...customTags];
  }

  // ─── 클라우드 동기화 ───

  /// Firestore에서 로컬로 마이그레이션 (첫 실행 시)
  Future<int> migrateFromCloud() async {
    final user = _getCurrentUser();
    if (user == null) return 0;

    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('diaries')
          .orderBy('date', descending: true)
          .get();

      int count = 0;
      for (final doc in snapshot.docs) {
        if (!diaryBox.containsKey(doc.id)) {
          final diary = TarotDiary.fromFirestore(doc);
          await diaryBox.put(doc.id, diary);
          count++;
        }
      }
      return count;
    } catch (e) {
      debugPrint('Error migrating from cloud: $e');
      return 0;
    }
  }

  /// 미동기화 일기를 Firestore로 업로드
  Future<void> syncAllToCloud() async {
    final user = _getCurrentUser();
    if (user == null) return;

    final unsyncedDiaries =
        diaryBox.values.where((d) => !d.isSynced).toList();
    for (final diary in unsyncedDiaries) {
      await _syncSingleToCloud(diary);
    }
  }

  /// 단일 일기를 Firestore에 업로드
  Future<void> _syncSingleToCloud(TarotDiary diary) async {
    try {
      final user = _getCurrentUser();
      if (user == null) return;

      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('diaries')
          .doc(diary.id)
          .set(diary.toMap());

      // 공개 일기 동기화 처리
      final publicDocRef = FirebaseFirestore.instance.collection('community_posts').doc(diary.id);
      if (diary.isPublic) {
        // 사용자 닉네임 가져오기
        final userDoc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
        final nickname = userDoc.data()?['nickname'] ?? '이름 없는 마녀';
        
        final publicData = {
          'diaryId': diary.id,
          'authorId': user.uid,
          'authorNickname': nickname,
          'cardIds': diary.cardIds.isNotEmpty ? diary.cardIds : [diary.cardId],
          'cardReversals': diary.cardReversals,
          'question': diary.myNote,
          'content': diary.resultText,
          'language': 'ko', // 기본 로케일 (향후 로케일 매니저로 동적 설정 가능)
          'translations': {},
          'likeCount': 0, // 이미 있다면 덮어쓰지 않도록 트랜잭션 사용 필요. (여기선 간략히 유지)
          'commentCount': 0,
          'createdAt': Timestamp.fromDate(diary.date),
          'tags': diary.tags,
        };

        // 기존 데이터 유지 (좋아요, 댓글 수 등)
        final existingDoc = await publicDocRef.get();
        if (existingDoc.exists) {
          final currentData = existingDoc.data()!;
          publicData['likeCount'] = currentData['likeCount'] ?? 0;
          publicData['commentCount'] = currentData['commentCount'] ?? 0;
          publicData['translations'] = currentData['translations'] ?? {};
        }

        await publicDocRef.set(publicData, SetOptions(merge: true));
      } else {
        // 비공개 전환 시 커뮤니티 컬렉션에서 삭제
        await publicDocRef.delete().catchError((_) {});
      }

      // 동기화 완료 표시
      diary.isSynced = true;
      await diaryBox.put(diary.id, diary);
    } catch (e) {
      debugPrint('Error syncing diary to cloud: $e');
    }
  }

  User? _getCurrentUser() {
    try {
      if (Firebase.apps.isEmpty) return null;
      return FirebaseAuth.instance.currentUser;
    } catch (e) {
      return null;
    }
  }
}
