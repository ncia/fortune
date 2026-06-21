import 'package:cloud_firestore/cloud_firestore.dart';

class CommunityComment {
  final String id;
  final String postId;
  final String authorId;
  final String authorNickname;
  final String content;
  final String language;
  final Map<String, dynamic> translations;
  final DateTime createdAt;

  CommunityComment({
    required this.id,
    required this.postId,
    required this.authorId,
    required this.authorNickname,
    required this.content,
    required this.language,
    this.translations = const {},
    required this.createdAt,
  });

  factory CommunityComment.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return CommunityComment(
      id: doc.id,
      postId: data['postId'] ?? '',
      authorId: data['authorId'] ?? '',
      authorNickname: data['authorNickname'] ?? 'Anonymous',
      content: data['content'] ?? '',
      language: data['language'] ?? 'ko',
      translations: data['translations'] != null ? Map<String, dynamic>.from(data['translations']) : {},
      createdAt: data['createdAt'] != null ? (data['createdAt'] as Timestamp).toDate() : DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'postId': postId,
      'authorId': authorId,
      'authorNickname': authorNickname,
      'content': content,
      'language': language,
      'translations': translations,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  CommunityComment copyWith({
    String? id,
    String? postId,
    String? authorId,
    String? authorNickname,
    String? content,
    String? language,
    Map<String, dynamic>? translations,
    DateTime? createdAt,
  }) {
    return CommunityComment(
      id: id ?? this.id,
      postId: postId ?? this.postId,
      authorId: authorId ?? this.authorId,
      authorNickname: authorNickname ?? this.authorNickname,
      content: content ?? this.content,
      language: language ?? this.language,
      translations: translations ?? this.translations,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
