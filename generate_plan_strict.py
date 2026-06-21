import os

def generate_strict_table(power):
    raw_sum = sum(i**power for i in range(100))
    K = 990000.0 / raw_sum
    
    table = [100]
    for i in range(1, 100):
        val = int(round(100 + K * (i ** power)))
        if val <= table[-1]:
            val = table[-1] + 1
        table.append(val)
        
    diff = 1000000 - sum(table)
    
    idx = 99
    while diff != 0:
        if diff > 0:
            table[idx] += 1
            diff -= 1
        else:
            if table[idx] - 1 > table[idx-1]:
                table[idx] -= 1
                diff += 1
            else:
                idx -= 1
                continue
                
        idx -= 1
        if idx < 1:
            idx = 99
            
    return table

table_p25 = generate_strict_table(2.5)

out_file = r"C:\Users\ncia\.gemini\antigravity-ide\brain\ef8e482c-5436-4b52-8192-50a464aef959\implementation_plan.md"

with open(out_file, "w", encoding="utf-8") as f:
    f.write("# 경험치 성장 밸런싱 기획안 F (중복 절대 없음 + 시작 100 + 100만)\n\n")
    f.write("말씀해주신 지적을 적극 수용하여, **초반 구간에서 똑같은 수치가 단 1번도 반복되지 않도록** 알고리즘을 강화했습니다!\n")
    f.write("**1레벨업에 딱 100개로 시작**하여, **단 한 번의 중복 없이 100번 모두 다른 숫자로** 요구량이 증가하며, **총합은 정확히 1,000,000**에 맞춰집니다.\n\n")
    
    f.write("## 📈 절대로 겹치지 않는 기하급수 곡선 (100번 모두 다름)\n")
    f.write("1~2레벨 같은 극초반에도 `100 ➔ 101 ➔ 102 ➔ 106 ➔ 111` 등 무조건 더 많은 숫자를 요구하도록 강제 조정(Strictly Increasing) 되었습니다.\n\n")
    
    f.write("| 구간(레벨업) | 해당 1레벨업 필요 가루 수 | 특징 |\n")
    f.write("|---|---|---|\n")
    f.write(f"| **1 ➔ 2** | **{table_p25[0]:,} 개** | 시작 레벨 (중복 없음) |\n")
    f.write(f"| **2 ➔ 3** | **{table_p25[1]:,} 개** | +1 증가 강제 적용 |\n")
    f.write(f"| **3 ➔ 4** | **{table_p25[2]:,} 개** | 증가폭이 점점 늘어남 |\n")
    f.write(f"| **4 ➔ 5** | **{table_p25[3]:,} 개** | 본격적인 곡선 돌입 |\n")
    f.write(f"| **10 ➔ 11** | **{table_p25[9]:,} 개** | 10레벨대 진입 |\n")
    f.write(f"| **20 ➔ 21** | **{table_p25[19]:,} 개** | |\n")
    f.write(f"| **50 ➔ 51** | **{table_p25[49]:,} 개** | 절반 도달 |\n")
    f.write(f"| **70 ➔ 71** | **{table_p25[69]:,} 개** | 고레벨 진입 |\n")
    f.write(f"| **90 ➔ 91** | **{table_p25[89]:,} 개** | 폭발적 상승 |\n")
    f.write(f"| **99 ➔ 100** | **{table_p25[98]:,} 개** | 마지막 관문 |\n")
    f.write("|---|---|---|\n")
    f.write(f"| **1~100 총합** | **{sum(table_p25):,} 개** | **정확히 100만** |\n\n")
    
    f.write("---\n")
    f.write("> [!IMPORTANT]\n")
    f.write("> **리뷰 요청**\n")
    f.write("> 이제 단 하나의 구간도 숫자가 겹치지 않고 100가지 모두 다른 개수를 요구합니다. '시작 100개', '모두 다름', '총합 100만' 기준에 완벽하게 일치합니다. 이 기획안이 마음에 드시면 승인해주세요!")

print("Markdown generated")
