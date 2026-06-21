import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import '../models/mail_model.dart';
import 'economy_service.dart';
import 'dart:async';

class MailService extends ChangeNotifier {
  static final MailService _instance = MailService._internal();
  factory MailService() => _instance;

  MailService._internal() {
    FirebaseAuth.instance.authStateChanges().listen((user) {
      if (user != null) {
        _startListeningToMails(user);
      } else {
        _stopListeningToMails();
      }
    });
  }

  List<MailModel> _mails = [];
  List<MailModel> get mails => _mails;

  StreamSubscription? _personalMailsSub;
  StreamSubscription? _globalMailsSub;
  StreamSubscription? _userDocSub;

  List<String> _claimedGlobalMails = [];
  List<String> _readGlobalMails = [];

  bool get hasUnreadOrUnclaimedMails {
    return _mails.any((m) => !m.isRead || (!m.isClaimed && m.rewards.isNotEmpty));
  }

  int get unreadCount {
    return _mails.where((m) => !m.isRead || (!m.isClaimed && m.rewards.isNotEmpty)).length;
  }

  void _startListeningToMails(User user) {
    _stopListeningToMails();

    // Listen to user's global mail claim history
    _userDocSub = FirebaseFirestore.instance.collection('users').doc(user.uid).snapshots().listen((doc) {
      if (doc.exists) {
        final data = doc.data()!;
        _claimedGlobalMails = List<String>.from(data['claimedGlobalMails'] ?? []);
        _readGlobalMails = List<String>.from(data['readGlobalMails'] ?? []);
        _mergeAndNotify();
      }
    });

    // Listen to personal mails
    _personalMailsSub = FirebaseFirestore.instance
        .collection('personal_mails')
        .where('targetUserId', isEqualTo: user.uid)
        .where('expiryDate', isGreaterThan: Timestamp.now())
        .snapshots()
        .listen((snapshot) {
      _mergeAndNotify(personalSnapshot: snapshot);
    });

    // Listen to global mails
    _globalMailsSub = FirebaseFirestore.instance
        .collection('global_mails')
        .where('expiryDate', isGreaterThan: Timestamp.now())
        .snapshots()
        .listen((snapshot) {
      _mergeAndNotify(globalSnapshot: snapshot);
    });
  }

  void _stopListeningToMails() {
    _personalMailsSub?.cancel();
    _globalMailsSub?.cancel();
    _userDocSub?.cancel();
    _mails.clear();
    notifyListeners();
  }

  QuerySnapshot? _lastPersonalSnapshot;
  QuerySnapshot? _lastGlobalSnapshot;

  void _mergeAndNotify({QuerySnapshot? personalSnapshot, QuerySnapshot? globalSnapshot}) {
    if (personalSnapshot != null) _lastPersonalSnapshot = personalSnapshot;
    if (globalSnapshot != null) _lastGlobalSnapshot = globalSnapshot;

    final List<MailModel> mergedMails = [];

    // Add personal mails
    if (_lastPersonalSnapshot != null) {
      for (var doc in _lastPersonalSnapshot!.docs) {
        mergedMails.add(MailModel.fromFirestore(doc));
      }
    }

    // Add global mails (and apply local read/claimed status)
    if (_lastGlobalSnapshot != null) {
      for (var doc in _lastGlobalSnapshot!.docs) {
        var mail = MailModel.fromFirestore(doc);
        mail = mail.copyWith(
          isRead: _readGlobalMails.contains(mail.id),
          isClaimed: _claimedGlobalMails.contains(mail.id),
        );
        mergedMails.add(mail);
      }
    }

    // Sort by timestamp descending
    mergedMails.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    _mails = mergedMails;
    notifyListeners();
  }

