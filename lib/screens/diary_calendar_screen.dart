import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import '../data/saju_diary.dart';
import '../services/diary_service.dart';
import 'diary_detail_screen.dart';
import '../widgets/glass_container.dart';
import 'package:flutter_tarot/l10n/app_localizations.dart';

class DiaryCalendarScreen extends StatefulWidget {
  const DiaryCalendarScreen({super.key});

  @override
  State<DiaryCalendarScreen> createState() => _DiaryCalendarScreenState();
}

class _DiaryCalendarScreenState extends State<DiaryCalendarScreen> {
  late DateTime _focusedDay;
  DateTime? _selectedDay;
  late Map<DateTime, List<SajuDiary>> _events;

  @override
  void initState() {
    super.initState();
    _focusedDay = DateTime.now();
    _selectedDay = _focusedDay;
    _events = DiaryService.instance.getDiaryEvents();
  }

  List<SajuDiary> _getEventsForDay(DateTime day) {
    final key = DateTime(day.year, day.month, day.day);
    return _events[key] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    final eventsForSelectedDay = _getEventsForDay(_selectedDay ?? _focusedDay);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: GlassContainer(
            padding: const EdgeInsets.all(8.0),
            child: TableCalendar<SajuDiary>(
              firstDay: DateTime.utc(2020, 1, 1),
              lastDay: DateTime.utc(2030, 12, 31),
              focusedDay: _focusedDay,
              selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                });
              },
              eventLoader: _getEventsForDay,
              calendarStyle: CalendarStyle(
                defaultTextStyle: const TextStyle(color: Colors.white),
                weekendTextStyle: const TextStyle(color: Colors.white70),
                outsideTextStyle: const TextStyle(color: Colors.white38),
                todayDecoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                selectedDecoration: const BoxDecoration(
                  color: Colors.amberAccent,
                  shape: BoxShape.circle,
                ),
                selectedTextStyle: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                markerDecoration: const BoxDecoration(
                  color: Colors.amberAccent,
                  shape: BoxShape.circle,
                ),
              ),
              headerStyle: HeaderStyle(
                titleTextStyle: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                formatButtonVisible: false,
                leftChevronIcon: const Icon(Icons.chevron_left, color: Colors.white),
                rightChevronIcon: const Icon(Icons.chevron_right, color: Colors.white),
              ),
              daysOfWeekStyle: const DaysOfWeekStyle(
                weekdayStyle: TextStyle(color: Colors.white70),
                weekendStyle: TextStyle(color: Colors.white70),
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Expanded(
          child: eventsForSelectedDay.isEmpty
              ? Center(
                  child: Text(
                    '기록이 없습니다',
                    style: TextStyle(color: Colors.white70),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: eventsForSelectedDay.length,
                  itemBuilder: (context, index) {
                    final diary = eventsForSelectedDay[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12.0),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DiaryDetailScreen(diary: diary),
                            ),
                          ).then((_) {
                            setState(() {
                              _events = DiaryService.instance.getDiaryEvents();
                            });
                          });
                        },
                        child: GlassContainer(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                diary.sajuData.split('\n').first, // Show just the name/basic info if multi-line
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                diary.resultText,
                                style: const TextStyle(color: Colors.white70),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }
}
