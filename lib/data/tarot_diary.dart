import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive/hive.dart';

part 'tarot_diary.g.dart';

@HiveType(typeId: 0)
class TarotDiary extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String cardId;

  @HiveField(2)
  final String resultText;

  @HiveField(3)
  final List<String> cardIds;

  @HiveField(4)
  final List<bool> cardReversals;

  @HiveField(5)
  final List<String> positionLabels;

  @HiveField(6)
  final List<String> cardMeanings;

  @HiveField(7)
  final String spreadType;

  @HiveField(8)
  final String myNote;

  @HiveField(9)
  final DateTime date;

  @HiveField(10)
  final String? witchId;

  @HiveField(11)
  final List<String> tags;

  @HiveField(12)
  final String followUpNote;

  @HiveField(13)
  final DateTime? followUpDate;

  @HiveField(14, defaultValue: false)
  bool isSynced;

  @HiveField(15, defaultValue: false)
  bool isPublic;

  TarotDiary({
    required this.id,
    required this.cardId,
    required this.spreadType,
    required this.myNote,
    required this.resultText,
    required this.date,
    this.cardIds = const [],
    this.cardReversals = const [],
    this.positionLabels = const [],
    this.cardMeanings = const [],
    this.witchId,
    this.tags = const [],
    this.followUpNote = '',
    this.followUpDate,
    this.isSynced = false,
    this.isPublic = false,
  });

  /// Firestore에서 불러오기
  factory TarotDiary.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    final legacyCardId = data['cardId'] ?? '';
    final legacyResultText = data['resultText'] ?? '';

    return TarotDiary(
      id: doc.id,
      cardId: legacyCardId,
      spreadType: data['spreadType'] ?? 'one_card',
      myNote: data['myNote'] ?? '',
      resultText: legacyResultText,
      date: data['date'] is Timestamp
          ? (data['date'] as Timestamp).toDate()
          : DateTime.now(),
      cardIds: data['cardIds'] != null
          ? List<String>.from(data['cardIds'])
          : (legacyCardId.isNotEmpty ? [legacyCardId] : []),
      cardReversals: data['cardReversals'] != null
          ? List<bool>.from(data['cardReversals'])
          : [false],
      positionLabels: data['positionLabels'] != null
          ? List<String>.from(data['positionLabels'])
          : ['현재 상황'],
      cardMeanings: data['cardMeanings'] != null
          ? List<String>.from(data['cardMeanings'])
          : [legacyResultText],
      witchId: data['witchId'],
      tags: data['tags'] != null ? List<String>.from(data['tags']) : [],
      followUpNote: data['followUpNote'] ?? '',
      followUpDate: data['followUpDate'] is Timestamp
          ? (data['followUpDate'] as Timestamp).toDate()
          : null,
      isSynced: true,
      isPublic: data['isPublic'] ?? false,
    );
  }

  /// Firestore에 저장하기 위한 Map 변환
  Map<String, dynamic> toMap() {
    return {
      'cardId': cardId,
      'spreadType': spreadType,
      'myNote': myNote,
      'resultText': resultText,
      'date': Timestamp.fromDate(date),
      'cardIds': cardIds,
      'cardReversals': cardReversals,
      'positionLabels': positionLabels,
      'cardMeanings': cardMeanings,
      'witchId': witchId,
      'tags': tags,
      'followUpNote': followUpNote,
      'followUpDate':
          followUpDate != null ? Timestamp.fromDate(followUpDate!) : null,
      'isPublic': isPublic,
      'expireAt': Timestamp.fromDate(DateTime.now().add(const Duration(days: 365 * 3))),
    };
  }

  /// 후일담 메모를 추가한 새 인스턴스를 반환
  TarotDiary copyWithFollowUp({
    required String followUpNote,
    required DateTime followUpDate,
  }) {
    return TarotDiary(
      id: id,
      cardId: cardId,
      spreadType: spreadType,
      myNote: myNote,
      resultText: resultText,
      date: date,
      cardIds: cardIds,
      cardReversals: cardReversals,
      positionLabels: positionLabels,
      cardMeanings: cardMeanings,
      witchId: witchId,
      tags: tags,
      followUpNote: followUpNote,
      followUpDate: followUpDate,
      isSynced: false,
      isPublic: isPublic,
    );
  }

  /// 태그를 수정한 새 인스턴스를 반환
  TarotDiary copyWithTags(List<String> newTags) {
    return TarotDiary(
      id: id,
      cardId: cardId,
      spreadType: spreadType,
      myNote: myNote,
      resultText: resultText,
      date: date,
      cardIds: cardIds,
      cardReversals: cardReversals,
      positionLabels: positionLabels,
      cardMeanings: cardMeanings,
      witchId: witchId,
      tags: newTags,
      followUpNote: followUpNote,
      followUpDate: followUpDate,
      isSynced: false,
      isPublic: isPublic,
    );
  }
}
