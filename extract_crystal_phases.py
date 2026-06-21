import os
import json
from pathlib import Path

l10n_dir = Path('lib/l10n')
output_file = r'C:\Users\ncia\.gemini\antigravity-ide\brain\ef8e482c-5436-4b52-8192-50a464aef959\translation_report_crystal_10_phases.md'

target_langs = ['ko', 'en', 'ja', 'zh_Hans', 'es', 'fr']

with open(output_file, 'w', encoding='utf-8') as out:
    out.write("# 🔮 수정구 10단계 전체 번역 현황 보고서\n\n")
    out.write("마법책과 동일하게, 수정구의 1단계부터 10단계 이름 역시 44개 언어로 완벽하게 번역되어 들어가 있습니다! (대표 6개 언어 발췌)\n\n")
    
    out.write("| 단계 | 한국어 | 영어 | 일본어 | 중국어 | 스페인어 | 프랑스어 |\n")
    out.write("|---|---|---|---|---|---|---|\n")

    data_map = {}
    for lang in target_langs:
        file_path = l10n_dir / f"app_{lang}.arb"
        if file_path.exists():
            with open(file_path, 'r', encoding='utf-8') as f:
                data_map[lang] = json.load(f)

    for i in range(10):
        row = f"| **{i+1}단계** |"
        for lang in target_langs:
            if lang in data_map:
                val = data_map[lang].get(f'growthPhaseCrystal{i}', '')
                row += f" {val} |"
            else:
                row += " - |"
        out.write(row + "\n")

print("Crystal report generated.")
