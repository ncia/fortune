import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../data/saju_diary.dart';
import '../widgets/gradient_background.dart';
import '../widgets/glass_container.dart';
import 'package:flutter_tarot/l10n/app_localizations.dart';

class DiaryDetailScreen extends StatefulWidget {
  final SajuDiary diary;

  const DiaryDetailScreen({super.key, required this.diary});

  @override
  State<DiaryDetailScreen> createState() => _DiaryDetailScreenState();
}

class _DiaryDetailScreenState extends State<DiaryDetailScreen> {
  late SajuDiary _diary;

  @override
  void initState() {
    super.initState();
    _diary = widget.diary;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          DateFormat('yyyy.MM.dd').format(_diary.date),
          style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      body: GradientBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (_diary.tags.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Wrap(
                      spacing: 8,
                      children: _diary.tags.map((tag) => Chip(
                        label: Text('#$tag', style: const TextStyle(fontSize: 12, color: Colors.white)),
                        backgroundColor: Colors.white.withOpacity(0.2),
                        side: BorderSide.none,
                      )).toList(),
                    ),
                  ),

                GlassContainer(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '사주 정보',
                        style: TextStyle(
                          color: Colors.amberAccent,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        _diary.sajuData,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                if (_diary.myNote.isNotEmpty) ...[
                  GlassContainer(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          '나의 질문 / 메모',
                          style: TextStyle(
                            color: Colors.amberAccent,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          _diary.myNote,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                ],

                GlassContainer(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '사주 풀이 결과',
                        style: TextStyle(
                          color: Colors.amberAccent,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        _diary.resultText,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          height: 1.6,
                        ),
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
}
