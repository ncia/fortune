import 'package:cloud_firestore/cloud_firestore.dart';

class MailModel {
  final String id;
  final String title;
  final String content;
  final String sender;
  final DateTime timestamp;
  final DateTime expiryDate;
  final bool isRead;
  final bool isClaimed;
  final Map<String, int> rewards;
  final bool isGlobal;
  final String? targetUserId;

  MailModel({
    required this.id,
    required this.title,
    required this.content,
    required this.sender,
    required this.timestamp,
    required this.expiryDate,
    this.isRead = false,
    this.isClaimed = false,
    this.rewards = const {},
    this.isGlobal = false,
    this.targetUserId,
  });

  factory MailModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};
    
    return MailModel(
      id: doc.id,
      title: data['title'] ?? '',
      content: data['content'] ?? '',
      sender: data['sender'] ?? 'System',
      timestamp: (data['timestamp'] as Timestamp?)?.toDate() ?? DateTime.now(),
      expiryDate: (data['expiryDate'] as Timestamp?)?.toDate() ?? DateTime.now().add(const Duration(days: 30)),
      isRead: data['isRead'] ?? false,
      isClaimed: data['isClaimed'] ?? false,
      rewards: Map<String, int>.from(data['rewards'] ?? {}),
      isGlobal: data['isGlobal'] ?? false,
      targetUserId: data['targetUserId'],
    );
  }

  // To update a global mail to the user's specific state (e.g., claimed)
  MailModel copyWith({
    bool? isRead,
    bool? isClaimed,
  }) {
    return MailModel(
      id: id,
      title: title,
      content: content,
      sender: sender,
      timestamp: timestamp,
      expiryDate: expiryDate,
      isRead: isRead ?? this.isRead,
      isClaimed: isClaimed ?? this.isClaimed,
      rewards: rewards,
      isGlobal: isGlobal,
      targetUserId: targetUserId,
    );
  }
}
