import 'package:cloud_firestore/cloud_firestore.dart';

class Comment {
  final String id;
  final String diaryId;
  final String authorId;
  final String authorNickname;
  final String content;
  final DateTime createdAt;

  Comment({
    required this.id,
    required this.diaryId,
    required this.authorId,
    required this.authorNickname,
    required this.content,
    required this.createdAt,
  });

  factory Comment.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Comment(
      id: doc.id,
      diaryId: data['diaryId'] ?? '',
      authorId: data['authorId'] ?? '',
      authorNickname: data['authorNickname'] ?? 'Unknown',
      content: data['content'] ?? '',
      createdAt: data['createdAt'] is Timestamp
          ? (data['createdAt'] as Timestamp).toDate()
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'diaryId': diaryId,
      'authorId': authorId,
      'authorNickname': authorNickname,
      'content': content,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}
