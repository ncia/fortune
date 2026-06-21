import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../widgets/gradient_background.dart';
import '../widgets/glass_container.dart';
import '../data/tarot_diary.dart';
import '../data/tarot_data.dart';
import '../data/witch_data.dart';
import '../widgets/witch_profile_dialog.dart';
import '../services/diary_service.dart';
import 'diary_detail_screen.dart';
import 'diary_calendar_screen.dart';
import 'package:flutter_tarot/l10n/tarot_localizations.dart';
import 'package:flutter_tarot/l10n/app_localizations.dart';
import '../utils/tag_localization.dart';
import 'package:intl/intl.dart';
import 'auth_screen.dart';
import '../screens/diary_edit_screen.dart';

class DiaryScreen extends StatefulWidget {
  DiaryScreen({super.key});

  @override
  State<DiaryScreen> createState() => _DiaryScreenState();
}

class _DiaryScreenState extends State<DiaryScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: GradientBackground(
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(20, 80, 20, 0),
                child: Text(
                  AppLocalizations.of(context)!.myMenuDiaryStorage,
                  style: Theme.of(context).textTheme.displayLarge,
                ),
              ),
              SizedBox(height: 12),
              // 탭 바
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: Colors.white.withOpacity(0.2), width: 1),
                    ),
                  ),
                  child: TabBar(
                    indicatorColor: Colors.amberAccent,
                    indicatorWeight: 3.0,
                    labelColor: Colors.amberAccent,
                    unselectedLabelColor: Colors.grey,
                    indicatorSize: TabBarIndicatorSize.label,
                    tabs: [
                      Tab(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.list, color: Colors.amberAccent),
                            const SizedBox(width: 8),
                            Text(AppLocalizations.of(context)!.diaryViewList, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                            const SizedBox(width: 32),
                          ],
                        ),
                      ),
                      Tab(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.calendar_month, color: Colors.amberAccent),
                            const SizedBox(width: 8),
                            Text(AppLocalizations.of(context)!.diaryViewCalendar, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                            const SizedBox(width: 32),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 8),
              Expanded(
                child: TabBarView(
                  children: [
                    _DiaryListView(),
                    DiaryCalendarScreen(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DiaryListView extends StatelessWidget {
  const _DiaryListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: DiaryService.instance.diaryBox.listenable(),
      builder: (context, Box<TarotDiary> box, _) {
        final diaries = DiaryService.instance.getAllDiaries();
        if (diaries.isEmpty) {
          return Center(
            child: Text(
              AppLocalizations.of(context)!.diaryEmpty,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white70),
            ),
          );
        }
        return ListView.builder(
          padding: EdgeInsets.symmetric(horizontal: 16),
          itemCount: diaries.length,
          itemBuilder: (context, index) {
            final diary = diaries[index];
            final card = getTarotDeck(context).firstWhere(
              (c) => c.id == diary.cardId,
              orElse: () => getTarotDeck(context).first,
            );
            return Padding(
              padding: EdgeInsets.only(bottom: 16.0),
              child: GlassContainer(
                borderRadius: 16,
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DiaryDetailScreen(diary: diary),
                      ),
                    );
                  },
                  borderRadius: BorderRadius.circular(16),
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _buildWitchAvatar(context, diary.witchId),
                            SizedBox(height: 8),
                            _buildDiaryThumbnails(context, diary),
                          ],
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    DateFormat('yyyy.MM.dd HH:mm').format(diary.date),
                                    style: TextStyle(color: Colors.amberAccent, fontSize: 12),
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    _getTimeAgo(diary.date, context),
                                    style: TextStyle(color: Colors.white54, fontSize: 11),
                                  ),
                                ],
                              ),
                              SizedBox(height: 4),
                              Text(
                                '${diary.spreadType == "타로 상담" ? AppLocalizations.of(context)!.diaryTarotConsult : AppLocalizations.of(context)!.diaryTarotReading} - ${TarotLocalizations.getName(context, card.id)}${diary.cardIds.length > 1 ? " ${AppLocalizations.of(context)!.diaryAndMore(diary.cardIds.length - 1)}" : ""}',
                                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                              ),
                              if (diary.tags.isNotEmpty) ...[
                                SizedBox(height: 6),
                                Wrap(
                                  spacing: 4,
                                  runSpacing: 2,
                                  children: diary.tags.map((tag) => Container(
                                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                    decoration: BoxDecoration(color: Colors.purpleAccent.withOpacity(0.3), borderRadius: BorderRadius.circular(10)),
                                    child: Text('#${getLocalizedTag(context, tag)}', style: TextStyle(color: Colors.pinkAccent, fontSize: 10)),
                                  )).toList(),
                                ),
                              ],
                              SizedBox(height: 8),
                              if (diary.myNote.isNotEmpty && diary.myNote != '타로 리딩')
                                Container(
                                  width: double.infinity,
                                  padding: EdgeInsets.all(8),
                                  margin: EdgeInsets.only(bottom: 8),
                                  decoration: BoxDecoration(color: Colors.black26, borderRadius: BorderRadius.circular(8)),
                                  child: Text('Q: ${diary.myNote}', style: TextStyle(color: Colors.white70, fontSize: 12, fontStyle: FontStyle.italic), maxLines: 2, overflow: TextOverflow.ellipsis),
                                ),
                              Text(
                                diary.resultText.isNotEmpty ? diary.resultText : (diary.cardMeanings.isNotEmpty ? diary.cardMeanings.join('\\n') : ''),
                                style: TextStyle(color: Colors.white, fontSize: 13, height: 1.4),
                                maxLines: 4,
                                overflow: TextOverflow.ellipsis,
                              ),
                              if (diary.followUpNote.isNotEmpty) ...[
                                SizedBox(height: 8),
                                Container(
                                  width: double.infinity,
                                  padding: EdgeInsets.all(8),
                                  decoration: BoxDecoration(color: Colors.amberAccent.withOpacity(0.1), borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.amberAccent.withOpacity(0.3))),
                                  child: Row(
                                    children: [
                                      Icon(Icons.edit_note, color: Colors.amberAccent, size: 14),
                                      SizedBox(width: 4),
                                      Expanded(child: Text(diary.followUpNote, style: TextStyle(color: Colors.amberAccent, fontSize: 11))),
                                    ],
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }


  Widget _buildDiaryThumbnails(BuildContext context, TarotDiary diary) {
    double targetWidth = 120.0;
    double cardWidth = 60.0;
    double cardHeight = 90.0;

    if (diary.cardIds.length <= 1) {
      final cardId =
          diary.cardIds.isNotEmpty ? diary.cardIds.first : diary.cardId;
      final card = getTarotDeck(context).firstWhere((c) => c.id == cardId,
          orElse: () => getTarotDeck(context).first);
      return SizedBox(
        width: targetWidth,
        height: cardHeight,
        child: Align(
          alignment: Alignment.center,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(card.imagePath,
                width: cardWidth, height: cardHeight, fit: BoxFit.cover),
          ),
        ),
      );
    }

    final displayCount = diary.cardIds.length;
    final maxAvailableOffsetWidth = targetWidth - cardWidth;
    final double offset = maxAvailableOffsetWidth / (displayCount - 1);

    return SizedBox(
      width: targetWidth,
      height: cardHeight,
      child: Stack(
        children: List.generate(displayCount, (index) {
          final cardId = diary.cardIds[index];
          final card = getTarotDeck(context).firstWhere((c) => c.id == cardId,
              orElse: () => getTarotDeck(context).first);
          return Positioned(
            left: index * offset,
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black45,
                        blurRadius: 4,
                        offset: Offset(2, 0))
                  ]),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.asset(card.imagePath,
                    width: cardWidth, height: cardHeight, fit: BoxFit.cover),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildWitchAvatar(BuildContext context, String? witchId) {
    final witches = getLocalizedWitches(context);
    final witch = witches.firstWhere((w) => w.id == witchId,
        orElse: () => witches.first);
    return GestureDetector(
      onTap: () {
        showWitchProfileDialog(context, witch);
      },
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.purpleAccent, width: 2),
          image: DecorationImage(
            image: AssetImage(witch.imagePath),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

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
}
