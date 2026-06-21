import os

def generate_exp_table(power):
    base_sum = 1000 * 100
    growth_sum_needed = 1000000 - base_sum
    
    raw_growth = [(L - 1) ** power for L in range(1, 101)]
    actual_raw_growth_sum = sum(raw_growth)
    
    K = growth_sum_needed / actual_raw_growth_sum
    
    table = []
    for L in range(1, 101):
        table.append(int(round(1000 + K * ((L - 1) ** power))))
    
    diff = 1000000 - sum(table)
    
    idx = 99
    while diff != 0:
        if diff > 0:
            table[idx] += 1
            diff -= 1
        else:
            table[idx] -= 1
            diff += 1
        idx -= 1
        if idx < 0:
            idx = 99
            
    return table

table = generate_exp_table(2.5)

# Convert to Dart code
dart_list = ", ".join(map(str, table))
new_logic = f"""  // 매 레벨별 세분화 기하급수적 성장 알고리즘 (총합 1,000,000)
  static const List<int> _expTable = [
    {dart_list}
  ];

  int getRequiredExpForLevel(int level) {{
    if (level >= 100 || level < 1) return 0; // 만렙
    return _expTable[level - 1];
  }}"""

file_path = "lib/services/economy_service.dart"
with open(file_path, "r", encoding="utf-8") as f:
    content = f.read()

# Replace the block
old_logic = """  // 경험치 성장 알고리즘 (기획안 B)
  // 1레벨부터 100레벨까지 누적 경험치 1,000,000 도달
  int getRequiredExpForLevel(int level) {
    if (level >= 100) return 0; // 만렙
    return 2 * level * level + 64 * level + 1;
  }"""

if old_logic in content:
    content = content.replace(old_logic, new_logic)
    with open(file_path, "w", encoding="utf-8") as f:
        f.write(content)
    print("Replaced successfully")
else:
    print("Old logic not found!")
