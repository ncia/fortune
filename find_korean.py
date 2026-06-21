import os
import re

pattern = re.compile(r'[가-힣]')

def check_files():
    found_lines = []
    for root, _, files in os.walk('lib'):
        for file in files:
            if file.endswith('.dart'):
                # Ignore localization files
                if file.startswith('app_localizations'):
                    continue
                filepath = os.path.join(root, file)
                try:
                    with open(filepath, 'r', encoding='utf-8') as f:
                        lines = f.readlines()
                    for i, line in enumerate(lines):
                        stripped = line.strip()
                        if pattern.search(stripped) and not stripped.startswith('//'):
                            if "'" in stripped or '"' in stripped:
                                found_lines.append(f"{filepath}:{i+1}: {stripped}")
                except Exception as e:
                    pass
    
    with open('korean_results.log', 'w', encoding='utf-8') as f:
        for l in found_lines:
            f.write(l + '\n')

check_files()
