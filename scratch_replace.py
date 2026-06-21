import sys

file_path = 'c:/workspace/flutter_tarot/lib/widgets/spread_layouts.dart'
with open(file_path, 'r', encoding='utf-8') as f:
    content = f.read()

content = content.replace('\"역방향 (Reversed)\" : \"정방향 (Upright)\"', 'AppLocalizations.of(context)!.spreadReversed : AppLocalizations.of(context)!.spreadUpright')

with open(file_path, 'w', encoding='utf-8') as f:
    f.write(content)
print('Done!')
