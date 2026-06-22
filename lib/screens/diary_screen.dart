import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../widgets/gradient_background.dart';
import '../widgets/glass_container.dart';
import '../data/saju_diary.dart';
import '../services/diary_service.dart';
import 'diary_detail_screen.dart';
import 'diary_calendar_screen.dart';
import 'package:flutter_tarot/l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'diary_edit_screen.dart';

class DiaryScreen extends StatefulWidget {
  const DiaryScreen({super.key});

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
                padding: const EdgeInsets.fromLTRB(20, 80, 20, 0),
                child: Text(
                  AppLocalizations.of(context)!.myMenuDiaryStorage,
                  style: Theme.of(context).textTheme.displayLarge,
                ),
              ),
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
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
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: TabBarView(
                  children: [
                    _buildListView(),
                    const DiaryCalendarScreen(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildListView() {
    return ValueListenableBuilder<Box<SajuDiary>>(
      valueListenable: DiaryService.instance.diaryBox.listenable(),
      builder: (context, Box<SajuDiary> box, _) {
        final diaries = box.values.toList();
        diaries.sort((a, b) => b.date.compareTo(a.date));

        if (diaries.isEmpty) {
          return Center(
            child: Text(
              '기록이 없습니다',
              style: const TextStyle(color: Colors.white70, fontSize: 16),
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(20),
          itemCount: diaries.length,
          itemBuilder: (context, index) {
            final diary = diaries[index];
            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DiaryDetailScreen(diary: diary),
                    ),
                  );
                },
                child: GlassContainer(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            DateFormat('yyyy.MM.dd').format(diary.date),
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                            ),
                          ),
                          Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit, color: Colors.white70, size: 20),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => DiaryEditScreen(diary: diary),
                                    ),
                                  );
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete, color: Colors.redAccent, size: 20),
                                onPressed: () => _confirmDelete(context, diary.id),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        diary.sajuData.split('\n').first,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        diary.resultText,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
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

  Future<void> _confirmDelete(BuildContext context, String diaryId) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.deepPurple.shade900,
        title: Text('삭제', style: const TextStyle(color: Colors.white)),
        content: Text('정말로 삭제하시겠습니까?', style: const TextStyle(color: Colors.white70)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text('취소', style: const TextStyle(color: Colors.white70)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text('삭제', style: const TextStyle(color: Colors.redAccent)),
          ),
        ],
      ),
    );

    if (result == true) {
      await DiaryService.instance.deleteDiary(diaryId);
    }
  }
}
