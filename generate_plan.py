import os

def generate_exp_table(power):
    # Base array
    raw_vals = [1000.0 + ((L - 1) ** power) for L in range(1, 101)]
    
    # We want sum(raw_vals) to be exactly 1000000 after scaling the growth part
    base_sum = 1000 * 100
    growth_sum_needed = 1000000 - base_sum
    
    raw_growth = [(L - 1) ** power for L in range(1, 101)]
    actual_raw_growth_sum = sum(raw_growth)
    
    K = growth_sum_needed / actual_raw_growth_sum
    
    table = []
    for L in range(1, 101):
        table.append(int(round(1000 + K * ((L - 1) ** power))))
    
    diff = 1000000 - sum(table)
    
    # Adjust the last elements to perfectly hit 1000000
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

table_p2 = generate_exp_table(2.0)
table_p25 = generate_exp_table(2.5)

out_file = r"C:\Users\ncia\.gemini\antigravity-ide\brain\ef8e482c-5436-4b52-8192-50a464aef959\implementation_plan.md"

with open(out_file, "w", encoding="utf-8") as f:
    f.write("# 경험치 성장 밸런싱 기획안 D (매 레벨별 세분화 + 정확히 100만)\n\n")
    f.write("말씀해주신 기획 의도에 맞춰, **1레벨업에 1000개로 시작**하여 **매 레벨(1~100)마다 요구량이 다르게 증가**하며, **최종 1~100레벨 구간 총합이 정확히 1,000,000**이 되도록 세분화한 기획안입니다.\n\n")
    
    f.write("이 방식은 계산식이 아닌 **'100레벨 경험치 배열표(Array)'**를 소스코드에 하드코딩하여 완벽한 통제력을 가집니다. 오차가 1도 발생하지 않습니다.\n\n")

    f.write("## 📈 기하급수 성장 모델 곡선 (RPG 하드코어 스타일)\n")
    f.write("후반부로 갈수록 요구량이 폭발적으로 늘어나도록 지수(Power 2.5)를 적용한 곡선입니다.\n\n")
    
    f.write("| 구간(레벨업) | 해당 1레벨업 필요 가루 수 | 특징 |\n")
    f.write("|---|---|---|\n")
    f.write(f"| **1 ➔ 2** | **{table_p25[0]:,} 개** | 시작 레벨 |\n")
    f.write(f"| **2 ➔ 3** | **{table_p25[1]:,} 개** | |\n")
    f.write(f"| **3 ➔ 4** | **{table_p25[2]:,} 개** | |\n")
    f.write(f"| **10 ➔ 11** | **{table_p25[9]:,} 개** | 10레벨대 진입 |\n")
    f.write(f"| **20 ➔ 21** | **{table_p25[19]:,} 개** | |\n")
    f.write(f"| **50 ➔ 51** | **{table_p25[49]:,} 개** | 절반 도달 |\n")
    f.write(f"| **70 ➔ 71** | **{table_p25[69]:,} 개** | 고레벨 진입 |\n")
    f.write(f"| **90 ➔ 91** | **{table_p25[89]:,} 개** | 만렙을 앞두고 급상승 |\n")
    f.write(f"| **99 ➔ 100** | **{table_p25[98]:,} 개** | 마지막 관문 |\n")
    f.write("|---|---|---|\n")
    f.write(f"| **1~100 총합** | **{sum(table_p25):,} 개** | **정확히 100만** |\n\n")
    
    f.write("---\n")
    f.write("> [!NOTE]\n")
    f.write("> **구현 방식 (배열 참조 방식)**\n")
    f.write("> `EconomyService`에 100개의 값이 들어있는 `List<int> EXP_TABLE`을 선언하고, 이를 순회하며 레벨을 계산하도록 아키텍처를 개편합니다. 이는 대부분의 상용 MMORPG가 레벨 디자인을 할 때 쓰는 방식입니다.\n\n")

    f.write("> [!IMPORTANT]\n")
    f.write("> **리뷰 요청**\n")
    f.write("> '매 레벨마다 다르게', '처음엔 1000개', '후반에 기하급수적으로', '총합 100만' 4가지 조건을 모두 달성한 궁극의 세분화 기획안입니다! 이 수치들이 마음에 드시면 승인해주세요. 바로 코드에 배열을 삽입하여 반영하겠습니다!")

print("Markdown generated")
