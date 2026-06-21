import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import '../data/tarot_data.dart';
import '../data/tarot_detail_data.dart';
import '../widgets/gradient_background.dart';
import '../widgets/glass_container.dart';
import '../widgets/top_floating_icons.dart';
import '../widgets/shared_bottom_nav_bar.dart';
import 'main_screen.dart';
import 'package:flutter_tarot/l10n/app_localizations.dart';
import '../services/favorite_service.dart';
class CardDetailScreen extends StatefulWidget {
  final TarotCardData card;
  final bool initialIsReversed;
  final String? heroTag;
  final bool showBottomNav;

  const CardDetailScreen({
    super.key, 
    required this.card,
    this.initialIsReversed = false,
    this.heroTag,
    this.showBottomNav = false,
  });

  @override
  State<CardDetailScreen> createState() => _CardDetailScreenState();
}

class _CardDetailScreenState extends State<CardDetailScreen> {
  TarotDetailData? _detailData;
  bool _isLoading = true;
  String? _error;
  int _currentTabIndex = 0;
  bool _isFavorite = false;

  @override
  void initState() {
    super.initState();
    _currentTabIndex = widget.initialIsReversed ? 1 : 0;
    _checkFavorite();
  }

  Future<void> _checkFavorite() async {
    final isFav = await FavoriteService.isFavorite(widget.card.id);
    if (mounted) {
      setState(() {
        _isFavorite = isFav;
      });
    }
  }

  Future<void> _toggleFavorite() async {
    final isNowFav = await FavoriteService.toggleFavorite(widget.card.id);
    if (mounted) {
      setState(() {
        _isFavorite = isNowFav;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(isNowFav 
            ? AppLocalizations.of(context)!.cardDetailAddFavorite 
            : AppLocalizations.of(context)!.cardDetailRemoveFavorite),
          duration: const Duration(seconds: 2),
          backgroundColor: Colors.deepPurple.shade900,
        ),
      );
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isLoading && _detailData == null) {
      _loadDetails();
    }
  }

  Future<void> _loadDetails() async {
    try {
      final localeCode = Localizations.localeOf(context).languageCode;
      final jsonString = await rootBundle.loadString('assets/data/tarot_details_$localeCode.json');
      final List<dynamic> jsonList = jsonDecode(jsonString);
      
      final data = jsonList.firstWhere(
        (element) => element['id'] == widget.card.id,
        orElse: () => null,
      );

      if (data != null) {
        setState(() {
          _detailData = TarotDetailData.fromJson(data);
          _isLoading = false;
        });
      } else {
        setState(() {
          _error = AppLocalizations.of(context)!.cardDetailDataNotReady;
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _error = AppLocalizations.of(context)!.cardDetailLoadError;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight + 65),
        child: Column(
          children: [
            const TopFloatingIcons(),
            AppBar(
              title: Text(widget.card.name),
              backgroundColor: Colors.transparent,
              elevation: 0,
              actions: [
                Padding(
                  padding: const EdgeInsets.only(right: 16.0),
                  child: IconButton(
                    splashRadius: 24, // 스플래시 반경을 명시하여 클릭 효과의 크기를 고정
                    icon: Icon(
                      _isFavorite ? Icons.star : Icons.star_border,
                      color: _isFavorite ? Colors.amberAccent : Colors.white,
                    ),
                    onPressed: _toggleFavorite,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      body: GradientBackground(
        child: _isLoading 
          ? const Center(child: CircularProgressIndicator(color: Colors.white))
          : SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: MediaQuery.of(context).padding.top + kToolbarHeight + 0),
                  // Card Image with Hero
                  Hero(
                    tag: widget.heroTag ?? 'card_${widget.card.id}',
                    child: Container(
                      height: 250,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.5),
                            blurRadius: 15,
                            spreadRadius: 2,
                          )
                        ]
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.asset(widget.card.imagePath, fit: BoxFit.contain),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () => setState(() => _currentTabIndex = 0),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  color: _currentTabIndex == 0 ? Colors.white : Colors.transparent,
                                  width: 2,
                                ),
                              ),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              AppLocalizations.of(context)!.cardDetailTabUpright,
                              style: TextStyle(
                                color: _currentTabIndex == 0 ? Colors.white : Colors.white54,
                                fontWeight: _currentTabIndex == 0 ? FontWeight.bold : FontWeight.normal,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: InkWell(
                          onTap: () => setState(() => _currentTabIndex = 1),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  color: _currentTabIndex == 1 ? Colors.white : Colors.transparent,
                                  width: 2,
                                ),
                              ),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              AppLocalizations.of(context)!.cardDetailTabReversed,
                              style: TextStyle(
                                color: _currentTabIndex == 1 ? Colors.white : Colors.white54,
                                fontWeight: _currentTabIndex == 1 ? FontWeight.bold : FontWeight.normal,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  _currentTabIndex == 0
                      ? _buildDetailContent(_detailData?.upright, isUpright: true)
                      : _buildDetailContent(_detailData?.reversed, isUpright: false),
                  const SizedBox(height: 20),
                ],
              ),
            ),
      ),
      bottomNavigationBar: widget.showBottomNav ? SharedBottomNavBar(
        currentIndex: mainScreenKey.currentState?.currentIndex ?? 0,
        onTap: (index) {
          Navigator.popUntil(context, (route) => route.isFirst);
          mainScreenKey.currentState?.switchTab(index);
        },
      ) : null,
    );
  }

  Widget _buildDetailContent(TarotDirectionDetail? detail, {required bool isUpright}) {
    if (_error != null) {
      return Center(child: Text(_error!, style: const TextStyle(color: Colors.white)));
    }
    if (detail == null) {
      return Center(child: Text(AppLocalizations.of(context)!.cardDetailNoData, style: const TextStyle(color: Colors.white)));
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildSection(AppLocalizations.of(context)!.cardDetailSectionKeywords, detail.keyMeanings),
          _buildSection(AppLocalizations.of(context)!.cardDetailSectionGeneral, detail.general),
          _buildSection(AppLocalizations.of(context)!.cardDetailSectionLove, detail.love),
          _buildSection(AppLocalizations.of(context)!.cardDetailSectionCareer, detail.career),
          _buildSection(AppLocalizations.of(context)!.cardDetailSectionHealth, detail.health),
          _buildSection(AppLocalizations.of(context)!.cardDetailSectionSpirituality, detail.spirituality),
        ],
      ),
    );
  }

  Widget _buildSection(String title, String content) {
    if (content.isEmpty) return const SizedBox.shrink();
    
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: GlassContainer(
        padding: const EdgeInsets.all(16),
        borderRadius: 12,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              content,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

