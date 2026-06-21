import 'package:flutter/material.dart';
import 'package:flutter_tarot/l10n/app_localizations.dart';

List<String> getNicknamePrefixes(BuildContext context) {
  return AppLocalizations.of(context)!.nicknamePrefixes.split(',');
}

List<String> getNicknameSuffixes(BuildContext context) {
  return AppLocalizations.of(context)!.nicknameSuffixes.split(',');
}
