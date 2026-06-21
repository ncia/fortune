import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'dart:async';

class EconomyService extends ChangeNotifier {
  static final EconomyService _instance = EconomyService._internal();
  factory EconomyService() => _instance;
  
  StreamSubscription<DocumentSnapshot>? _firestoreSubscription;

  EconomyService._internal() {
    FirebaseAuth.instance.authStateChanges().listen((user) {
      _initListener(user);
    });
  }

  int _coins = 0;
  int _magicDust = 0;
  int _worldTreeExp = 0;
  int _crystalBallExp = 0;

  int get coins => _coins;
  int get magicDust => _magicDust;
  int get worldTreeExp => _worldTreeExp;
  int get crystalBallExp => _crystalBallExp;

  // 매 레벨별 세분화 기하급수적 성장 알고리즘 (총합 1,000,000, 끝자리 항상 0, 중복 없음)
  static const List<int> _expTable = [
    100, 110, 120, 130, 140, 150, 160, 170, 180, 190, 200, 210, 220, 230, 250, 300, 350, 410, 480, 550, 630, 710, 800, 890, 1000, 1100, 1220, 1340, 1470, 1600, 1750, 1900, 2050, 2220, 2390, 2570, 2760, 2960, 3160, 3370, 3590, 3820, 4060, 4310, 4560, 4830, 5100, 5380, 5680, 5980, 6290, 6610, 6940, 7270, 7620, 7980, 8350, 8730, 9110, 9500, 9910, 10330, 10760, 11200, 11650, 12110, 12590, 13070, 13560, 14070, 14580, 15110, 15650, 16200, 16760, 17330, 17920, 18510, 19120, 19740, 20370, 21010, 21670, 22340, 23020, 23710, 24410, 25130, 25860, 26600, 27350, 28120, 28900, 29690, 30500, 31310, 32140, 32990, 33850, 34610
  ];

  int getRequiredExpForLevel(int level) {
    if (level >= 100 || level < 1) return 0; // 만렙
    return _expTable[level - 1];
  }

  int getLevelFromTotalExp(int totalExp) {
    int level = 1;
    int expNeeded = getRequiredExpForLevel(level);
    int currentExp = totalExp;
    while (currentExp >= expNeeded && level < 100) {
      currentExp -= expNeeded;
      level++;
      expNeeded = getRequiredExpForLevel(level);
    }
    return level;
  }

  int getCurrentLevelExp(int totalExp) {
    int level = 1;
    int expNeeded = getRequiredExpForLevel(level);
    int currentExp = totalExp;
    while (currentExp >= expNeeded && level < 100) {
      currentExp -= expNeeded;
      level++;
      expNeeded = getRequiredExpForLevel(level);
    }
    return currentExp;
  }

  void _initListener(User? user) {
    _firestoreSubscription?.cancel();
    if (user != null) {
      _firestoreSubscription = FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .snapshots()
          .listen((doc) {
        if (doc.exists) {
          final data = doc.data()!;
          _coins = data['coins'] ?? 0;
          _magicDust = data['magicDust'] ?? 0;
          _worldTreeExp = data['worldTreeExp'] ?? 0;
          _crystalBallExp = data['crystalBallExp'] ?? 0;
          notifyListeners();
        } else {
          _coins = 0;
          _magicDust = 0;
          _worldTreeExp = 0;
          _crystalBallExp = 0;
          notifyListeners();
        }
      });
    } else {
      _coins = 0;
      _magicDust = 0;
      _worldTreeExp = 0;
      _crystalBallExp = 0;
      notifyListeners();
    }
  }

  // Initialize new user with 3 coins if they don't have the document or fields yet
  Future<void> initializeNewUser() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final docRef = FirebaseFirestore.instance.collection('users').doc(user.uid);
      final doc = await docRef.get();
      if (!doc.exists) {
        await docRef.set({
          'coins': 3,
          'magicDust': 0,
          'worldTreeExp': 0,
          'crystalBallExp': 0,
          'createdAt': FieldValue.serverTimestamp(),
          'role': 'user',
        }, SetOptions(merge: true));
      } else {
        // If doc exists but no coins field, give them 3
        final data = doc.data()!;
        if (!data.containsKey('coins')) {
          await docRef.update({'coins': 3});
        }
      }
    }
  }

  Future<bool> deductCoin(int amount) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return false;

    // 테스트를 위한 임시 로직: 코인이 부족하면 100 코인을 무료로 충전해줍니다.
    if (_coins < amount) {
      await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
        'coins': FieldValue.increment(100),
      });
      _coins += 100;
    }

    if (_coins >= amount) {
      await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
        'coins': FieldValue.increment(-amount),
      });
      return true;
    }
    return false;
  }

  Future<void> addMagicDust(int amount) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
        'magicDust': FieldValue.increment(amount),
      });
    }
  }

  Future<void> addCoins(int amount) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
        'coins': FieldValue.increment(amount),
      });
    }
  }

  Future<bool> levelUpWorldTree(int cost) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return false;

    if (_magicDust >= cost) {
      await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
        'magicDust': FieldValue.increment(-cost),
        'worldTreeExp': FieldValue.increment(cost),
        'lastWateredAt': FieldValue.serverTimestamp(),
      });
      return true;
    }
    return false;
  }

  Future<bool> upgradeCrystalBall(int cost) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return false;

    if (_magicDust >= cost) {
      await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
        'magicDust': FieldValue.increment(-cost),
        'crystalBallExp': FieldValue.increment(cost),
      });
      return true;
    }
    return false;
  }
}
