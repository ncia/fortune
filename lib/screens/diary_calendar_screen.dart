import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import '../data/tarot_diary.dart';
import '../data/tarot_data.dart';
import '../data/shaman_data.dart';
import '../widgets/glass_container.dart';
import '../widgets/shaman_profile_dialog.dart';
import '../utils/tag_localization.dart';
import '../services/diary_service.dart';
import 'diary_detail_screen.dart';
import 'package:flutter_tarot/l10n/tarot_localizations.dart';
import 'package:flutter_tarot/l10n/app_localizations.dart';
import 'package:intl/intl.dart';

class DiaryCalendarScreen extends StatefulWidget {
  const DiaryCalendarScreen({super.key});

  @override
  State<DiaryCalendarScreen> createState() => _DiaryCalendarScreenState();
}

class _DiaryCalendarScreenState extends State<DiaryCalendarScreen> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  late Map<DateTime, List<TarotDiary>> _events;

  @override
  void initState() {
    super.initState();
    _selectedDay = DateTime.now();
    _loadEvents();
  }

  void _loadEvents() {
    _events = DiaryService.instance.getDiaryEvents();
  }

  List<TarotDiary> _getEventsForDay(DateTime day) {
    final key = DateTime(day.year, day.month, day.day);
    return _events[key] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    _loadEvents();

    return SingleChildScrollView(
      child: Column(
        children: [
          // 캘린??
          GlassContainer(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            padding: const EdgeInsets.all(8),
            borderRadius: 16,
            child: TableCalendar<TarotDiary>(
              firstDay: DateTime.utc(2024, 1, 1),
              lastDay: DateTime.utc(2030, 12, 31),
              focusedDay: _focusedDay,
              calendarFormat: _calendarFormat,
              selectedDayPredicate: (day) {
                return isSameDay(_selectedDay, day);
              },
              eventLoader: _getEventsForDay,
              startingDayOfWeek: StartingDayOfWeek.monday,
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                });
              },
              onFormatChanged: (format) {
                setState(() {
                  _calendarFormat = format;
                });
              },
              onPageChanged: (focusedDay) {
                _focusedDay = focusedDay;
              },
              calendarBuilders: CalendarBuilders(
                markerBuilder: (context, date, events) {
                  if (events.isEmpty) return const SizedBox();
                  return Positioned(
                    bottom: 2,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                      decoration: BoxDecoration(
                        color: Colors.pinkAccent,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        '${events.length}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  );
                },
              ),
              calendarStyle: CalendarStyle(
                defaultTextStyle: const TextStyle(color: Colors.white),
                weekendTextStyle: const TextStyle(color: Colors.white70),
                outsideTextStyle: const TextStyle(color: Colors.white24),
                todayDecoration: BoxDecoration(
                  color: Colors.deepPurple.withOpacity(0.5),
                  shape: BoxShape.circle,
                ),
                selectedDecoration: const BoxDecoration(
                  color: Colors.purpleAccent,
                  shape: BoxShape.circle,
                ),
                todayTextStyle: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold),
                selectedTextStyle: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold),
              ),
              headerStyle: const HeaderStyle(
                formatButtonVisible: false,
                titleCentered: true,
                titleTextStyle: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
                leftChevronIcon:
                    Icon(Icons.chevron_left, color: Colors.white),
                rightChevronIcon:
                    Icon(Icons.chevron_right, color: Colors.white),
              ),
              daysOfWeekStyle: const DaysOfWeekStyle(
                weekdayStyle: TextStyle(color: Colors.white54, fontSize: 12),
                weekendStyle: TextStyle(color: Colors.white38, fontSize: 12),
              ),
            ),
          ),
          const SizedBox(height: 12),
          // ?�택???�짜???�기 목록
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.6,
            child: _buildSelectedDayDiaries(),
          ),
        ],
      ),
    );
  }

  Widget _buildSelectedDayDiaries() {
    if (_selectedDay == null) {
      return const Center(
        child: Text('날짜를 선택하세요',
            style: TextStyle(color: Colors.white54)),
      );
    }

    final diaries = _getEventsForDay(_selectedDay!);

    if (diaries.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.auto_stories, color: Colors.white24, size: 48),
            const SizedBox(height: 12),
            Text(
              AppLocalizations.of(context)!.diaryNoEntryForDate,
              style: const TextStyle(color: Colors.white54, fontSize: 14),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: diaries.length,
      itemBuilder: (context, index) {
        final diary = diaries[index];
        final card = getTarotDeck(context).firstWhere(
          (c) => c.id == diary.cardId,
          orElse: () => getTarotDeck(context).first,
        );
        final witches = getLocalizedWitches(context);
        final witch = witches.firstWhere((w) => w.id == diary.witchId,
            orElse: () => witches.first);

        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: GlassContainer(
            borderRadius: 16,
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DiaryDetailScreen(diary: diary),
                  ),
                ).then((_) => setState(() => _loadEvents()));
              },
              borderRadius: BorderRadius.circular(16),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    // 카드 ?�네??
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.asset(
                        card.imagePath,
                        width: 50,
                        height: 75,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              GestureDetector(
                                onTap: () =>
                                    showWitchProfileDialog(context, witch),
                                child: CircleAvatar(
                                  backgroundImage:
                                      AssetImage(witch.imagePath),
                                  radius: 12,
                                ),
                              ),
                              const SizedBox(width: 8),
                                Text(
                                  DateFormat('yyyy.MM.dd HH:mm').format(diary.date),
                                  style: const TextStyle(
                                      color: Colors.amberAccent, fontSize: 12),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  _getTimeAgo(diary.date, context),
                                  style: const TextStyle(
                                      color: Colors.white54, fontSize: 11),
                                ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${(diary.spreadType == '?��??�담' || diary.spreadType == AppLocalizations.of(context)!.diaryTarotConsult) ? AppLocalizations.of(context)!.diaryTarotConsult : AppLocalizations.of(context)!.diaryTarotReading} - ${TarotLocalizations.getName(context, card.id)}',
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 13),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          if (diary.tags.isNotEmpty) ...[
                            const SizedBox(height: 4),
                            Wrap(
                              spacing: 4,
                              children: diary.tags
                                  .map((tag) => Text('#${getLocalizedTag(context, tag)}',
                                      style: const TextStyle(
                                          color: Colors.pinkAccent,
                                          fontSize: 10)))
                                  .toList(),
                            ),
                          ],
                          if (diary.followUpNote.isNotEmpty) ...[
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                const Icon(Icons.edit_note,
                                    color: Colors.amberAccent, size: 12),
                                const SizedBox(width: 4),
                                Expanded(
                                  child: Text(
                                    diary.followUpNote,
                                    style: const TextStyle(
                                        color: Colors.amberAccent,
                                        fontSize: 10),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ],
                      ),
                    ),
                    const Icon(Icons.chevron_right, color: Colors.white30),
                  ],
                ),
              ),
            ),
          ),
        );
      },
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

