import 'package:flutter/material.dart';
import 'package:flutter_tarot/l10n/app_localizations.dart';

class Witch {
  final String id;
  final String name;
  final String title;
  final int age;
  final String bloodType;
  final String height;
  final String weight;
  final String backgroundStory;
  final String imagePath;
  final String personalityPrompt;
  final String speechifyVoiceId;
  final String sajuGreeting;
  final double playbackRate;
  final double pitch;

  const Witch({
    required this.id,
    required this.name,
    required this.title,
    required this.age,
    required this.bloodType,
    required this.height,
    required this.weight,
    required this.backgroundStory,
    required this.imagePath,
    required this.personalityPrompt,
    required this.speechifyVoiceId,
    required this.sajuGreeting,
    this.playbackRate = 1.0,
    this.pitch = 1.0,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Witch && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

List<Witch> getLocalizedWitches(BuildContext context) {
  final l10n = AppLocalizations.of(context)!;
  return [
    Witch(
      id: 'morgan',
      name: l10n.witchNameMorgan,
      title: l10n.witchTitleMorgan,
      age: 35,
      bloodType: l10n.witchBloodTypeB,
      height: l10n.witchHeightCm('168'),
      weight: l10n.witchWeightKg('52'),
      backgroundStory: l10n.witchBgMorgan,
      imagePath: 'assets/images/haewon_bosal.png',
      personalityPrompt: l10n.witchPromptMorgan,
      speechifyVoiceId: 'min-seo',
      sajuGreeting: l10n.witchSajuGreetingMorgan,
      playbackRate: 0.95,
      pitch: 1.0,
    ),
    Witch(
      id: 'luna',
      name: l10n.witchNameLuna,
      title: l10n.witchTitleLuna,
      age: 42,
      bloodType: l10n.witchBloodTypeAB,
      height: l10n.witchHeightCm('160'),
      weight: l10n.witchWeightKg('45'),
      backgroundStory: l10n.witchBgLuna,
      imagePath: 'assets/images/yonghwa_sindang.png',
      personalityPrompt: l10n.witchPromptLuna,
      speechifyVoiceId: 'bo-kyung',
      sajuGreeting: l10n.witchSajuGreetingLuna,
      playbackRate: 1.05,
      pitch: 0.95,
    ),
    Witch(
      id: 'serena',
      name: l10n.witchNameSerena,
      title: l10n.witchTitleSerena,
      age: 92,
      bloodType: l10n.witchBloodTypeO,
      height: l10n.witchHeightCm('165'),
      weight: l10n.witchWeightKg('48'),
      backgroundStory: l10n.witchBgSerena,
      imagePath: 'assets/images/mansin_grandma.png',
      personalityPrompt: l10n.witchPromptSerena,
      speechifyVoiceId: 'hee-young',
      sajuGreeting: l10n.witchSajuGreetingSerena,
      playbackRate: 0.85,
      pitch: 0.85,
    ),
    Witch(
      id: 'aria',
      name: l10n.witchNameAria,
      title: l10n.witchTitleAria,
      age: 23,
      bloodType: l10n.witchBloodTypeA,
      height: l10n.witchHeightCm('158'),
      weight: l10n.witchWeightKg('43'),
      backgroundStory: l10n.witchBgAria,
      imagePath: 'assets/images/baby_fairy.png',
      personalityPrompt: l10n.witchPromptAria,
      speechifyVoiceId: 'hye-won',
      sajuGreeting: l10n.witchSajuGreetingAria,
      playbackRate: 1.15,
      pitch: 1.15,
    ),
    Witch(
      id: 'evelyn',
      name: l10n.witchNameEvelyn,
      title: l10n.witchTitleEvelyn,
      age: 25,
      bloodType: l10n.witchBloodTypeB,
      height: l10n.witchHeightCm('172'),
      weight: l10n.witchWeightKg('55'),
      backgroundStory: l10n.witchBgEvelyn,
      imagePath: 'assets/images/cheonghak_doryeong.png',
      personalityPrompt: l10n.witchPromptEvelyn,
      speechifyVoiceId: 'min-ho',
      sajuGreeting: l10n.witchSajuGreetingEvelyn,
      playbackRate: 1.0,
      pitch: 1.05,
    ),
    Witch(
      id: 'karen',
      name: l10n.witchNameKaren,
      title: l10n.witchTitleKaren,
      age: 78,
      bloodType: l10n.witchBloodTypeB,
      height: l10n.witchHeightCm('158'),
      weight: l10n.witchWeightKg('50'),
      backgroundStory: l10n.witchBgKaren,
      imagePath: 'assets/images/baekun_dosa.png',
      personalityPrompt: l10n.witchPromptKaren,
      speechifyVoiceId: 'sang-hoon',
      sajuGreeting: l10n.witchSajuGreetingKaren,
      playbackRate: 0.8,
      pitch: 0.8,
    ),
  ];
}
