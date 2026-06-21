import 'package:flutter/material.dart';
import '../widgets/gradient_background.dart';
import '../widgets/glass_container.dart';
import '../services/economy_service.dart';
import '../widgets/shared_bottom_nav_bar.dart';
import '../widgets/top_floating_icons.dart';
import 'main_screen.dart';
import 'package:flutter_tarot/l10n/app_localizations.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../widgets/sliver_tab_bar_delegate.dart';

class GrowthScreen extends StatefulWidget {
  const GrowthScreen({super.key});

  @override
  State<GrowthScreen> createState() => _GrowthScreenState();
}

class _GrowthScreenState extends State<GrowthScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GradientBackground(
            child: SafeArea(
              child: NestedScrollView(
                headerSliverBuilder: (context, innerBoxIsScrolled) {
                  return [
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(16, 60, 16, 10),
                        child: Column(
                          children: [
                            Text(
                              AppLocalizations.of(context)!.growthTitle,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              AppLocalizations.of(context)!.growthSubtitle,
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white70),
                            ),
                            const SizedBox(height: 24),
                          ],
                        ),
                      ),
                    ),
                    SliverPersistentHeader(
                      pinned: true,
                      delegate: SliverTabBarDelegate(
                        TabBar(
                          controller: _tabController,
                          isScrollable: true,
                          tabAlignment: TabAlignment.center,
                          indicatorColor: Colors.amberAccent,
                          labelColor: Colors.amberAccent,
                          unselectedLabelColor: Colors.white54,
                          labelStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                          unselectedLabelStyle: const TextStyle(fontSize: 14),
                          tabs: [
                            Tab(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(Icons.lens_blur),
                                  const SizedBox(width: 8),
                                  Text(AppLocalizations.of(context)!.growthTabCrystalBall),
                                ],
                              ),
                            ),
                            Tab(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(Icons.menu_book),
                                  const SizedBox(width: 8),
                                  Text(AppLocalizations.of(context)!.growthTabMagicBook),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ];
                },
                body: TabBarView(
                  controller: _tabController,
                  children: const [
                    _CrystalBallTab(),
                    _MagicBookTab(),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              child: TopFloatingIcons(
                onGrowth: () {}, // 이미 성장 화면이므로 동작 안 함
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

class _MagicBookTab extends StatefulWidget {
  const _MagicBookTab();

  @override
  State<_MagicBookTab> createState() => _MagicBookTabState();
}

class _MagicBookTabState extends State<_MagicBookTab> {
  bool _isEnhancing = false;

  void _enhanceBook() async {
    final totalExp = EconomyService().worldTreeExp;
    final level = EconomyService().getLevelFromTotalExp(totalExp);
    if (level >= 100) return;
    
    final currentExp = EconomyService().getCurrentLevelExp(totalExp);
    final requiredExp = EconomyService().getRequiredExpForLevel(level);
    final needed = requiredExp - currentExp;

    int amountToInject = 10;
    if (needed < amountToInject) amountToInject = needed;
    
    // 보유 가루가 부족하지만 조금이라도 있다면 있는 만큼만 주입
    final ownedDust = EconomyService().magicDust;
    if (ownedDust > 0 && ownedDust < amountToInject) {
      amountToInject = ownedDust;
    }
    // 만약 보유 가루가 0이라면 버튼 텍스트 표시를 위해 10(또는 needed) 유지 (클릭 시 부족 메시지 발생)
    if (amountToInject == 0) amountToInject = needed < 10 ? needed : 10;

    setState(() {
      _isEnhancing = true;
    });
    
    bool success = await EconomyService().levelUpWorldTree(amountToInject);
    if (mounted) {
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context)!.growthUpgradeSuccess)),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context)!.growthUpgradeNotEnough)),
        );
      }
      setState(() {
        _isEnhancing = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: EconomyService(),
      builder: (context, _) {
        final totalExp = EconomyService().worldTreeExp;
        final level = EconomyService().getLevelFromTotalExp(totalExp);
        final currentExp = EconomyService().getCurrentLevelExp(totalExp);
        final requiredExp = EconomyService().getRequiredExpForLevel(level);
        final progress = level >= 100 ? 1.0 : currentExp / requiredExp;

        final phaseIndex = ((level - 1) / 10).floor().clamp(0, 9);
        final phases = [
          AppLocalizations.of(context)!.growthPhaseBook0,
          AppLocalizations.of(context)!.growthPhaseBook1,
          AppLocalizations.of(context)!.growthPhaseBook2,
          AppLocalizations.of(context)!.growthPhaseBook3,
          AppLocalizations.of(context)!.growthPhaseBook4,
          AppLocalizations.of(context)!.growthPhaseBook5,
          AppLocalizations.of(context)!.growthPhaseBook6,
          AppLocalizations.of(context)!.growthPhaseBook7,
          AppLocalizations.of(context)!.growthPhaseBook8,
          AppLocalizations.of(context)!.growthPhaseBook9,
        ];
        final currentPhaseName = phaseIndex < phases.length ? phases[phaseIndex] : AppLocalizations.of(context)!.growthPhaseCrystal10;
        final phaseNumber = phaseIndex + 1;

        // 100만 EXP에 도달하는 동안 색상이 3번(1080도) 부드럽게 순환합니다.
        final double hue = (40.0 + (totalExp / 1000000.0 * 1080.0)) % 360.0;
        final double lightness = (0.5 + (totalExp / 1000000.0) * 0.5).clamp(0.5, 1.0);
        final titleColor = HSLColor.fromAHSL(1.0, hue, 0.8, lightness).toColor();


        return LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(AppLocalizations.of(context)!.growthPhaseFormat(phaseNumber, currentPhaseName), style: Theme.of(context).textTheme.titleMedium?.copyWith(color: titleColor, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      Text(AppLocalizations.of(context)!.growthMagicBookLevel(level), style: Theme.of(context).textTheme.titleLarge),
                      const SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 40),
                        child: Column(
                          children: [
                            LinearProgressIndicator(
                              value: progress,
                              backgroundColor: Colors.white24,
                              color: Colors.amberAccent,
                              minHeight: 12,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            const SizedBox(height: 8),
                            Text(AppLocalizations.of(context)!.growthMagicBookKnowledge(currentExp, requiredExp), style: const TextStyle(color: Colors.white70)),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: titleColor.withOpacity(0.5),
                              blurRadius: 100,
                              spreadRadius: 20,
                            ),
                          ],
                        ),
                        child: Image.asset(
                          'assets/images/magic_book.png',
                          width: 300,
                          height: 300,
                          fit: BoxFit.contain,
                        ),
                      ),
                      const SizedBox(height: 40),
                      GlassContainer(
                        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                        borderRadius: 20,
                        child: Text(
                          AppLocalizations.of(context)!.growthDustOwned(totalExp),
                          style: const TextStyle(color: Colors.amber, fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(height: 40),
                      ElevatedButton.icon(
                        onPressed: _isEnhancing || level >= 100 ? null : _enhanceBook,
                        icon: const Icon(Icons.auto_awesome),
                        label: Builder(
                          builder: (context) {
                            int amount = 10;
                            final needed = requiredExp - currentExp;
                            if (needed < amount) amount = needed;
                            final owned = EconomyService().magicDust;
                            if (owned > 0 && owned < amount) amount = owned;
                            if (amount == 0) amount = needed < 10 ? needed : 10;
                            return Text(AppLocalizations.of(context)!.growthUpgradeMagicBookButton(amount));
                          }
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.amber[800],
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class _CrystalBallTab extends StatefulWidget {
  const _CrystalBallTab();

  @override
  State<_CrystalBallTab> createState() => _CrystalBallTabState();
}

class _CrystalBallTabState extends State<_CrystalBallTab> {
  bool _isUpgrading = false;

  void _upgradeBall() async {
    final totalExp = EconomyService().crystalBallExp;
    final displayLevel = EconomyService().getLevelFromTotalExp(totalExp);
    if (displayLevel >= 100) return;
    
    final currentExp = EconomyService().getCurrentLevelExp(totalExp);
    final requiredExp = EconomyService().getRequiredExpForLevel(displayLevel);
    final needed = requiredExp - currentExp;

    int amountToInject = 10;
    if (needed < amountToInject) amountToInject = needed;
    
    final ownedDust = EconomyService().magicDust;
    if (ownedDust > 0 && ownedDust < amountToInject) {
      amountToInject = ownedDust;
    }
    if (amountToInject == 0) amountToInject = needed < 10 ? needed : 10;

    setState(() {
      _isUpgrading = true;
    });

    final success = await EconomyService().upgradeCrystalBall(amountToInject);
    if (mounted) {
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context)!.growthUpgradeSuccess)),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context)!.growthUpgradeNotEnough)),
        );
      }
      setState(() {
        _isUpgrading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: EconomyService(),
      builder: (context, _) {
        final totalExp = EconomyService().crystalBallExp;
        final dust = EconomyService().magicDust;
        final displayLevel = EconomyService().getLevelFromTotalExp(totalExp);
        final currentExp = EconomyService().getCurrentLevelExp(totalExp);
        final requiredExp = EconomyService().getRequiredExpForLevel(displayLevel);
        final progress = displayLevel >= 100 ? 1.0 : currentExp / requiredExp;
        
        final phaseIndex = ((displayLevel - 1) / 10).floor().clamp(0, 9);
        final phases = [
          AppLocalizations.of(context)!.growthPhaseCrystal0,
          AppLocalizations.of(context)!.growthPhaseCrystal1,
          AppLocalizations.of(context)!.growthPhaseCrystal2,
          AppLocalizations.of(context)!.growthPhaseCrystal3,
          AppLocalizations.of(context)!.growthPhaseCrystal4,
          AppLocalizations.of(context)!.growthPhaseCrystal5,
          AppLocalizations.of(context)!.growthPhaseCrystal6,
          AppLocalizations.of(context)!.growthPhaseCrystal7,
          AppLocalizations.of(context)!.growthPhaseCrystal8,
          AppLocalizations.of(context)!.growthPhaseCrystal9,
        ];
        final currentPhaseName = phaseIndex < phases.length ? phases[phaseIndex] : AppLocalizations.of(context)!.growthPhaseCrystal10;
        final phaseNumber = phaseIndex + 1;

        // 수정구도 100만 EXP 동안 색상이 3번 부드럽게 순환합니다.
        final double hue = ((totalExp / 1000000.0) * 1080.0) % 360.0;
        final double lightness = (0.1 + (totalExp / 1000000.0) * 0.9).clamp(0.1, 1.0);
        final overlayColor = HSLColor.fromAHSL(1.0, hue, 1.0, lightness).toColor();

        return LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(AppLocalizations.of(context)!.growthPhaseFormat(phaseNumber, currentPhaseName), style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.purpleAccent, fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text(AppLocalizations.of(context)!.growthCrystalBallLevel(displayLevel), style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Column(
                  children: [
                    LinearProgressIndicator(
                      value: progress,
                      backgroundColor: Colors.white24,
                      color: Colors.purpleAccent,
                      minHeight: 12,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    const SizedBox(height: 8),
                    Text(AppLocalizations.of(context)!.growthCrystalBallMana(currentExp, requiredExp), style: const TextStyle(color: Colors.white70)),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: _isUpgrading ? null : _upgradeBall,
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: HSLColor.fromAHSL(1.0, hue, 1.0, 0.7).toColor().withOpacity(0.5),
                        blurRadius: 100,
                        spreadRadius: 20,
                      ),
                    ],
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // 색상 오버레이를 이미지 뒤에 배치하여 유리 반사 효과를 살림
                      Positioned(
                        top: 44, // 윗부분 1픽셀 추가 축소를 위해 내림
                        child: IgnorePointer(
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            width: 122, // 1픽셀 추가 축소
                            height: 122,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: overlayColor.withOpacity(0.8), // 그림자 렌더링으로 인해 삐져나오는 현상 방지를 위해 그림자 완전 제거
                            ),
                          ),
                        ),
                      ),
                      Image.asset(
                        'assets/images/crystal_ball.png',
                        width: 300,
                        height: 300,
                        fit: BoxFit.contain,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 40),
              GlassContainer(
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                borderRadius: 20,
                child: Text(
                  AppLocalizations.of(context)!.growthDustOwned(totalExp),
                  style: const TextStyle(color: Colors.purpleAccent, fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 40),
              ElevatedButton.icon(
                onPressed: _isUpgrading || displayLevel >= 100 ? null : _upgradeBall,
                icon: const Icon(Icons.auto_awesome),
                label: Builder(
                  builder: (context) {
                    int amount = 10;
                    final needed = requiredExp - currentExp;
                    if (needed < amount) amount = needed;
                    final owned = EconomyService().magicDust;
                    if (owned > 0 && owned < amount) amount = owned;
                    if (amount == 0) amount = needed < 10 ? needed : 10;
                    return Text(AppLocalizations.of(context)!.growthUpgradeButtonCost(amount));
                  }
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                ),
              ),
            ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
