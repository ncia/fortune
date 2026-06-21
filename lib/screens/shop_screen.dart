import 'package:flutter/material.dart';
import '../widgets/gradient_background.dart';
import '../widgets/glass_container.dart';
import '../widgets/top_floating_icons.dart';
import '../widgets/shared_bottom_nav_bar.dart';
import '../services/theme_manager.dart';
import '../services/economy_service.dart';
import 'main_screen.dart';
import 'package:flutter_tarot/l10n/app_localizations.dart';

class ShopScreen extends StatelessWidget {
  const ShopScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        extendBodyBehindAppBar: true,
        body: Stack(
          children: [
            GradientBackground(
              child: SafeArea(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 60, 16, 10),
                      child: Column(
                        children: [
                          Text(
                            AppLocalizations.of(context)!.shopTitle,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            AppLocalizations.of(context)!.shopSubtitle,
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white70),
                          ),
                          const SizedBox(height: 24),
                          TabBar(
                            indicatorColor: Colors.amberAccent,
                            labelColor: Colors.amberAccent,
                            unselectedLabelColor: Colors.white54,
                            tabs: [
                              Tab(
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(Icons.monetization_on, size: 18),
                                    const SizedBox(width: 6),
                                    Text(AppLocalizations.of(context)!.shopTabCoin),
                                    const SizedBox(width: 24),
                                  ],
                                ),
                              ),
                              Tab(
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(Icons.image, size: 18),
                                    const SizedBox(width: 6),
                                    Text(AppLocalizations.of(context)!.shopTabTheme),
                                    const SizedBox(width: 24),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: TabBarView(
                        children: [
                          _buildCoinGrid(context),
                          _buildSkinGrid(context),
                        ],
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
                  onShop: () {}, // 이미 상점 화면이므로 동작 안 함
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
      ),
    );
  }

  Widget _buildCoinGrid(BuildContext context) {
    final List<Map<String, dynamic>> coinPackages = [
      {'coins': 5, 'price': '₩5,000', 'bonus': 1},
      {'coins': 10, 'price': '₩10,000', 'bonus': 2},
      {'coins': 50, 'price': '₩50,000', 'bonus': 15},
      {'coins': 100, 'price': '₩100,000', 'bonus': 50},
    ];

    return GridView.builder(
      padding: const EdgeInsets.all(16.0),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.82,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: coinPackages.length,
      itemBuilder: (context, index) {
        final pkg = coinPackages[index];
        return GlassContainer(
          padding: const EdgeInsets.all(16),
          borderRadius: 16,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildCoinImage(pkg['coins']),
              const SizedBox(height: 12),
              Text(
                AppLocalizations.of(context)!.shopCoins(pkg['coins'] as int),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (pkg['bonus'] != null) ...[
                const SizedBox(height: 4),
                Text(
                  AppLocalizations.of(context)!.shopBonusCoins(pkg['bonus'].toString()),
                  style: const TextStyle(
                    color: Colors.lightGreenAccent,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
              ] else ...[
                const SizedBox(height: 18), // 보너스가 없을 때의 여백 맞춤
              ],
              const Spacer(),
              Text(
                pkg['price'],
                style: const TextStyle(
                  color: Colors.amberAccent,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(AppLocalizations.of(context)!.shopCoinNotReady(pkg['coins']))),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurpleAccent,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 36),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(AppLocalizations.of(context)!.shopPayButton, style: const TextStyle(fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCoinImage(int amount) {
    if (amount <= 5) {
      return SizedBox(
        height: 60,
        width: 60,
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Positioned(bottom: 0, child: _buildCoinCylinder(4, topCoin: true)),
          ],
        ),
      );
    } else if (amount <= 10) {
      return SizedBox(
        height: 60,
        width: 60,
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Positioned(bottom: 0, left: 0, child: _buildCoinCylinder(4, topCoin: true)),
            Positioned(bottom: 0, right: 0, child: _buildCoinCylinder(6, topCoin: true)),
          ],
        ),
      );
    } else if (amount <= 50) {
      return SizedBox(
        height: 60,
        width: 70,
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Positioned(bottom: 5, left: 0, child: _buildCoinCylinder(6, topCoin: false)),
            Positioned(bottom: 5, right: 0, child: _buildCoinCylinder(8, topCoin: true)),
            Positioned(bottom: 0, left: 20, child: _buildCoinCylinder(5, topCoin: true)),
          ],
        ),
      );
    } else {
      // 100 coins
      return SizedBox(
        height: 60,
        width: 80,
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Positioned(bottom: 10, left: 5, child: _buildCoinCylinder(8, topCoin: false)),
            Positioned(bottom: 10, right: 5, child: _buildCoinCylinder(10, topCoin: true)),
            Positioned(bottom: 5, left: 25, child: _buildCoinCylinder(12, topCoin: true)),
            Positioned(bottom: 0, left: 0, child: _buildCoinCylinder(6, topCoin: true)),
            Positioned(bottom: 0, right: 0, child: _buildCoinCylinder(5, topCoin: true)),
          ],
        ),
      );
    }
  }

  Widget _buildCoinCylinder(int count, {bool topCoin = false}) {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.bottomCenter,
      children: [
        SizedBox(
          width: 26,
          height: (count * 4.0) + 8,
          child: Stack(
            children: List.generate(count, (index) {
              return Positioned(
                bottom: index * 4.0,
                left: 0,
                right: 0,
                child: Container(
                  height: 8,
                  decoration: BoxDecoration(
                    color: Colors.amberAccent,
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: Colors.amber.shade900, width: 1),
                  ),
                ),
              );
            }),
          ),
        ),
        if (topCoin)
          Positioned(
            bottom: (count * 4.0),
            child: Container(
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [BoxShadow(color: Colors.black45, blurRadius: 2, spreadRadius: -1)],
              ),
              child: const Icon(Icons.monetization_on, color: Colors.amber, size: 24),
            ),
          ),
      ],
    );
  }

  Widget _buildSkinGrid(BuildContext context) {
    return ValueListenableBuilder<List<String>>(
      valueListenable: ThemeManager.instance.unlockedThemesNotifier,
      builder: (context, unlockedThemes, _) {
        final bool hasMagicBook = unlockedThemes.contains('assets/images/theme/magic_book.png');
        final bool hasBlackCat = unlockedThemes.contains('assets/images/theme/black_cat.png');
        
        final l10n = AppLocalizations.of(context)!;
        
        final List<Map<String, dynamic>> skinPackages = [
          {
            'name': l10n.themeMagicBook,
            'price': hasMagicBook ? l10n.shopOwned : l10n.shopCoinPrice(10),
            'cost': 10,
            'image': 'assets/images/theme/magic_book.png',
            'isTheme': true,
          },
          {
            'name': l10n.themeBlackCat,
            'price': hasBlackCat ? l10n.shopOwned : l10n.shopCoinPrice(10),
            'cost': 10,
            'image': 'assets/images/theme/black_cat.png',
            'isTheme': true,
          },
          {'name': AppLocalizations.of(context)!.themeOriginalDeck, 'price': l10n.shopOwned, 'color': Colors.blueGrey},
          {'name': AppLocalizations.of(context)!.themeGoldenSunDeck, 'price': l10n.shopCoinPrice(100), 'color': Colors.amber},
          {'name': AppLocalizations.of(context)!.themeDarkAbyssDeck, 'price': l10n.shopCoinPrice(150), 'color': Colors.deepPurple},
          {'name': AppLocalizations.of(context)!.themeSpringSpiritDeck, 'price': l10n.shopCoinPrice(120), 'color': Colors.lightGreen},
        ];

        return GridView.builder(
          padding: const EdgeInsets.all(16.0),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.75,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          itemCount: skinPackages.length,
          itemBuilder: (context, index) {
            final skin = skinPackages[index];
            return GlassContainer(
              padding: const EdgeInsets.all(12),
              borderRadius: 16,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: skin.containsKey('image')
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.asset(
                              skin['image'],
                              fit: BoxFit.cover,
                            ),
                          )
                        : Container(
                            decoration: BoxDecoration(
                              color: skin['color'].withOpacity(0.3),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: skin['color'], width: 2),
                            ),
                            child: Center(
                              child: Icon(Icons.style, color: skin['color'], size: 48),
                            ),
                          ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    skin['name'],
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () async {
                      if (skin['price'] == l10n.shopOwned) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(l10n.shopAlreadyOwned)),
                        );
                        return;
                      }

                      if (skin['isTheme'] == true) {
                        final int cost = skin['cost'];
                        final bool? confirm = await showDialog<bool>(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              backgroundColor: const Color(0xFF2D1B4E),
                              title: Text(l10n.shopThemePurchaseTitle, style: const TextStyle(color: Colors.white)),
                              content: Text(
                                l10n.shopThemePurchaseContent(skin['name'], cost),
                                style: const TextStyle(color: Colors.white70),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.of(context).pop(false),
                                  child: Text(l10n.shopCancel, style: const TextStyle(color: Colors.white60)),
                                ),
                                ElevatedButton(
                                  onPressed: () => Navigator.of(context).pop(true),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.amber.shade700,
                                    foregroundColor: Colors.white,
                                  ),
                                  child: Text(l10n.shopPurchase),
                                ),
                              ],
                            );
                          },
                        );

                        if (confirm == true) {
                          // 실제 구매 로직
                          final success = await EconomyService().deductCoin(cost);
                          if (success) {
                            await ThemeManager.instance.unlockTheme(skin['image']);
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(l10n.shopPurchaseSuccess(skin['name']))),
                              );
                            }
                          } else {
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(l10n.shopNotEnoughCoins)),
                              );
                            }
                          }
                        }
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(l10n.shopThemeNotReady(skin['name']))),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: skin['price'] == l10n.shopOwned ? Colors.white24 : Colors.amber.shade700,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 32),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(skin['price'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