  Future<void> markAsRead(MailModel mail) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    if (mail.isGlobal) {
      if (!_readGlobalMails.contains(mail.id)) {
        await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
          'readGlobalMails': FieldValue.arrayUnion([mail.id])
        });
      }
    } else {
      if (!mail.isRead) {
        await FirebaseFirestore.instance.collection('personal_mails').doc(mail.id).update({
          'isRead': true
        });
      }
    }
  }

  Future<bool> claimReward(MailModel mail) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null || mail.isClaimed || mail.rewards.isEmpty) return false;

    // Apply rewards
    final economy = EconomyService();
    if (mail.rewards.containsKey('coins')) {
      await economy.addCoins(mail.rewards['coins']!);
    }
    if (mail.rewards.containsKey('magicDust')) {
      await economy.addMagicDust(mail.rewards['magicDust']!);
    }

    // Mark as claimed
    if (mail.isGlobal) {
      await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
        'claimedGlobalMails': FieldValue.arrayUnion([mail.id]),
        'readGlobalMails': FieldValue.arrayUnion([mail.id]), // Automatically mark read
      });
    } else {
      await FirebaseFirestore.instance.collection('personal_mails').doc(mail.id).update({
        'isClaimed': true,
        'isRead': true,
      });
    }

    return true;
  }

  Future<void> claimAll() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final unclaimedMails = _mails.where((m) => !m.isClaimed && m.rewards.isNotEmpty).toList();
    if (unclaimedMails.isEmpty) return;

    int totalCoins = 0;
    int totalMagicDust = 0;
    List<String> globalMailsToUpdate = [];
    List<String> personalMailsToUpdate = [];

    for (var mail in unclaimedMails) {
      totalCoins += mail.rewards['coins'] ?? 0;
      totalMagicDust += mail.rewards['magicDust'] ?? 0;

      if (mail.isGlobal) {
        globalMailsToUpdate.add(mail.id);
      } else {
        personalMailsToUpdate.add(mail.id);
      }
    }

    final economy = EconomyService();
    if (totalCoins > 0) await economy.addCoins(totalCoins);
    if (totalMagicDust > 0) await economy.addMagicDust(totalMagicDust);

    final batch = FirebaseFirestore.instance.batch();

    if (globalMailsToUpdate.isNotEmpty) {
      batch.update(FirebaseFirestore.instance.collection('users').doc(user.uid), {
        'claimedGlobalMails': FieldValue.arrayUnion(globalMailsToUpdate),
        'readGlobalMails': FieldValue.arrayUnion(globalMailsToUpdate),
      });
    }

    for (var pId in personalMailsToUpdate) {
      batch.update(FirebaseFirestore.instance.collection('personal_mails').doc(pId), {
        'isClaimed': true,
        'isRead': true,
      });
    }

    await batch.commit();
  }

  // ================= ADMIN FUNCTIONS =================

  Future<void> sendGlobalMail({
    required String title,
    required String content,
    Map<String, int> rewards = const {},
    int expireDays = 30,
  }) async {
    await FirebaseFirestore.instance.collection('global_mails').add({
      'title': title,
      'content': content,
      'sender': 'Admin',
      'rewards': rewards,
      'timestamp': FieldValue.serverTimestamp(),
      'expiryDate': DateTime.now().add(Duration(days: expireDays)),
      'isGlobal': true,
    });
  }

  Future<void> sendPersonalMail({
    required String targetUserId,
    required String title,
    required String content,
    Map<String, int> rewards = const {},
    int expireDays = 30,
  }) async {
    await FirebaseFirestore.instance.collection('personal_mails').add({
      'targetUserId': targetUserId,
      'title': title,
      'content': content,
      'sender': 'Admin',
      'rewards': rewards,
      'timestamp': FieldValue.serverTimestamp(),
      'expiryDate': DateTime.now().add(Duration(days: expireDays)),
      'isGlobal': false,
      'isRead': false,
      'isClaimed': false,
    });
  }

  Future<void> updateMail({
    required String mailId,
    required bool isGlobal,
    String? title,
    String? content,
    Map<String, int>? rewards,
  }) async {
    final collection = isGlobal ? 'global_mails' : 'personal_mails';
    
    Map<String, dynamic> updates = {};
    if (title != null) updates['title'] = title;
    if (content != null) updates['content'] = content;
    if (rewards != null) updates['rewards'] = rewards;

    if (updates.isNotEmpty) {
      await FirebaseFirestore.instance.collection(collection).doc(mailId).update(updates);
    }
  }

  Future<void> deleteMail(String mailId, bool isGlobal) async {
    final collection = isGlobal ? 'global_mails' : 'personal_mails';
    await FirebaseFirestore.instance.collection(collection).doc(mailId).delete();
  }
}
