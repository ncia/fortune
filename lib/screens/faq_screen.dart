import 'package:flutter/material.dart';
import 'package:flutter_tarot/l10n/app_localizations.dart';
import '../widgets/gradient_background.dart';
import '../widgets/glass_container.dart';
import '../widgets/top_floating_icons.dart';
import 'dart:math' as math;

class FaqScreen extends StatefulWidget {
  const FaqScreen({super.key});

  @override
  State<FaqScreen> createState() => _FaqScreenState();
}

class _FaqScreenState extends State<FaqScreen> {
  // Global keys to control flip cards if needed, or we can just rely on the FlipCard widget's internal state.
  
  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    
    // We have 8 FAQs. Let's make a list of questions and answers.
    final faqs = [
      {'q': localizations.faqQ1, 'a': localizations.faqA1},
      {'q': localizations.faqQ2, 'a': localizations.faqA2},
      {'q': localizations.faqQ3, 'a': localizations.faqA3},
      {'q': localizations.faqQ4, 'a': localizations.faqA4},
      {'q': localizations.faqQ5, 'a': localizations.faqA5},
      {'q': localizations.faqQ6, 'a': localizations.faqA6},
      {'q': localizations.faqQ7, 'a': localizations.faqA7},
      {'q': localizations.faqQ8, 'a': localizations.faqA8},
      {'q': localizations.faqQ9, 'a': localizations.faqA9},
      {'q': localizations.faqQ10, 'a': localizations.faqA10},
      {'q': localizations.faqQ13, 'a': localizations.faqA13},
      {'q': localizations.faqQ11, 'a': localizations.faqA11},
      {'q': localizations.faqQ12, 'a': localizations.faqA12},
    ];

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight + 65),
        child: Column(
          children: [
            const TopFloatingIcons(),
            AppBar(
              title: Text(localizations.myMenuFaq),
              centerTitle: true,
              backgroundColor: Colors.transparent,
              elevation: 0,
            ),
          ],
        ),
      ),
      body: GradientBackground(
        child: ListView.separated(
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 40),
          itemCount: faqs.length,
          separatorBuilder: (context, index) => const SizedBox(height: 16),
          itemBuilder: (context, index) {
            final faq = faqs[index];
            return FaqAccordion(
              question: faq['q']!,
              answer: faq['a']!,
            );
          },
        ),
      ),
    );
  }
}

class FaqAccordion extends StatefulWidget {
  final String question;
  final String answer;

  const FaqAccordion({super.key, required this.question, required this.answer});

  @override
  State<FaqAccordion> createState() => _FaqAccordionState();
}

class _FaqAccordionState extends State<FaqAccordion> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _isExpanded = !_isExpanded;
        });
      },
      child: GlassContainer(
        borderRadius: 16,
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.help_outline, color: Colors.amberAccent, size: 24),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    widget.question,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Icon(
                  _isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                  color: Colors.white54,
                ),
              ],
            ),
            AnimatedSize(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              child: _isExpanded
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 16),
                        Container(
                          height: 1,
                          color: Colors.white24,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          widget.answer,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                            height: 1.5,
                          ),
                        ),
                      ],
                    )
                  : const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }
}
