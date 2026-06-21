import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import '../data/tarot_data.dart';
import '../models/community_post.dart';
import '../models/community_comment.dart';
import '../widgets/gradient_background.dart';
import '../widgets/glass_container.dart';
import '../widgets/spread_layouts.dart';
import '../data/spread_type.dart';
import '../services/community_service.dart';
import '../services/translation_service.dart';
import 'package:flutter_tarot/l10n/app_localizations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../widgets/user_profile_avatar.dart';
import '../widgets/emoji_picker_widget.dart';
import '../widgets/top_floating_icons.dart';
import '../widgets/shared_bottom_nav_bar.dart';
import 'main_screen.dart';
import 'package:url_launcher/url_launcher.dart';
import '../widgets/spilling_like_button.dart';

class CommunityDetailScreen extends StatefulWidget {
  final CommunityPost post;

  const CommunityDetailScreen({super.key, required this.post});

  @override
  State<CommunityDetailScreen> createState() => _CommunityDetailScreenState();
}

class _CommunityDetailScreenState extends State<CommunityDetailScreen> {
  final TextEditingController _commentController = TextEditingController();
  final TranslationService _translationService = TranslationService();
  
  bool _isLiking = false;
  
  // 이모지 피커 상태
  bool _showEmojiPicker = false;
  final FocusNode _focusNode = FocusNode();
  
  // 번역 상태 저장용
  bool _isPostTranslating = false;
  String? _translatedPostContent;
  String? _translatedPostQuestion;
  
  // 댓글 번역 상태
  final Map<String, bool> _translatingComments = {};
  final Map<String, String> _translatedComments = {};

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        setState(() {
          _showEmojiPicker = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _commentController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _submitComment() async {
    final content = _commentController.text.trim();
    if (content.isEmpty) return;

    try {
      await CommunityService.instance.addComment(widget.post.id, content);
      _commentController.clear();
      FocusScope.of(context).unfocus();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${AppLocalizations.of(context)!.communityCommentFailed}$e')),
        );
      }
    }
  }

