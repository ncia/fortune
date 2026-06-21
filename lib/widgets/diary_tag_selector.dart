import 'package:flutter/material.dart';
import '../services/diary_service.dart';
import '../widgets/glass_container.dart';
import 'package:flutter_tarot/l10n/app_localizations.dart';
import '../utils/tag_localization.dart';

/// 태그 선택 다이얼로그 (기본 태그 + 커스텀 태그 추가/삭제)
class DiaryTagSelector extends StatefulWidget {
  final List<String> selectedTags;
  final ValueChanged<List<String>> onTagsChanged;

  const DiaryTagSelector({
    super.key,
    required this.selectedTags,
    required this.onTagsChanged,
  });

  @override
  State<DiaryTagSelector> createState() => _DiaryTagSelectorState();
}

class _DiaryTagSelectorState extends State<DiaryTagSelector> {
  late List<String> _selected;
  final TextEditingController _customTagController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _selected = List.from(widget.selectedTags);
  }

  @override
  void dispose() {
    _customTagController.dispose();
    super.dispose();
  }

  void _toggleTag(String tag) {
    setState(() {
      if (_selected.contains(tag)) {
        _selected.remove(tag);
      } else {
        _selected.add(tag);
      }
    });
    widget.onTagsChanged(_selected);
  }

  void _addCustomTag() {
    final tag = _customTagController.text.trim();
    if (tag.isEmpty) return;
    if (DiaryService.instance.getAllTags().contains(tag)) {
      // 이미 존재하면 선택만
      if (!_selected.contains(tag)) {
        _toggleTag(tag);
      }
    } else {
      DiaryService.instance.addCustomTag(tag);
      _toggleTag(tag);
    }
    _customTagController.clear();
    setState(() {});
  }

  void _deleteCustomTag(String tag) {
    DiaryService.instance.removeCustomTag(tag);
    _selected.remove(tag);
    widget.onTagsChanged(_selected);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final allTags = DiaryService.instance.getAllTags();
    final defaultTags = DiaryService.defaultTags;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          AppLocalizations.of(context)!.diaryTagTitle,
          style: const TextStyle(
              color: Colors.amberAccent,
              fontWeight: FontWeight.bold,
              fontSize: 14),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: allTags.map((tag) {
            final isSelected = _selected.contains(tag);
            final isCustom = !defaultTags.contains(tag);
            return GestureDetector(
              onTap: () => _toggleTag(tag),
              onLongPress: isCustom
                  ? () {
                      showDialog(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          backgroundColor: Colors.deepPurple.shade900,
                          title: Text(
                            AppLocalizations.of(context)!.diaryTagDeleteConfirm,
                            style: const TextStyle(color: Colors.white),
                          ),
                          content: Text(
                            '#$tag',
                            style: const TextStyle(color: Colors.white70),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(ctx),
                              child: Text(
                                AppLocalizations.of(context)!.myMenuConfirm,
                                style: const TextStyle(color: Colors.white54),
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                _deleteCustomTag(tag);
                                Navigator.pop(ctx);
                              },
                              child: Text(
                                AppLocalizations.of(context)!.diaryTagDelete,
                                style:
                                    const TextStyle(color: Colors.redAccent),
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                  : null,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: isSelected
                      ? Colors.purpleAccent.withOpacity(0.4)
                      : Colors.white.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected
                        ? Colors.purpleAccent
                        : Colors.white24,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '#${getLocalizedTag(context, tag)}',
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.white70,
                        fontSize: 13,
                        fontWeight: isSelected
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                    if (isCustom) ...[
                      const SizedBox(width: 4),
                      const Icon(Icons.close, size: 12, color: Colors.white38),
                    ],
                  ],
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 12),
        // 커스텀 태그 추가 입력
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _customTagController,
                style: const TextStyle(color: Colors.white, fontSize: 13),
                decoration: InputDecoration(
                  hintText: AppLocalizations.of(context)!.diaryTagAddHint,
                  hintStyle: const TextStyle(color: Colors.white30, fontSize: 13),
                  isDense: true,
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: const BorderSide(color: Colors.white24),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: const BorderSide(color: Colors.white24),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: const BorderSide(color: Colors.purpleAccent),
                  ),
                ),
                onSubmitted: (_) => _addCustomTag(),
              ),
            ),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: _addCustomTag,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.purpleAccent.withOpacity(0.3),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.add, color: Colors.white, size: 18),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
