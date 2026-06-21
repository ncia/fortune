import 'package:flutter/material.dart';
import '../widgets/gradient_background.dart';
import '../widgets/glass_container.dart';
import '../widgets/spread_layouts.dart';
import '../widgets/witch_profile_dialog.dart';
import '../widgets/diary_tag_selector.dart';
import '../data/tarot_diary.dart';
import '../data/tarot_data.dart';
import '../data/witch_data.dart';
import '../data/spread_type.dart';
import '../services/diary_service.dart';
import '../services/translation_service.dart';
import 'package:flutter_tarot/l10n/tarot_localizations.dart';
import 'package:flutter_tarot/l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import '../widgets/emoji_picker_widget.dart';

class DiaryDetailScreen extends StatefulWidget {
  final TarotDiary diary;

  const DiaryDetailScreen({super.key, required this.diary});

  @override
  State<DiaryDetailScreen> createState() => _DiaryDetailScreenState();
}

class _DiaryDetailScreenState extends State<DiaryDetailScreen> {
  late TarotDiary _diary;
  final TextEditingController _followUpController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool _isEditingFollowUp = false;
  bool _showEmojiPicker = false;

  bool _isTranslating = false;
  String? _translatedResultText;
  String? _translatedMyNote;
  final TranslationService _translationService = TranslationService();

