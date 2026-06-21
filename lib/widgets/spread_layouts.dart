import 'package:flutter/material.dart';
import '../data/tarot_data.dart';
import '../data/spread_type.dart';
import '../screens/card_detail_screen.dart';
import 'flip_card.dart';
import 'glass_container.dart';
import 'package:flutter_tarot/l10n/tarot_localizations.dart';
import 'package:flutter_tarot/l10n/app_localizations.dart';

class SpreadLayoutBuilder extends StatelessWidget {
  final SpreadType spreadType;
  final List<int> selectedCardIndices;
  final List<TarotCardData> shuffledDeck;
  final List<bool> shuffledReversed;
  final bool isForChat;
  final void Function(List<String>)? onCardsPicked;

  const SpreadLayoutBuilder({
    super.key,
    required this.spreadType,
    required this.selectedCardIndices,
    required this.shuffledDeck,
    required this.shuffledReversed,
    this.isForChat = false,
    this.onCardsPicked,
  });

  @override
  Widget build(BuildContext context) {
    Widget layout;
    switch (spreadType) {
      case SpreadType.oneCard:
        layout = _OneCardLayout(
          selectedCardIndices: selectedCardIndices,
          shuffledDeck: shuffledDeck,
          shuffledReversed: shuffledReversed,
        );
        break;
      case SpreadType.twoCard:
        layout = _TwoCardLayout(
          selectedCardIndices: selectedCardIndices,
          shuffledDeck: shuffledDeck,
          shuffledReversed: shuffledReversed,
        );
        break;
      case SpreadType.threeCard:
        layout = _ThreeCardLayout(
          selectedCardIndices: selectedCardIndices,
          shuffledDeck: shuffledDeck,
          shuffledReversed: shuffledReversed,
        );
        break;
      case SpreadType.fourCard:
        layout = _FourCardLayout(
          selectedCardIndices: selectedCardIndices,
          shuffledDeck: shuffledDeck,
          shuffledReversed: shuffledReversed,
        );
        break;
      case SpreadType.fiveCard:
        layout = _FiveCardLayout(
          selectedCardIndices: selectedCardIndices,
          shuffledDeck: shuffledDeck,
          shuffledReversed: shuffledReversed,
        );
        break;
      case SpreadType.celticCross:
        layout = _CelticCrossLayout(
          selectedCardIndices: selectedCardIndices,
          shuffledDeck: shuffledDeck,
          shuffledReversed: shuffledReversed,
        );
        break;
    }

    return Column(
      children: [
        layout,
        if (isForChat) ...[
          const SizedBox(height: 30),
          Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: GestureDetector(
              onTap: () {
                if (onCardsPicked != null) {
                  final List<String> pickedInfos = [];
                  for (int i = 0; i < spreadType.cardCount; i++) {
                    final cardIndex = selectedCardIndices[i];
                    final card = shuffledDeck[cardIndex];
                    final isRev = shuffledReversed[cardIndex];
                    pickedInfos.add('${TarotLocalizations.getName(context, card.id)} (${isRev ? "Reversed" : "Upright"})');
                  }
                  onCardsPicked!(pickedInfos);
                }
                Navigator.of(context).pop();
              },
              child: GlassContainer(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 18),
                borderRadius: 30,
                child: Center(
                  child: Text(
                    AppLocalizations.of(context)!.listenToInterpretation,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 20),
                  ),
                ),
              ),
            ),
          )
        ],
      ],
    );
  }
}

