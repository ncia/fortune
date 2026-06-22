import 'package:flutter/material.dart';
import '../data/saju_diary.dart';
import '../services/diary_service.dart';
import '../widgets/gradient_background.dart';
import '../widgets/glass_container.dart';
import '../widgets/diary_tag_selector.dart';

class DiaryEditScreen extends StatefulWidget {
  final SajuDiary diary;

  const DiaryEditScreen({super.key, required this.diary});

  @override
  State<DiaryEditScreen> createState() => _DiaryEditScreenState();
}

class _DiaryEditScreenState extends State<DiaryEditScreen> {
  late TextEditingController _noteController;
  late TextEditingController _followUpController;
  late List<String> _selectedTags;

  @override
  void initState() {
    super.initState();
    _noteController = TextEditingController(text: widget.diary.myNote);
    _followUpController = TextEditingController(text: widget.diary.followUpNote);
    _selectedTags = List.from(widget.diary.tags);
  }

  @override
  void dispose() {
    _noteController.dispose();
    _followUpController.dispose();
    super.dispose();
  }

  Future<void> _saveDiary() async {
    widget.diary.myNote = _noteController.text;
    widget.diary.followUpNote = _followUpController.text;
    if (_followUpController.text.isNotEmpty && widget.diary.followUpDate == null) {
      widget.diary.followUpDate = DateTime.now();
    }
    widget.diary.tags.clear();
    widget.diary.tags.addAll(_selectedTags);

    await DiaryService.instance.updateDiary(widget.diary);
    if (!mounted) return;
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('수정', style: TextStyle(color: Colors.white)),
        actions: [
          IconButton(
            icon: const Icon(Icons.check, color: Colors.amberAccent),
            onPressed: _saveDiary,
          ),
        ],
      ),
      body: GradientBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                DiaryTagSelector(
                  selectedTags: _selectedTags,
                  onTagsChanged: (tags) {
                    setState(() {
                      _selectedTags = tags;
                    });
                  },
                ),
                const SizedBox(height: 20),

                GlassContainer(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '나의 노트',
                        style: TextStyle(
                          color: Colors.amberAccent,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: _noteController,
                        style: const TextStyle(color: Colors.white),
                        maxLines: null,
                        decoration: const InputDecoration(
                          hintText: '메모를 입력하세요',
                          hintStyle: TextStyle(color: Colors.white38),
                          border: InputBorder.none,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                GlassContainer(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '추가 사항',
                        style: TextStyle(
                          color: Colors.amberAccent,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: _followUpController,
                        style: const TextStyle(color: Colors.white),
                        maxLines: null,
                        decoration: const InputDecoration(
                          hintText: '추가 내용을 입력하세요',
                          hintStyle: TextStyle(color: Colors.white38),
                          border: InputBorder.none,
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
