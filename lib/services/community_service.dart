import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/community_post.dart';
import '../models/community_comment.dart';

class CommunityService {
  static final CommunityService _instance = CommunityService._internal();
  static CommunityService get instance => _instance;
  CommunityService._internal();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<CommunityPost>> getPublicDiariesStream() {
    return _firestore
        .collection('community_posts')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => CommunityPost.fromFirestore(doc)).toList();
    });
  }

  Stream<List<CommunityComment>> getCommentsStream(String postId) {
    return _firestore
        .collection('community_posts')
        .doc(postId)
        .collection('comments')
        .orderBy('createdAt', descending: false)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => CommunityComment.fromFirestore(doc)).toList();
    });
  }

  Future<void> addComment(String postId, String content) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) throw Exception('로그인이 필요합니다.');

    final userDoc = await _firestore.collection('users').doc(user.uid).get();
    final nickname = userDoc.data()?['nickname'] ?? '이름 없는 마녀';

    final commentRef = _firestore
        .collection('community_posts')
        .doc(postId)
        .collection('comments')
        .doc();

    final comment = CommunityComment(
      id: commentRef.id,
      postId: postId,
      authorId: user.uid,
      authorNickname: nickname,
      content: content,
      language: 'ko', // 기본 로케일
      createdAt: DateTime.now(),
    );

    await commentRef.set(comment.toMap());
    
    // Update comment count
    final postRef = _firestore.collection('community_posts').doc(postId);
    await postRef.update({
      'commentCount': FieldValue.increment(1),
    });
  }

  Future<void> deleteComment(String postId, String commentId) async {
    await _firestore
        .collection('community_posts')
        .doc(postId)
        .collection('comments')
        .doc(commentId)
        .delete();

    // Update comment count
    final postRef = _firestore.collection('community_posts').doc(postId);
    await postRef.update({
      'commentCount': FieldValue.increment(-1),
    });
  }

  Future<void> toggleLike(String postId, String userId) async {
    final postRef = _firestore.collection('community_posts').doc(postId);
    
    await _firestore.runTransaction((transaction) async {
      final snapshot = await transaction.get(postRef);
      if (!snapshot.exists) return;

      final likes = List<String>.from(snapshot.data()?['likes'] ?? []);
      if (likes.contains(userId)) {
        likes.remove(userId);
      } else {
        likes.add(userId);
      }

      transaction.update(postRef, {'likes': likes, 'likeCount': likes.length});
    });
  }

  Future<void> reportContent(String type, String id, String reason) async {
    final user = FirebaseAuth.instance.currentUser;
    await _firestore.collection('reports').add({
      'targetType': type, // 'post' or 'comment'
      'targetId': id,
      'reporterId': user?.uid ?? 'anonymous',
      'reason': reason,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }
}
