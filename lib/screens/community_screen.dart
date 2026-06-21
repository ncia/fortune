import 'package:flutter/material.dart';
import '../widgets/gradient_background.dart';
import '../widgets/community_feed_item.dart';
import '../services/community_service.dart';
import '../widgets/top_floating_icons.dart';
import '../widgets/shared_bottom_nav_bar.dart';
import '../models/community_post.dart';
import 'main_screen.dart';
import 'package:flutter_tarot/l10n/app_localizations.dart';

class CommunityScreen extends StatelessWidget {
  const CommunityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          GradientBackground(
            child: SafeArea(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 60, 16, 10),
                    child: Text(
                      AppLocalizations.of(context)!.communityTitle,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Expanded(
                    child: StreamBuilder<List<CommunityPost>>(
                      stream: CommunityService.instance.getPublicDiariesStream(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Center(child: CircularProgressIndicator(color: Colors.cyanAccent));
                        }

                        if (snapshot.hasError) {
                          return Center(
                            child: Text(
                              '${AppLocalizations.of(context)!.communityErrorLoading}${snapshot.error}',
                              style: const TextStyle(color: Colors.white70),
                              textAlign: TextAlign.center,
                            ),
                          );
                        }

                        final posts = snapshot.data ?? [];

                        if (posts.isEmpty) {
                          return Center(
                            child: Text(
                              AppLocalizations.of(context)!.communityEmptyFeed,
                              style: const TextStyle(color: Colors.white70),
                              textAlign: TextAlign.center,
                            ),
                          );
                        }

                        return ListView.builder(
                          padding: const EdgeInsets.only(top: 8, bottom: 24),
                          itemCount: posts.length,
                          itemBuilder: (context, index) {
                            return CommunityFeedItem(post: posts[index]);
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              child: TopFloatingIcons(
                // 커뮤니티 화면이므로 특별히 동작을 비활성화하거나 할 수 있지만, 
                // top_floating_icons.dart 내에서 현재 라우트 체크를 하므로 기본값 사용
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: SharedBottomNavBar(
        currentIndex: mainScreenKey.currentState?.currentIndex ?? 0,
        onTap: (index) {
          mainScreenKey.currentState?.switchTab(index);
          Navigator.popUntil(context, (route) => route.isFirst);
        },
      ),
    );
  }
}

