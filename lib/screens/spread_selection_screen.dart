import 'package:flutter/material.dart';
import 'package:flutter_tarot/l10n/app_localizations.dart';
import '../data/spread_type.dart';
import '../widgets/gradient_background.dart';
import '../widgets/glass_container.dart';
import 'tarot_reading_screen.dart';
import '../data/shaman_data.dart';
import '../services/economy_service.dart';

class SpreadSelectionScreen extends StatelessWidget {
  final bool showBackButton;
  final Witch? selectedWitch;
  const SpreadSelectionScreen({super.key, this.showBackButton = false, this.selectedWitch});

  @override
  Widget build(BuildContext context) {
    // Scaffold without AppBar so it blends nicely as a tab, or with a simple title.
    return Scaffold(
      body: GradientBackground(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20.0, 60.0, 20.0, 30.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    if (showBackButton)
                      IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                      ),
                    Expanded(
                      child: Text(
                        AppLocalizations.of(context)!.spreadSelectionTitle,
                        style: Theme.of(context).textTheme.displayLarge,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    if (showBackButton) const SizedBox(width: 48), // Balance for centering
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  AppLocalizations.of(context)!.spreadSelectionSubtitle,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.white70,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),
                Expanded(
                  child: ListView(
                    children: [
                      _buildSpreadCard(
                        context,
                        title: AppLocalizations.of(context)!.spreadOneCardName,
                        description: AppLocalizations.of(context)!.spreadOneCardDesc,
                        icon: Icons.pan_tool,
                        type: SpreadType.oneCard,
                      ),
                      const SizedBox(height: 16),
                      _buildSpreadCard(
                        context,
                        title: AppLocalizations.of(context)!.spreadTwoCardName,
                        description: AppLocalizations.of(context)!.spreadTwoCardDesc,
                        icon: Icons.face,
                        type: SpreadType.twoCard,
                      ),
                      const SizedBox(height: 16),
                      _buildSpreadCard(
                        context,
                        title: AppLocalizations.of(context)!.spreadThreeCardName,
                        description: AppLocalizations.of(context)!.spreadThreeCardDesc,
                        icon: Icons.menu_book, // Saju (Destiny Book)
                        type: SpreadType.threeCard,
                      ),
                      const SizedBox(height: 16),
                      _buildSpreadCard(
                        context,
                        title: AppLocalizations.of(context)!.spreadFourCardName,
                        description: AppLocalizations.of(context)!.spreadFourCardDesc,
                        icon: Icons.style, // Hwatu
                        type: SpreadType.fourCard,
                      ),
                      const SizedBox(height: 16),
                      _buildSpreadCard(
                        context,
                        title: AppLocalizations.of(context)!.spreadFiveCardName,
                        description: AppLocalizations.of(context)!.spreadFiveCardDesc,
                        icon: Icons.calendar_month, // Hwatu Monthly Fortune
                        type: SpreadType.fiveCard,
                      ),
                      const SizedBox(height: 16),
                      _buildSpreadCard(
                        context,
                        title: AppLocalizations.of(context)!.spreadCelticCrossName,
                        description: AppLocalizations.of(context)!.spreadCelticCrossDesc,
                        icon: Icons.calculate, // Hwatu Number Calculation
                        type: SpreadType.celticCross,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSpreadCard(BuildContext context, {required String title, required String description, required IconData icon, required SpreadType type}) {
    return GestureDetector(
      onTap: () async {
        final economy = EconomyService();
        if (economy.coins < 1) {
          showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
              backgroundColor: Colors.deepPurple.shade900,
              title: Text(AppLocalizations.of(context)!.coinShortageTitle, style: const TextStyle(color: Colors.white)),
              content: Text(AppLocalizations.of(context)!.coinShortageContent, style: const TextStyle(color: Colors.white70)),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: Text(AppLocalizations.of(context)!.dialogOk, style: const TextStyle(color: Colors.amberAccent)),
                ),
              ],
            ),
          );
          return;
        }

        final confirm = await showDialog<bool>(
          context: context,
          builder: (ctx) => AlertDialog(
            backgroundColor: Colors.deepPurple.shade900,
            title: Text(AppLocalizations.of(context)!.proceedReadingTitle, style: const TextStyle(color: Colors.white)),
            content: Text(AppLocalizations.of(context)!.proceedReadingContent, style: const TextStyle(color: Colors.white70)),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx, false),
                child: Text(AppLocalizations.of(context)!.dialogCancel, style: const TextStyle(color: Colors.white54)),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(ctx, true),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.purpleAccent),
                child: Text(AppLocalizations.of(context)!.dialogProceed, style: const TextStyle(color: Colors.white)),
              ),
            ],
          ),
        );

        if (confirm != true) return;

        final success = await economy.deductCoin(1);
        if (!success) return;

        if (context.mounted) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TarotReadingScreen(spreadType: type, selectedWitch: selectedWitch, skipIntro: true),
            ),
          );
        }
      },
      child: GlassContainer(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: Colors.amberAccent, size: 32),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
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
  }
}

