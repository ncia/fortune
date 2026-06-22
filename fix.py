with open('lib/screens/diary_calendar_screen.dart', 'r', encoding='utf-8', errors='replace') as f:
    lines = f.readlines()
start_idx = -1
for i, line in enumerate(lines):
    if 'Widget _buildSelectedDayDiaries' in line:
        start_idx = i
        break
if start_idx != -1:
    new_lines = lines[:start_idx] + [
        '  Widget _buildSelectedDayDiaries() {\n',
        '    if (_selectedDay == null) {\n',
        '      return const Center(\n',
        "        child: Text('날짜를 선택하세요',\n",
        '            style: TextStyle(color: Colors.white54)),\n',
        '      );\n',
        '    }\n'
    ] + lines[start_idx+7:]
    with open('lib/screens/diary_calendar_screen.dart', 'w', encoding='utf-8') as f:
        f.writelines(new_lines)
    print('Fixed')
else:
    print('Not found')