Widget _buildCardItem(BuildContext context, {
  required int index,
  required TarotCardData card,
  required bool isRev,
  String? label,
  double width = 90,
  double height = 140,
  bool showName = true,
}) {
  return GestureDetector(
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CardDetailScreen(
            card: card,
            initialIsReversed: isRev,
            heroTag: 'reading_result_card_${card.id}_0',
          ),
        ),
      );
    },
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (label != null) ...[
          Text(
            label,
            style: const TextStyle(
              color: Colors.amberAccent,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
        ],
        Hero(
          tag: 'reading_result_card_${card.id}_0',
          child: FlipCardWidget(
            frontImagePath: card.imagePath,
            isReversed: isRev,
            backImagePath: 'assets/images/card_back.jpg',
            isFlipped: true,
            width: width,
            height: height,
            duration: Duration(milliseconds: 600 + (index * 100)),
          ),
        ),
        if (showName) ...[
          const SizedBox(height: 8),
          SizedBox(
            width: width,
            child: Text(
              TarotLocalizations.getName(context, card.id).split(" (").first,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ],
    ),
  );
}

class _OneCardLayout extends StatelessWidget {
  final List<int> selectedCardIndices;
  final List<TarotCardData> shuffledDeck;
  final List<bool> shuffledReversed;

  const _OneCardLayout({required this.selectedCardIndices, required this.shuffledDeck, required this.shuffledReversed});

  @override
  Widget build(BuildContext context) {
    if (selectedCardIndices.isEmpty) return const SizedBox();
    final cardIndex = selectedCardIndices[0];
    final card = shuffledDeck[cardIndex];
    final isRev = shuffledReversed[cardIndex];

    final label = AppLocalizations.of(context)?.positionOneCard ?? 'Today\'s Card';

    return Column(
      children: [
        // 상단 미니 맵
        Container(
          height: 300,
          margin: const EdgeInsets.only(bottom: 30),
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                label,
                style: const TextStyle(
                  color: Colors.amberAccent,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Transform.rotate(
                angle: isRev ? 3.14159 : 0,
                child: Container(
                  width: 140,
                  height: 220,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white30, width: 2),
                    borderRadius: BorderRadius.circular(8),
                    image: DecorationImage(
                      image: AssetImage(card.imagePath),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        // 하단 상세 설명 (리스트 스타일)
        GlassContainer(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              _buildCardItem(
                context,
                index: 0,
                card: card,
                isRev: isRev,
                width: 60,
                height: 95,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => CardDetailScreen(card: card, initialIsReversed: isRev, heroTag: 'reading_result_card_${card.id}_0'))),
                  child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: const TextStyle(color: Colors.amberAccent, fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      TarotLocalizations.getName(context, card.id),
                      style: const TextStyle(color: Colors.white, fontSize: 18),
                    ),
                    Text(
                      isRev ? AppLocalizations.of(context)!.spreadReversed : AppLocalizations.of(context)!.spreadUpright,
                      style: const TextStyle(color: Colors.white70, fontSize: 14),
                    ),
                  ],
                ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ThreeCardLayout extends StatelessWidget {
  final List<int> selectedCardIndices;
  final List<TarotCardData> shuffledDeck;
  final List<bool> shuffledReversed;

  const _ThreeCardLayout({required this.selectedCardIndices, required this.shuffledDeck, required this.shuffledReversed});

  @override
  Widget build(BuildContext context) {
    if (selectedCardIndices.length < 3) return const SizedBox();
    final labels = [
      AppLocalizations.of(context)?.positionThreeCard1 ?? 'Past',
      AppLocalizations.of(context)?.positionThreeCard2 ?? 'Present',
      AppLocalizations.of(context)?.positionThreeCard3 ?? 'Future',
    ];

    return Column(
      children: [
        // 상단 미니 맵 (3장 가로 정렬)
        Container(
          height: 300,
          margin: const EdgeInsets.only(bottom: 30),
          alignment: Alignment.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: List.generate(3, (index) {
              final cardIndex = selectedCardIndices[index];
              final card = shuffledDeck[cardIndex];
              final isRev = shuffledReversed[cardIndex];

              return Column(
                children: [
                  Text(
                    labels[index],
                    style: const TextStyle(
                      color: Colors.amberAccent,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Transform.rotate(
                    angle: isRev ? 3.14159 : 0,
                    child: Container(
                      width: 70,
                      height: 110,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.white30, width: 1),
                        borderRadius: BorderRadius.circular(4),
                        image: DecorationImage(
                          image: AssetImage(card.imagePath),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }),
          ),
        ),
        // 하단 상세 리스트 뷰
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: 3,
          itemBuilder: (context, index) {
            final cardIndex = selectedCardIndices[index];
            final card = shuffledDeck[cardIndex];
            final isRev = shuffledReversed[cardIndex];
            
            return GlassContainer(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  _buildCardItem(
                    context,
                    index: index,
                    card: card,
                    isRev: isRev,
                    width: 60,
                    height: 95,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => CardDetailScreen(card: card, initialIsReversed: isRev, heroTag: 'reading_result_card_${card.id}_$index'))),
                      child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          labels[index],
                          style: const TextStyle(color: Colors.amberAccent, fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          TarotLocalizations.getName(context, card.id),
                          style: const TextStyle(color: Colors.white, fontSize: 18),
                        ),
                        Text(
                          isRev ? AppLocalizations.of(context)!.spreadReversed : AppLocalizations.of(context)!.spreadUpright,
                          style: const TextStyle(color: Colors.white70, fontSize: 14),
                        ),
                      ],
                    ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}

class _FourCardLayout extends StatelessWidget {
  final List<int> selectedCardIndices;
  final List<TarotCardData> shuffledDeck;
  final List<bool> shuffledReversed;

  const _FourCardLayout({
    required this.selectedCardIndices,
    required this.shuffledDeck,
    required this.shuffledReversed,
  });

  @override
  Widget build(BuildContext context) {
    final labels = [
      AppLocalizations.of(context)?.positionFourCard1 ?? '1. Problem',
      AppLocalizations.of(context)?.positionFourCard2 ?? '2. Cause',
      AppLocalizations.of(context)?.positionFourCard3 ?? '3. Advice',
      AppLocalizations.of(context)?.positionFourCard4 ?? '4. Outcome',
    ];

    Widget buildMiniCard(int idx, {double width = 50, double height = 80}) {
      final cardIndex = selectedCardIndices[idx];
      final card = shuffledDeck[cardIndex];
      final isRev = shuffledReversed[cardIndex];
      return Column(
        children: [
          Text('${idx + 1}', style: const TextStyle(color: Colors.amberAccent, fontSize: 12, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          _buildCardItem(context, index: idx, card: card, isRev: isRev, width: width, height: height, showName: false),
        ],
      );
    }

    return Column(
      children: [
        // 상단 미니 맵 (2x2 정렬)
        Container(
          height: 340,
          margin: const EdgeInsets.only(bottom: 30),
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  buildMiniCard(0), // 1. Problem
                  const SizedBox(width: 16),
                  buildMiniCard(1), // 2. Cause
                ],
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  buildMiniCard(2), // 3. Advice
                  const SizedBox(width: 16),
                  buildMiniCard(3), // 4. Outcome
                ],
              ),
            ],
          ),
        ),
        // 하단 상세 리스트 뷰
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: 4,
          itemBuilder: (context, index) {
            final cardIndex = selectedCardIndices[index];
            final card = shuffledDeck[cardIndex];
            final isRev = shuffledReversed[cardIndex];
            
            return GlassContainer(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  _buildCardItem(
                    context,
                    index: index,
                    card: card,
                    isRev: isRev,
                    width: 60,
                    height: 95,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => CardDetailScreen(card: card, initialIsReversed: isRev, heroTag: 'reading_result_card_${card.id}_$index'))),
                      child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          labels[index],
                          style: const TextStyle(color: Colors.amberAccent, fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          TarotLocalizations.getName(context, card.id),
                          style: const TextStyle(color: Colors.white, fontSize: 18),
                        ),
                        Text(
                          isRev ? AppLocalizations.of(context)!.spreadReversed : AppLocalizations.of(context)!.spreadUpright,
                          style: const TextStyle(color: Colors.white70, fontSize: 14),
                        ),
                      ],
                    ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}

class _TwoCardLayout extends StatelessWidget {
  final List<int> selectedCardIndices;
  final List<TarotCardData> shuffledDeck;
  final List<bool> shuffledReversed;

  const _TwoCardLayout({
    required this.selectedCardIndices,
    required this.shuffledDeck,
    required this.shuffledReversed,
  });

  @override
  Widget build(BuildContext context) {
    final labels = [
      AppLocalizations.of(context)?.positionTwoCard1 ?? '1. Situation',
      AppLocalizations.of(context)?.positionTwoCard2 ?? '2. Advice',
    ];

    Widget buildMiniCard(int idx, {double width = 50, double height = 80}) {
      final cardIndex = selectedCardIndices[idx];
      final card = shuffledDeck[cardIndex];
      final isRev = shuffledReversed[cardIndex];
      return Column(
        children: [
          Text('${idx + 1}', style: const TextStyle(color: Colors.amberAccent, fontSize: 12, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          _buildCardItem(context, index: idx, card: card, isRev: isRev, width: width, height: height, showName: false),
        ],
      );
    }

    return Column(
      children: [
        // 상단 미니 맵 (2장 가로 정렬)
        Container(
          height: 340,
          margin: const EdgeInsets.only(bottom: 30),
          alignment: Alignment.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              buildMiniCard(0),
              const SizedBox(width: 32),
              buildMiniCard(1),
            ],
          ),
        ),
        // 하단 상세 리스트 뷰
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: 2,
          itemBuilder: (context, index) {
            final cardIndex = selectedCardIndices[index];
            final card = shuffledDeck[cardIndex];
            final isRev = shuffledReversed[index];
            
            return GlassContainer(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  _buildCardItem(
                    context,
                    index: index,
                    card: card,
                    isRev: isRev,
                    width: 60,
                    height: 95,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => CardDetailScreen(card: card, initialIsReversed: isRev, heroTag: 'reading_result_card_${card.id}_$index'))),
                      child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          labels[index],
                          style: const TextStyle(color: Colors.amberAccent, fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          TarotLocalizations.getName(context, card.id),
                          style: const TextStyle(color: Colors.white, fontSize: 18),
                        ),
                        Text(
                          isRev ? AppLocalizations.of(context)!.spreadReversed : AppLocalizations.of(context)!.spreadUpright,
                          style: const TextStyle(color: Colors.white70, fontSize: 14),
                        ),
                      ],
                    ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}

class _FiveCardLayout extends StatelessWidget {
  final List<int> selectedCardIndices;
  final List<TarotCardData> shuffledDeck;
  final List<bool> shuffledReversed;

  const _FiveCardLayout({
    required this.selectedCardIndices,
    required this.shuffledDeck,
    required this.shuffledReversed,
  });

  @override
  Widget build(BuildContext context) {
    final labels = [
      AppLocalizations.of(context)?.positionFiveCard1 ?? '1. Present',
      AppLocalizations.of(context)?.positionFiveCard2 ?? '2. Past Influences',
      AppLocalizations.of(context)?.positionFiveCard3 ?? '3. Future Direction',
      AppLocalizations.of(context)?.positionFiveCard4 ?? '4. Core Reason',
      AppLocalizations.of(context)?.positionFiveCard5 ?? '5. Potential Outcome',
    ];

    Widget buildMiniCard(int idx, {double width = 50, double height = 80}) {
      final cardIndex = selectedCardIndices[idx];
      final card = shuffledDeck[cardIndex];
      final isRev = shuffledReversed[cardIndex];
      return Column(
        children: [
          Text('${idx + 1}', style: const TextStyle(color: Colors.amberAccent, fontSize: 12, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          _buildCardItem(context, index: idx, card: card, isRev: isRev, width: width, height: height, showName: false),
        ],
      );
    }

    return Column(
      children: [
        // 상단 미니 맵 (십자가 정렬)
        Container(
          height: 340,
          margin: const EdgeInsets.only(bottom: 30),
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              buildMiniCard(4), // Top
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  buildMiniCard(1), // Left
                  const SizedBox(width: 8),
                  buildMiniCard(0), // Center
                  const SizedBox(width: 8),
                  buildMiniCard(2), // Right
                ],
              ),
              const SizedBox(height: 8),
              buildMiniCard(3), // Bottom
            ],
          ),
        ),
        // 하단 상세 리스트 뷰
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: 5,
          itemBuilder: (context, index) {
            final cardIndex = selectedCardIndices[index];
            final card = shuffledDeck[cardIndex];
            final isRev = shuffledReversed[cardIndex];
            
            return GlassContainer(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  _buildCardItem(
                    context,
                    index: index,
                    card: card,
                    isRev: isRev,
                    width: 60,
                    height: 95,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => CardDetailScreen(card: card, initialIsReversed: isRev, heroTag: 'reading_result_card_${card.id}_$index'))),
                      child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          labels[index],
                          style: const TextStyle(color: Colors.amberAccent, fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          TarotLocalizations.getName(context, card.id),
                          style: const TextStyle(color: Colors.white, fontSize: 18),
                        ),
                        Text(
                          isRev ? AppLocalizations.of(context)!.spreadReversed : AppLocalizations.of(context)!.spreadUpright,
                          style: const TextStyle(color: Colors.white70, fontSize: 14),
                        ),
                      ],
                    ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}

class _CelticCrossLayout extends StatelessWidget {
  final List<int> selectedCardIndices;
  final List<TarotCardData> shuffledDeck;
  final List<bool> shuffledReversed;

  const _CelticCrossLayout({required this.selectedCardIndices, required this.shuffledDeck, required this.shuffledReversed});

  @override
  Widget build(BuildContext context) {
    if (selectedCardIndices.length < 10) return const SizedBox();
    
    final labels = [
      AppLocalizations.of(context)?.positionCelticCross1 ?? '1. Present',
      AppLocalizations.of(context)?.positionCelticCross2 ?? '2. Challenge',
      AppLocalizations.of(context)?.positionCelticCross3 ?? '3. Past',
      AppLocalizations.of(context)?.positionCelticCross4 ?? '4. Future',
      AppLocalizations.of(context)?.positionCelticCross5 ?? '5. Conscious',
      AppLocalizations.of(context)?.positionCelticCross6 ?? '6. Subconscious',
      AppLocalizations.of(context)?.positionCelticCross7 ?? '7. Advice',
      AppLocalizations.of(context)?.positionCelticCross8 ?? '8. External',
      AppLocalizations.of(context)?.positionCelticCross9 ?? '9. Hopes/Fears',
      AppLocalizations.of(context)?.positionCelticCross10 ?? '10. Outcome',
    ];

    return Column(
      children: [
        // 시각적 미니 맵
        Container(
          height: 300,
          margin: const EdgeInsets.only(bottom: 20),
          child: _buildMiniMap(),
        ),
        // 스크롤 가능한 리스트 뷰
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: 10,
          itemBuilder: (context, index) {
            final cardIndex = selectedCardIndices[index];
            final card = shuffledDeck[cardIndex];
            final isRev = shuffledReversed[cardIndex];
            
            return GlassContainer(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  _buildCardItem(
                    context,
                    index: index,
                    card: card,
                    isRev: isRev,
                    width: 60,
                    height: 95,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => CardDetailScreen(card: card, initialIsReversed: isRev, heroTag: 'reading_result_card_${card.id}_$index'))),
                      child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          labels[index],
                          style: const TextStyle(color: Colors.amberAccent, fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          TarotLocalizations.getName(context, card.id),
                          style: const TextStyle(color: Colors.white, fontSize: 18),
                        ),
                        Text(
                          isRev ? AppLocalizations.of(context)!.spreadReversed : AppLocalizations.of(context)!.spreadUpright,
                          style: const TextStyle(color: Colors.white70, fontSize: 14),
                        ),
                      ],
                    ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildMiniMap() {
    return LayoutBuilder(builder: (context, constraints) {
      double w = 35;
      double h = 55;
      double centerX = constraints.maxWidth * 0.35;
      double centerY = constraints.maxHeight / 2;
      double spacingX = 50;
      double spacingY = 70;
      
      double staffX = constraints.maxWidth * 0.8;
      double staffSpacingY = 65;

      return Stack(
        clipBehavior: Clip.none,
        children: [
          // 3. Past (Left)
          _pos(2, centerX - spacingX, centerY, w, h),
          // 4. Future (Right)
          _pos(3, centerX + spacingX, centerY, w, h),
          // 5. Conscious (Above)
          _pos(4, centerX, centerY - spacingY, w, h),
          // 6. Subconscious (Below)
          _pos(5, centerX, centerY + spacingY, w, h),
          // 1. Present (Center)
          _pos(0, centerX, centerY, w, h),
          // 2. Challenge (Crossing Center)
          _pos(1, centerX, centerY, w, h, rotate: true),
          
          // Staff (Bottom to Top)
          _pos(6, staffX, centerY + staffSpacingY * 1.5, w, h),
          _pos(7, staffX, centerY + staffSpacingY * 0.5, w, h),
          _pos(8, staffX, centerY - staffSpacingY * 0.5, w, h),
          _pos(9, staffX, centerY - staffSpacingY * 1.5, w, h),
        ],
      );
    });
  }

  Widget _pos(int index, double x, double y, double w, double h, {bool rotate = false}) {
    if (selectedCardIndices.length <= index) return const SizedBox();
    final cardIndex = selectedCardIndices[index];
    final card = shuffledDeck[cardIndex];
    final isRev = shuffledReversed[cardIndex];

    Widget child = Container(
      width: w,
      height: h,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white30, width: 1),
        borderRadius: BorderRadius.circular(4),
        image: DecorationImage(
          image: AssetImage(card.imagePath),
          fit: BoxFit.cover,
        ),
      ),
    );

    if (isRev) {
      child = Transform.rotate(angle: 3.14159, child: child);
    }
    if (rotate) {
      child = Transform.rotate(angle: 1.5708, child: child); // 90 degrees
    }

    return Positioned(
      left: x - (w / 2),
      top: y - (h / 2),
      child: child,
    );
  }
}
