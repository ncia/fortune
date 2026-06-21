import os
import json
from pathlib import Path

l10n_dir = Path('lib/l10n')
output_file = r'C:\Users\ncia\.gemini\antigravity-ide\brain\ef8e482c-5436-4b52-8192-50a464aef959\translation_report.md'

with open(output_file, 'w', encoding='utf-8') as out:
    out.write("# 🌐 44개국 글로벌 언어 번역 결과 보고서\n\n")
    out.write("강화 화면의 **[1단계: 심연의 마력]** 포맷이 전 세계 44개 언어로 어떻게 적용되는지 확인할 수 있는 표입니다.\n\n")
    out.write("| 언어 코드 | 포맷 (Format) | 🔮 심연의 마력 | 📖 견습생의 필기구 | 적용 예시 (수정구 1단계) |\n")
    out.write("|---|---|---|---|---|\n")

    for file_path in sorted(l10n_dir.glob('*.arb')):
        filename = file_path.name
        lang = filename.replace('app_', '').replace('.arb', '')
        
        with open(file_path, 'r', encoding='utf-8') as f:
            data = json.load(f)
            
        fmt = data.get('growthPhaseFormat', '')
        crystal = data.get('growthPhaseCrystal0', '')
        book = data.get('growthPhaseBook0', '')
        
        example = fmt.replace('{level}', '1').replace('{name}', crystal)
        
        out.write(f"| **{lang}** | `{fmt}` | {crystal} | {book} | **{example}** |\n")

print("Report generated.")
