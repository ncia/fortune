import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/community_post.dart';
import '../data/tarot_data.dart';
import 'glass_container.dart';
import '../screens/community_detail_screen.dart';
import 'package:flutter_tarot/l10n/app_localizations.dart';
import 'user_profile_avatar.dart';
import 'spilling_like_button.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CommunityFeedItem extends StatelessWidget {
  final CommunityPost post;

  const CommunityFeedItem({super.key, required this.post});

  String _getTimeAgo(DateTime date, BuildContext context) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 0) {
      return AppLocalizations.of(context)!.diaryDaysAgo(difference.inDays);
    } else if (difference.inHours > 0) {
      return AppLocalizations.of(context)!.diaryHoursAgo(difference.inHours);
    } else if (difference.inMinutes > 0) {
      return AppLocalizations.of(context)!.diaryMinutesAgo(difference.inMinutes);
    } else {
      return AppLocalizations.of(context)!.diaryJustNow;
    }
  }

  @override
  Widget build(BuildContext context) {
    final nickname = post.authorNickname.isNotEmpty ? post.authorNickname : AppLocalizations.of(context)!.communityNoName;
    final formattedDate = DateFormat('yyyy.MM.dd HH:mm').format(post.createdAt);
    final targetLocale = Localizations.localeOf(context).languageCode;
    final displayContent = post.translations[targetLocale] as String? ?? post.content;
    final displayQuestion = post.translations['${targetLocale}_q'] as String? ?? post.question;
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: GlassContainer(
        borderRadius: 16,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CommunityDetailScreen(post: post),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header (Nickname & Date)
                Row(
                  children: [
                    UserProfileAvatar(userId: post.authorId, radius: 16),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            nickname,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(
                                  text: formattedDate,
                                  style: const TextStyle(
                                    color: Colors.amberAccent,
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                TextSpan(
                                  text: '  ${_getTimeAgo(post.createdAt, context)}',
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 11,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                
                // Content (Cards & Text)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (post.cardIds.isNotEmpty) ...[
                      _buildThumbnail(context, post.cardIds.first),
                      const SizedBox(width: 12),
                    ],
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (displayQuestion.isNotEmpty && displayQuestion != '타로 리딩') ...[
                            Text(
                              'Q. $displayQuestion',
                              style: const TextStyle(
                                color: Colors.amberAccent,
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                          ],
                          Text(
                            displayContent,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                              height: 1.4,
                            ),
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 12),
                const Divider(color: Colors.white24, height: 1),
                const SizedBox(height: 8),
                
                // Footer (Likes & Comments)
                Row(
                  children: [
                    SpillingLikeButton(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ShaderMask(
                            shaderCallback: (bounds) => const LinearGradient(
                              colors: [Colors.pinkAccent, Colors.purpleAccent],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ).createShader(bounds),
                            child: const FaIcon(FontAwesomeIcons.solidHeart, color: Colors.white, size: 16),
                          ),
                          const SizedBox(width: 4),
                          Text('${AppLocalizations.of(context)!.communityLike} ${post.likeCount}', style: const TextStyle(color: Colors.white70, fontSize: 13)),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    const Icon(Icons.chat_bubble_outline, color: Colors.white70, size: 16),
                    const SizedBox(width: 4),
                    Text('${AppLocalizations.of(context)!.communityComments} ${post.commentCount}', style: const TextStyle(color: Colors.white70, fontSize: 13)),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildThumbnail(BuildContext context, String cardId) {
    final card = getTarotDeck(context).firstWhere((c) => c.id == cardId, orElse: () => getTarotDeck(context).first);
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Image.asset(
        card.imagePath,
        width: 60,
        height: 90,
        fit: BoxFit.cover,
      ),
    );
  }
}
