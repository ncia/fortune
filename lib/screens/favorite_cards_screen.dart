import 'package:flutter/material.dart';
import 'package:flutter_tarot/l10n/app_localizations.dart';
import '../data/tarot_data.dart';
import '../services/favorite_service.dart';
import '../widgets/gradient_background.dart';
import '../widgets/tarot_card.dart';
import '../widgets/glass_container.dart';
import '../widgets/top_floating_icons.dart';
import 'card_detail_screen.dart';

class FavoriteCardsScreen extends StatefulWidget {
  const FavoriteCardsScreen({super.key});

  @override
  State<FavoriteCardsScreen> createState() => _FavoriteCardsScreenState();
}

class _FavoriteCardsScreenState extends State<FavoriteCardsScreen> {
  List<TarotCardData> _favoriteCards = [];
  bool _isLoading = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isLoading) {
      _loadFavorites();
    }
  }

  Future<void> _loadFavorites() async {
    final favIds = await FavoriteService.getFavoriteCards();
    if (mounted) {
      final allCards = getTarotDeck(context);
      setState(() {
        _favoriteCards = allCards.where((card) => favIds.contains(card.id)).toList();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight + 65),
        child: Column(
          children: [
            const TopFloatingIcons(),
            AppBar(
              title: Text(AppLocalizations.of(context)!.favoriteCardsTitle),
              centerTitle: true,
              backgroundColor: Colors.transparent,
              elevation: 0,
            ),
          ],
        ),
      ),
      body: GradientBackground(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator(color: Colors.white))
            : _favoriteCards.isEmpty
                ? Center(
                    child: Text(
                      AppLocalizations.of(context)!.favoriteCardsEmpty,
                      style: const TextStyle(color: Colors.white70, fontSize: 16),
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
                    itemCount: _favoriteCards.length,
                    separatorBuilder: (context, index) => const SizedBox(height: 16),
                    itemBuilder: (context, index) {
                      final card = _favoriteCards[index];
                      return GestureDetector(
                        onTap: () async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CardDetailScreen(card: card),
                            ),
                          );
                          _loadFavorites();
                        },
                        child: GlassContainer(
                          padding: const EdgeInsets.all(12),
                          borderRadius: 16,
                          child: Row(
                            children: [
                              TarotCardWidget(
                                imagePath: card.imagePath,
                                width: 70,
                                height: 112,
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      card.name,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      card.uprightDesc,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        color: Colors.white70,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const Icon(Icons.arrow_forward_ios, color: Colors.white54, size: 16),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
      ),
    );
  }
}