  @override
  void initState() {
    super.initState();
    _diary = widget.diary;
    _followUpController.text = _diary.followUpNote;
    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        setState(() {
          _showEmojiPicker = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _followUpController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _saveFollowUp() async {
    final updated = _diary.copyWithFollowUp(
      followUpNote: _followUpController.text.trim(),
      followUpDate: DateTime.now(),
    );
    await DiaryService.instance.updateDiary(updated);
    setState(() {
      _diary = updated;
      _isEditingFollowUp = false;
    });
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.diaryFollowUpSaved),
          backgroundColor: Colors.purple,
        ),
      );
    }
  }

  void _updateTags(List<String> newTags) async {
    final updated = _diary.copyWithTags(newTags);
    await DiaryService.instance.updateDiary(updated);
    setState(() {
      _diary = updated;
    });
  }

  void _translateDiary() async {
    if (_isTranslating) return;
    setState(() => _isTranslating = true);

    try {
      final targetLocale = View.of(context).platformDispatcher.locale.languageCode;
      
      String translatedResult = _diary.resultText;
      if (translatedResult.isEmpty && _diary.cardMeanings.isNotEmpty) {
        translatedResult = _diary.cardMeanings.join('\n\n');
      }

      if (translatedResult.isNotEmpty) {
        translatedResult = await _translationService.translateText(translatedResult, targetLocale);
      }
      
      String translatedNote = _diary.myNote;
      if (translatedNote.isNotEmpty && translatedNote != '타로 리딩' && translatedNote != AppLocalizations.of(context)!.diaryTarotReading) {
        translatedNote = await _translationService.translateText(translatedNote, targetLocale);
      }

      if (mounted) {
        setState(() {
          _translatedResultText = translatedResult;
          _translatedMyNote = translatedNote;
        });
      }
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context)!.translateFailed(e.toString()))));
    } finally {
      if (mounted) setState(() => _isTranslating = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    // SpreadType 복원
    SpreadType spreadType;
    if (_diary.spreadType == '타로 상담' || _diary.spreadType == AppLocalizations.of(context)!.diaryTarotConsult) {
      if (_diary.cardIds.length == 1) spreadType = SpreadType.oneCard;
      else if (_diary.cardIds.length == 2) spreadType = SpreadType.twoCard;
      else if (_diary.cardIds.length == 3) spreadType = SpreadType.threeCard;
      else if (_diary.cardIds.length == 4) spreadType = SpreadType.fourCard;
      else if (_diary.cardIds.length == 5) spreadType = SpreadType.fiveCard;
      else if (_diary.cardIds.length == 10) spreadType = SpreadType.celticCross;
      else spreadType = SpreadType.oneCard;
    } else {
      spreadType = SpreadType.values.firstWhere(
        (e) => e.name == _diary.spreadType,
        orElse: () => SpreadType.oneCard,
      );
    }

    final shuffledDeck = _diary.cardIds
        .map((id) => getTarotDeck(context).firstWhere((c) => c.id == id,
            orElse: () => getTarotDeck(context).first))
        .toList();
    final selectedCardIndices =
        List.generate(shuffledDeck.length, (i) => i);

    final shuffledReversed = List.generate(shuffledDeck.length, (i) {
      if (i < _diary.cardReversals.length) return _diary.cardReversals[i];
      return false;
    });

    final witches = getLocalizedWitches(context);
    final witch = witches.firstWhere((w) => w.id == _diary.witchId,
        orElse: () => witches.first);

    return Scaffold(
      body: GradientBackground(
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 50),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                    Text(
                      DateFormat('yyyy.MM.dd HH:mm').format(_diary.date),
                      style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete_outline, color: Colors.white54),
                      onPressed: () async {
                        final confirm = await showDialog<bool>(
                          context: context,
                          builder: (ctx) => AlertDialog(
                            backgroundColor: Colors.deepPurple.shade900,
                            title: Text(
                              AppLocalizations.of(context)!.diaryDeleteTitle,
                              style: const TextStyle(color: Colors.white),
                            ),
                            content: Text(
                              AppLocalizations.of(context)!.diaryDeleteConfirm,
                              style: const TextStyle(color: Colors.white70),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(ctx, false),
                                child: Text(
                                  AppLocalizations.of(context)!.myMenuConfirm,
                                  style: const TextStyle(color: Colors.white54),
                                ),
                              ),
                              TextButton(
                                onPressed: () => Navigator.pop(ctx, true),
                                child: Text(
                                  AppLocalizations.of(context)!.diaryTagDelete,
                                  style: const TextStyle(color: Colors.redAccent),
                                ),
                              ),
                            ],
                          ),
                        );
                        if (confirm == true && mounted) {
                          await DiaryService.instance.deleteDiary(_diary.id);
                          Navigator.pop(context);
                        }
                      },
                    ),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // 커뮤니티 공개 여부 설정
                GlassContainer(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  borderRadius: 16,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.public, color: Colors.cyanAccent),
                          const SizedBox(width: 8),
                          Text(
                            AppLocalizations.of(context)!.diaryShareToCommunity,
                            style: const TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        ],
                      ),
                      Switch(
                        value: _diary.isPublic,
                        activeColor: Colors.cyanAccent,
                        onChanged: (value) async {
                          final updated = _diary;
                          updated.isPublic = value;
                          await DiaryService.instance.updateDiary(updated);
                          setState(() {
                            _diary = updated;
                          });
                          if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(value ? AppLocalizations.of(context)!.diarySharedSuccess : AppLocalizations.of(context)!.diaryPrivateSuccess),
                                backgroundColor: value ? Colors.cyan : Colors.grey,
                              ),
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // 질문
                if (_diary.myNote.isNotEmpty && _diary.myNote != AppLocalizations.of(context)!.diaryTarotReading) ...[
                  GlassContainer(
                    padding: const EdgeInsets.all(16),
                    borderRadius: 16,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(AppLocalizations.of(context)!.diaryMyQuestion,
                            style: const TextStyle(
                                color: Colors.amberAccent,
                                fontWeight: FontWeight.bold,
                                fontSize: 14)),
                        const SizedBox(height: 8),
                        Text(_translatedMyNote ?? _diary.myNote,
                            style: const TextStyle(
                                color: Colors.white, fontSize: 16)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                ],

                // 태그 섹션
                GlassContainer(
                  padding: const EdgeInsets.all(16),
                  borderRadius: 16,
                  child: DiaryTagSelector(
                    selectedTags: _diary.tags,
                    onTagsChanged: _updateTags,
                  ),
                ),
                const SizedBox(height: 20),

                // 스프레드 레이아웃
                SpreadLayoutBuilder(
                  spreadType: spreadType,
                  selectedCardIndices: selectedCardIndices,
                  shuffledDeck: shuffledDeck,
                  shuffledReversed: shuffledReversed,
                  isForChat: false,
                ),

                const SizedBox(height: 20),

                // 리딩 결과
                GlassContainer(
                  padding: const EdgeInsets.all(16),
                  borderRadius: 16,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              showWitchProfileDialog(context, witch);
                            },
                            child: CircleAvatar(
                              backgroundImage: AssetImage(witch.imagePath),
                              radius: 16,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '${witch.name}${AppLocalizations.of(context)!.diaryWitchReading}',
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        _translatedResultText ?? (_diary.resultText.isNotEmpty
                            ? _diary.resultText
                            : (_diary.cardMeanings.isNotEmpty
                                ? _diary.cardMeanings.join('\n\n')
                                : AppLocalizations.of(context)!.diaryNoResult)),
                        style: const TextStyle(
                            color: Colors.white, fontSize: 15, height: 1.5),
                      ),
                      const SizedBox(height: 12),
                      if (_translatedResultText == null)
                        Align(
                          alignment: Alignment.centerRight,
                          child: OutlinedButton(
                            onPressed: _translateDiary,
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.white,
                              side: const BorderSide(color: Colors.orange),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                            ),
                            child: _isTranslating
                                ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.orange))
                                : Text(AppLocalizations.of(context)!.buttonTranslate, style: const TextStyle(fontSize: 13, color: Colors.white)),
                          ),
                        ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // 후일담 메모 섹션
                GlassContainer(
                  padding: const EdgeInsets.all(16),
                  borderRadius: 16,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.edit_note,
                              color: Colors.amberAccent, size: 20),
                          const SizedBox(width: 8),
                          Text(
                            AppLocalizations.of(context)!.diaryFollowUpTitle,
                            style: const TextStyle(
                                color: Colors.amberAccent,
                                fontWeight: FontWeight.bold,
                                fontSize: 14),
                          ),
                          const Spacer(),
                          if (_diary.followUpDate != null)
                            Text(
                              DateFormat('yyyy.MM.dd').format(_diary.followUpDate!),
                              style: const TextStyle(
                                  color: Colors.white38, fontSize: 11),
                            ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      if (_diary.followUpNote.isNotEmpty && !_isEditingFollowUp) ...[
                        Text(
                          _diary.followUpNote,
                          style: const TextStyle(
                              color: Colors.white, fontSize: 14, height: 1.5),
                        ),
                        const SizedBox(height: 12),
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton.icon(
                            onPressed: () {
                              setState(() {
                                _isEditingFollowUp = true;
                              });
                            },
                            icon: const Icon(Icons.edit, size: 16),
                            label: Text(AppLocalizations.of(context)!.diaryFollowUpEdit),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.amberAccent,
                              side: const BorderSide(color: Colors.amberAccent),
                            ),
                          ),
                        ),
                      ] else ...[
                        Text(
                          AppLocalizations.of(context)!.diaryFollowUpHint,
                          style: const TextStyle(
                              color: Colors.white38, fontSize: 12),
                        ),
                        const SizedBox(height: 8),
                        TextField(
                          controller: _followUpController,
                          focusNode: _focusNode,
                          style:
                              const TextStyle(color: Colors.white, fontSize: 14),
                          maxLines: 4,
                          decoration: InputDecoration(
                            hintText: AppLocalizations.of(context)!.diaryFollowUpPlaceholder,
                            hintStyle: const TextStyle(color: Colors.white30),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide:
                                  const BorderSide(color: Colors.white24),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide:
                                  const BorderSide(color: Colors.white24),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide:
                                  const BorderSide(color: Colors.amberAccent),
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(_showEmojiPicker ? Icons.keyboard : Icons.emoji_emotions_outlined, color: Colors.white54),
                              onPressed: () {
                                setState(() {
                                  _showEmojiPicker = !_showEmojiPicker;
                                  if (_showEmojiPicker) {
                                    FocusScope.of(context).unfocus();
                                  } else {
                                    _focusNode.requestFocus();
                                  }
                                });
                              },
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: _saveFollowUp,
                            icon: const Icon(Icons.save, size: 16),
                            label: Text(AppLocalizations.of(context)!.diaryFollowUpSave),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.deepPurple,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)),
                            ),
                          ),
                        ),
                        EmojiPickerWidget(
                          controller: _followUpController,
                          isVisible: _showEmojiPicker,
                        ),
                      ],
                    ],
                  ),
                ),

                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
            ],
          ),
        ),
      ),
    );
  }
}
