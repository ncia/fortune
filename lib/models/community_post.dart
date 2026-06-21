import 'package:cloud_firestore/cloud_firestore.dart';

class CommunityPost {
  final String id;
  final String diaryId;
  final String authorId;
  final String authorNickname;
  final List<String> cardIds;
  final List<bool> cardReversals;
  final String question;
  final String content;
  final String language;
  final Map<String, dynamic> translations;
  final int likeCount;
  final int commentCount;
  final DateTime createdAt;
  final List<String> tags;

  CommunityPost({
    required this.id,
    required this.diaryId,
    required this.authorId,
    required this.authorNickname,
    required this.cardIds,
    required this.cardReversals,
    required this.question,
    required this.content,
    required this.language,
    this.translations = const {},
    this.likeCount = 0,
    this.commentCount = 0,
    required this.createdAt,
    this.tags = const [],
  });

  factory CommunityPost.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return CommunityPost(
      id: doc.id,
      diaryId: data['diaryId'] ?? '',
      authorId: data['authorId'] ?? '',
      authorNickname: data['authorNickname'] ?? 'Anonymous',
      cardIds: List<String>.from(data['cardIds'] ?? []),
      cardReversals: List<bool>.from(data['cardReversals'] ?? []),
      question: data['question'] ?? '',
      content: data['content'] ?? '',
      language: data['language'] ?? 'ko',
      translations: data['translations'] != null ? Map<String, dynamic>.from(data['translations']) : {},
      likeCount: data['likeCount'] ?? 0,
      commentCount: data['commentCount'] ?? 0,
      createdAt: data['createdAt'] != null ? (data['createdAt'] as Timestamp).toDate() : DateTime.now(),
      tags: List<String>.from(data['tags'] ?? []),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'diaryId': diaryId,
      'authorId': authorId,
      'authorNickname': authorNickname,
      'cardIds': cardIds,
      'cardReversals': cardReversals,
      'question': question,
      'content': content,
      'language': language,
      'translations': translations,
      'likeCount': likeCount,
      'commentCount': commentCount,
      'createdAt': Timestamp.fromDate(createdAt),
      'tags': tags,
    };
  }

  CommunityPost copyWith({
    String? id,
    String? diaryId,
    String? authorId,
    String? authorNickname,
    List<String>? cardIds,
    List<bool>? cardReversals,
    String? question,
    String? content,
    String? language,
    Map<String, dynamic>? translations,
    int? likeCount,
    int? commentCount,
    DateTime? createdAt,
    List<String>? tags,
  }) {
    return CommunityPost(
      id: id ?? this.id,
      diaryId: diaryId ?? this.diaryId,
      authorId: authorId ?? this.authorId,
      authorNickname: authorNickname ?? this.authorNickname,
      cardIds: cardIds ?? this.cardIds,
      cardReversals: cardReversals ?? this.cardReversals,
      question: question ?? this.question,
      content: content ?? this.content,
      language: language ?? this.language,
      translations: translations ?? this.translations,
      likeCount: likeCount ?? this.likeCount,
      commentCount: commentCount ?? this.commentCount,
      createdAt: createdAt ?? this.createdAt,
      tags: tags ?? this.tags,
    );
  }
}
