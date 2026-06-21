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
      age: 32,
      bloodType: l10n.witchBloodTypeB,
      height: l10n.witchHeightCm('168'),
      weight: l10n.witchWeightKg('52'),
      backgroundStory: l10n.witchBgMorgan,
      imagePath: 'assets/images/witch_morgan.jpg',
      personalityPrompt: l10n.witchPromptMorgan,
      speechifyVoiceId: 'min-seo', // 32세 여성 (도도하고 성숙함)
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
      imagePath: 'assets/images/witch_luna.jpg',
      personalityPrompt: l10n.witchPromptLuna,
      speechifyVoiceId: 'bo-kyung', // 42세 여성 (중저음, 차분함)
    ),
    Witch(
      id: 'serena',
      name: l10n.witchNameSerena,
      title: l10n.witchTitleSerena,
      age: 115,
      bloodType: l10n.witchBloodTypeO,
      height: l10n.witchHeightCm('165'),
      weight: l10n.witchWeightKg('48'),
      backgroundStory: l10n.witchBgSerena,
      imagePath: 'assets/images/witch_serena.jpg',
      personalityPrompt: l10n.witchPromptSerena,
      speechifyVoiceId: 'hee-young', // 115세 여성 (신비롭고 몽환적)
    ),
    Witch(
      id: 'aria',
      name: l10n.witchNameAria,
      title: l10n.witchTitleAria,
      age: 19,
      bloodType: l10n.witchBloodTypeA,
      height: l10n.witchHeightCm('158'),
      weight: l10n.witchWeightKg('43'),
      backgroundStory: l10n.witchBgAria,
      imagePath: 'assets/images/witch_aria.jpg',
      personalityPrompt: l10n.witchPromptAria,
      speechifyVoiceId: 'hye-won', // 19세 소녀 (밝고 경쾌함)
    ),
    Witch(
      id: 'evelyn',
      name: l10n.witchNameEvelyn,
      title: l10n.witchTitleEvelyn,
      age: 40,
      bloodType: l10n.witchBloodTypeB,
      height: l10n.witchHeightCm('172'),
      weight: l10n.witchWeightKg('55'),
      backgroundStory: l10n.witchBgEvelyn,
      imagePath: 'assets/images/witch_evelyn.jpg',
      personalityPrompt: l10n.witchPromptEvelyn,
      speechifyVoiceId: 'joo-hyun', // 40세 여성 (따뜻하고 기품있음)
    ),
    Witch(
      id: 'karen',
      name: l10n.witchNameKaren,
      title: l10n.witchTitleKaren,
      age: 92,
      bloodType: l10n.witchBloodTypeB,
      height: l10n.witchHeightCm('158'),
      weight: l10n.witchWeightKg('50'),
      backgroundStory: l10n.witchBgKaren,
      imagePath: 'assets/images/witch_karen.jpg',
      personalityPrompt: l10n.witchPromptKaren,
      speechifyVoiceId: 'soo-min', // 92세 할머니 (느리고 지혜로움)
    ),
  ];
}