  void _toggleLike() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context)!.communityLoginRequired)));
      return;
    }
    setState(() {
      _isLiking = true;
    });
    try {
      await CommunityService.instance.toggleLike(widget.post.id, user.uid);
    } catch (e) {
      // ignore
    } finally {
      if (mounted) {
        setState(() {
          _isLiking = false;
        });
      }
    }
  }

  void _translatePost() async {
    if (_isPostTranslating) return;
    setState(() => _isPostTranslating = true);

    try {
      final docRef = FirebaseFirestore.instance.collection('community_posts').doc(widget.post.id);
      
      // 언어 코드를 기기 설정 언어에서 가져오거나 하드코딩
      final targetLocale = View.of(context).platformDispatcher.locale.languageCode;
      
      String translatedContent = widget.post.content;
      String translatedQuestion = widget.post.question;

      if (widget.post.content.isNotEmpty) {
        translatedContent = await _translationService.getOrTranslate(docRef, widget.post.content, targetLocale);
      }
      
      if (widget.post.question.isNotEmpty && widget.post.question != '타로 리딩') {
        // 질문도 번역 (선택 사항이나 UX 상 좋음)
        // 팁: 구조가 복잡해지므로 번역 서비스에선 텍스트만 번역함
        translatedQuestion = await _translationService.getOrTranslate(docRef, widget.post.question, '${targetLocale}_q');
      }

      if (mounted) {
        setState(() {
          _translatedPostContent = translatedContent;
          _translatedPostQuestion = translatedQuestion;
        });
      }
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('번역 실패: $e')));
    } finally {
      if (mounted) setState(() => _isPostTranslating = false);
    }
  }

  void _translateComment(CommunityComment comment) async {
    if (_translatingComments[comment.id] == true) return;
    setState(() => _translatingComments[comment.id] = true);

    try {
      final docRef = FirebaseFirestore.instance
          .collection('community_posts')
          .doc(widget.post.id)
          .collection('comments')
          .doc(comment.id);
      
      final targetLocale = View.of(context).platformDispatcher.locale.languageCode;
      
      final translated = await _translationService.getOrTranslate(docRef, comment.content, targetLocale);

      if (mounted) {
        setState(() {
          _translatedComments[comment.id] = translated;
        });
      }
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${AppLocalizations.of(context)!.communityTranslationFailed('')} $e')));
    } finally {
      if (mounted) setState(() => _translatingComments[comment.id] = false);
    }
  }

  void _report() async {
    final reason = await showDialog<String>(
      context: context,
      builder: (ctx) {
        String input = '';
        return AlertDialog(
          backgroundColor: Colors.deepPurple.shade900,
          title: Text(AppLocalizations.of(context)!.communityReportTitle, style: const TextStyle(color: Colors.white)),
          content: TextField(
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(hintText: AppLocalizations.of(context)!.communityReportHint, hintStyle: const TextStyle(color: Colors.white30)),
            onChanged: (val) => input = val,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, null),
              child: Text(AppLocalizations.of(context)!.communityReportCancel, style: const TextStyle(color: Colors.white54)),
            ),
            TextButton(
              onPressed: () => Navigator.pop(ctx, input),
              child: Text(AppLocalizations.of(context)!.communityReportSubmit, style: const TextStyle(color: Colors.redAccent)),
            ),
          ],
        );
      },
    );

    if (reason != null && reason.isNotEmpty && mounted) {
      await CommunityService.instance.reportContent('post', widget.post.id, reason);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context)!.communityReportSuccess)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final post = widget.post;
    final nickname = post.authorNickname.isNotEmpty ? post.authorNickname : AppLocalizations.of(context)!.communityNoName;
    
    // 번역된 텍스트가 있으면 그걸 보여주고 아니면 원문
    final targetLocale = View.of(context).platformDispatcher.locale.languageCode;
    final autoTranslatedContent = post.translations[targetLocale] as String?;
    final autoTranslatedQuestion = post.translations['${targetLocale}_q'] as String?;

    final displayContent = _translatedPostContent ?? autoTranslatedContent ?? post.content;
    final displayQuestion = _translatedPostQuestion ?? autoTranslatedQuestion ?? post.question;

    final cardIds = post.cardIds;
    final cardReversals = post.cardReversals.isNotEmpty ? post.cardReversals : List.generate(cardIds.length, (_) => false);
    
    SpreadType spreadType;
    if (cardIds.length == 1) spreadType = SpreadType.oneCard;
    else if (cardIds.length == 2) spreadType = SpreadType.twoCard;
    else if (cardIds.length == 3) spreadType = SpreadType.threeCard;
    else if (cardIds.length == 4) spreadType = SpreadType.fourCard;
    else if (cardIds.length == 5) spreadType = SpreadType.fiveCard;
    else if (cardIds.length == 10) spreadType = SpreadType.celticCross;
    else spreadType = SpreadType.oneCard;

    final shuffledDeck = cardIds.map((id) => getTarotDeck(context).firstWhere((c) => c.id == id, orElse: () => getTarotDeck(context).first)).toList();
    final selectedCardIndices = List.generate(shuffledDeck.length, (i) => i);
    final shuffledReversed = List.generate(shuffledDeck.length, (i) {
      if (i < cardReversals.length) return cardReversals[i];
      return false;
    });

    final currentUserId = FirebaseAuth.instance.currentUser?.uid;
    
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance.collection('community_posts').doc(post.id).snapshots(),
      builder: (context, snapshot) {
        List<String> likes = [];
        if (snapshot.hasData && snapshot.data!.exists) {
           final realData = snapshot.data!.data() as Map<String, dynamic>;
           likes = List<String>.from(realData['likes'] ?? []);
        }
        final isLiked = currentUserId != null && likes.contains(currentUserId);

        return Scaffold(
          bottomNavigationBar: SharedBottomNavBar(
            currentIndex: 2, // 커뮤니티는 2번 인덱스
            onTap: (index) {
              if (index != 2) {
                Navigator.popUntil(context, (route) => route.isFirst);
                mainScreenKey.currentState?.switchTab(index);
              }
            },
          ),
          body: Stack(
            children: [
              GradientBackground(
                child: SafeArea(
                  child: Column(
                    children: [
                      const SizedBox(height: 50),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.arrow_back, color: Colors.white),
                              onPressed: () => Navigator.pop(context),
                            ),
                            Text(nickname, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                            IconButton(
                              icon: const Icon(Icons.report_problem_outlined, color: Colors.white54),
                              onPressed: _report,
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // 질문
                          if (displayQuestion.isNotEmpty && displayQuestion != '타로 리딩' && displayQuestion != AppLocalizations.of(context)!.diaryTarotReading) ...[
                            GlassContainer(
                              padding: const EdgeInsets.all(16),
                              borderRadius: 16,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(AppLocalizations.of(context)!.communityTarotQuestion, style: const TextStyle(color: Colors.amberAccent, fontWeight: FontWeight.bold, fontSize: 14)),
                                  const SizedBox(height: 8),
                                  Text(displayQuestion, style: const TextStyle(color: Colors.white, fontSize: 16)),
                                ],
                              ),
                            ),
                            const SizedBox(height: 20),
                          ],

                          // 카드 레이아웃
                          SpreadLayoutBuilder(
                            spreadType: spreadType,
                            selectedCardIndices: selectedCardIndices,
                            shuffledDeck: shuffledDeck,
                            shuffledReversed: shuffledReversed,
                            isForChat: false,
                          ),
                          const SizedBox(height: 20),

                          // 리딩 결과
                          GlassContainer(
                            padding: const EdgeInsets.all(16),
                            borderRadius: 16,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  displayContent.isNotEmpty ? displayContent : AppLocalizations.of(context)!.communityNoInterpretation,
                                  style: const TextStyle(color: Colors.white, fontSize: 15, height: 1.5),
                                ),
                                const SizedBox(height: 12),
                                // 게시물 번역 버튼
                                if (_translatedPostContent == null)
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: OutlinedButton(
                                      onPressed: _translatePost,
                                      style: OutlinedButton.styleFrom(
                                        side: const BorderSide(color: Colors.orange),
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                      ),
                                      child: _isPostTranslating
                                          ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.orange))
                                          : Text(AppLocalizations.of(context)!.buttonTranslate, style: const TextStyle(color: Colors.white, fontSize: 13)),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),

                          // 좋아요 버튼
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SpillingLikeButton(
                                child: ElevatedButton.icon(
                                  onPressed: _isLiking ? null : _toggleLike,
                                  icon: ShaderMask(
                                    shaderCallback: (bounds) => const LinearGradient(
                                      colors: [Colors.pinkAccent, Colors.purpleAccent],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ).createShader(bounds),
                                    child: FaIcon(
                                      isLiked ? FontAwesomeIcons.solidHeart : FontAwesomeIcons.heart,
                                      color: Colors.white,
                                    ),
                                  ),
                                  label: Text('${AppLocalizations.of(context)!.communityLike} ${likes.length}', style: const TextStyle(color: Colors.white)),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.deepPurple.withOpacity(0.5),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          const Divider(color: Colors.white24),
                          const SizedBox(height: 10),
                          Text(AppLocalizations.of(context)!.communityComments, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                          const SizedBox(height: 10),

                          // 댓글 리스트
                          StreamBuilder<List<CommunityComment>>(
                            stream: CommunityService.instance.getCommentsStream(post.id),
                            builder: (context, commentSnapshot) {
                              if (!commentSnapshot.hasData) return const SizedBox();
                              final comments = commentSnapshot.data!;
                              if (comments.isEmpty) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 20),
                                  child: Center(child: Text(AppLocalizations.of(context)!.communityFirstCommentPrompt, style: const TextStyle(color: Colors.white54))),
                                );
                              }
                              return ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: comments.length,
                                itemBuilder: (context, index) {
                                  final comment = comments[index];
                                  final isMyComment = comment.authorId == currentUserId;
                                  
                                  final displayComment = _translatedComments[comment.id] ?? comment.content;
                                  final isTranslating = _translatingComments[comment.id] == true;

                                  return Padding(
                                    padding: const EdgeInsets.only(bottom: 12),
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        UserProfileAvatar(
                                          userId: comment.authorId,
                                          radius: 12,
                                        ),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  Text(comment.authorNickname, style: const TextStyle(color: Colors.white70, fontWeight: FontWeight.bold, fontSize: 13)),
                                                  const SizedBox(width: 8),
                                                  Text(DateFormat('MM.dd HH:mm').format(comment.createdAt), style: const TextStyle(color: Colors.white38, fontSize: 11)),
                                                ],
                                              ),
                                              const SizedBox(height: 4),
                                              Text(displayComment, style: const TextStyle(color: Colors.white, fontSize: 14)),
                                              
                                              // 댓글 번역 버튼
                                              if (_translatedComments[comment.id] == null)
                                                GestureDetector(
                                                  onTap: () => _translateComment(comment),
                                                  child: Padding(
                                                    padding: const EdgeInsets.only(top: 4.0),
                                                    child: Row(
                                                      mainAxisSize: MainAxisSize.min,
                                                      children: [
                                                        if (isTranslating)
                                                          const SizedBox(width: 10, height: 10, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.cyanAccent))
                                                        else
                                                          Text(AppLocalizations.of(context)!.buttonTranslate, style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                            ],
                                          ),
                                        ),
                                        if (isMyComment)
                                          IconButton(
                                            icon: const Icon(Icons.close, size: 16, color: Colors.white38),
                                            onPressed: () {
                                              CommunityService.instance.deleteComment(post.id, comment.id);
                                            },
                                          ),
                                      ],
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  // 댓글 입력창
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    color: Colors.black.withOpacity(0.3),
                    child: SafeArea(
                      top: false,
                      child: Row(
                        children: [
                          IconButton(
                            icon: Icon(_showEmojiPicker ? Icons.keyboard : Icons.emoji_emotions_outlined, color: Colors.white54),
                            onPressed: () {
                              setState(() {
                                _showEmojiPicker = !_showEmojiPicker;
                                if (_showEmojiPicker) {
                                  FocusScope.of(context).unfocus();
                                } else {
                                  _focusNode.requestFocus();
                                }
                              });
                            },
                          ),
                          Expanded(
                            child: TextField(
                              controller: _commentController,
                              focusNode: _focusNode,
                              style: const TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                hintText: AppLocalizations.of(context)!.communityCommentInputHint,
                                hintStyle: const TextStyle(color: Colors.white38),
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: BorderSide.none),
                                filled: true,
                                fillColor: Colors.white10,
                                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              ),
                              onSubmitted: (_) => _submitComment(),
                            ),
                          ),
                          const SizedBox(width: 8),
                          IconButton(
                            icon: const Icon(Icons.send, color: Colors.cyanAccent),
                            onPressed: _submitComment,
                          ),
                        ],
                      ),
                    ),
                  ),
                  EmojiPickerWidget(
                    controller: _commentController,
                    isVisible: _showEmojiPicker,
                  ),
                ],
              ),
            ),
          ),
          const Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: TopFloatingIcons(),
          ),
        ],
      ),
    );
      }
    );
  }
}
