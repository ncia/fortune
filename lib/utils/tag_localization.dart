import 'package:flutter/widgets.dart';
import 'package:flutter_tarot/l10n/app_localizations.dart';

String getLocalizedTag(BuildContext context, String tag) {
  final loc = AppLocalizations.of(context);
  if (loc == null) return tag;

  switch (tag) {
    case '연애운': return loc.tagLove;
    case '금전운': return loc.tagMoney;
    case '건강운': return loc.tagHealth;
    case '직장운': return loc.tagCareer;
    case '오늘운세': return loc.tagToday;
    case '인간관계': return loc.tagRelationship;
    case '자기성찰': return loc.tagSelfReflection;
    default: return tag;
  }
}
