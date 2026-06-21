import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavoriteService {
  static const String _localKey = 'guest_favorite_cards';

  // 즐겨찾기 상태 토글 (있으면 제거, 없으면 추가)
  static Future<bool> toggleFavorite(String cardId) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      // 로그인 사용자: Firestore
      final docRef = FirebaseFirestore.instance.collection('users').doc(user.uid);
      final docSnap = await docRef.get();
      List<dynamic> favorites = [];
      if (docSnap.exists && docSnap.data()!.containsKey('favoriteCards')) {
        favorites = List.from(docSnap.data()!['favoriteCards']);
      }

      bool isNowFavorite = false;
      if (favorites.contains(cardId)) {
        favorites.remove(cardId);
      } else {
        favorites.add(cardId);
        isNowFavorite = true;
      }
      
      await docRef.set({'favoriteCards': favorites}, SetOptions(merge: true));
      return isNowFavorite;
    } else {
      // 게스트 사용자: SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      List<String> favorites = prefs.getStringList(_localKey) ?? [];
      
      bool isNowFavorite = false;
      if (favorites.contains(cardId)) {
        favorites.remove(cardId);
      } else {
        favorites.add(cardId);
        isNowFavorite = true;
      }
      
      await prefs.setStringList(_localKey, favorites);
      return isNowFavorite;
    }
  }

  // 특정 카드가 즐겨찾기인지 확인
  static Future<bool> isFavorite(String cardId) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final docRef = FirebaseFirestore.instance.collection('users').doc(user.uid);
      final docSnap = await docRef.get();
      if (docSnap.exists && docSnap.data()!.containsKey('favoriteCards')) {
        List<dynamic> favorites = docSnap.data()!['favoriteCards'];
        return favorites.contains(cardId);
      }
      return false;
    } else {
      final prefs = await SharedPreferences.getInstance();
      List<String> favorites = prefs.getStringList(_localKey) ?? [];
      return favorites.contains(cardId);
    }
  }

  // 모든 즐겨찾기 카드 ID 가져오기
  static Future<List<String>> getFavoriteCards() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final docRef = FirebaseFirestore.instance.collection('users').doc(user.uid);
      final docSnap = await docRef.get();
      if (docSnap.exists && docSnap.data()!.containsKey('favoriteCards')) {
        return List<String>.from(docSnap.data()!['favoriteCards']);
      }
      return [];
    } else {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getStringList(_localKey) ?? [];
    }
  }
}
