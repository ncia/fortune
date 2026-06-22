import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive/hive.dart';

part 'saju_diary.g.dart';

@HiveType(typeId: 0)
class SajuDiary extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String sajuData;

  @HiveField(2)
  final String resultText;

  @HiveField(3)
  String myNote;

  @HiveField(4)
  final DateTime date;

  @HiveField(5)
  final String? witchId;

  @HiveField(6)
  List<String> tags;

  @HiveField(7)
  String followUpNote;

  @HiveField(8)
  DateTime? followUpDate;

  @HiveField(9, defaultValue: false)
  bool isSynced;

  @HiveField(10, defaultValue: false)
  bool isPublic;

  SajuDiary({
    required this.id,
    required this.sajuData,
    required this.myNote,
    required this.resultText,
    required this.date,
    this.witchId,
    this.tags = const [],
    this.followUpNote = '',
    this.followUpDate,
    this.isSynced = false,
    this.isPublic = false,
  });

  factory SajuDiary.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return SajuDiary(
      id: doc.id,
      sajuData: data['sajuData'] ?? '',
      myNote: data['myNote'] ?? '',
      resultText: data['resultText'] ?? '',
      date: data['date'] is Timestamp
          ? (data['date'] as Timestamp).toDate()
          : DateTime.now(),
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

  Map<String, dynamic> toMap() {
    return {
      'sajuData': sajuData,
      'myNote': myNote,
      'resultText': resultText,
      'date': Timestamp.fromDate(date),
      'witchId': witchId,
      'tags': tags,
      'followUpNote': followUpNote,
      'followUpDate':
          followUpDate != null ? Timestamp.fromDate(followUpDate!) : null,
      'isPublic': isPublic,
      'expireAt': Timestamp.fromDate(DateTime.now().add(const Duration(days: 365 * 3))),
    };
  }

  SajuDiary copyWithFollowUp({
    required String followUpNote,
    required DateTime followUpDate,
  }) {
    return SajuDiary(
      id: id,
      sajuData: sajuData,
      myNote: myNote,
      resultText: resultText,
      date: date,
      witchId: witchId,
      tags: tags,
      followUpNote: followUpNote,
      followUpDate: followUpDate,
      isSynced: false,
      isPublic: isPublic,
    );
  }

  SajuDiary copyWithTags(List<String> newTags) {
    return SajuDiary(
      id: id,
      sajuData: sajuData,
      myNote: myNote,
      resultText: resultText,
      date: date,
      witchId: witchId,
      tags: newTags,
      followUpNote: followUpNote,
      followUpDate: followUpDate,
      isSynced: false,
      isPublic: isPublic,
    );
  }
}
