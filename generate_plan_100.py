import os

def generate_exp_table(power):
    # start at 100
    base_sum = 100 * 100
    growth_sum_needed = 1000000 - base_sum
    
    raw_growth = [(L - 1) ** power for L in range(1, 101)]
    actual_raw_growth_sum = sum(raw_growth)
    
    K = growth_sum_needed / actual_raw_growth_sum
    
    table = []
    for L in range(1, 101):
        table.append(int(round(100 + K * ((L - 1) ** power))))
    
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

table_p25 = generate_exp_table(2.5)

out_file = r"C:\Users\ncia\.gemini\antigravity-ide\brain\ef8e482c-5436-4b52-8192-50a464aef959\implementation_plan.md"

with open(out_file, "w", encoding="utf-8") as f:
    f.write("# 경험치 성장 밸런싱 기획안 E (시작 100 + 매 레벨 세분화 증가)\n\n")
    f.write("말씀해주신 수정 기획안을 바탕으로, **첫 1레벨업 비용을 100개**로 확 낮추고 **매 레벨(1~100)마다 요구량이 계속 달라지며 서서히 증가**하는 방식을 적용했습니다.\n")
    f.write("마지막 100레벨까지 모두 더했을 때 **총합은 정확히 1,000,000**이 됩니다.\n\n")
    
    f.write("## 📈 세분화된 기하급수 곡선 (첫 시작 100 기준)\n")
    f.write("초반 비용(100)이 낮아진 만큼, 후반부 진입 시 더욱 극적인 상승(기하급수 증가)을 겪게 됩니다.\n\n")
    
    f.write("| 구간(레벨업) | 해당 1레벨업 필요 가루 수 | 특징 |\n")
    f.write("|---|---|---|\n")
    f.write(f"| **1 ➔ 2** | **{table_p25[0]:,} 개** | 아주 가벼운 첫 시작 |\n")
    f.write(f"| **2 ➔ 3** | **{table_p25[1]:,} 개** | 서서히 증가 시작 |\n")
    f.write(f"| **3 ➔ 4** | **{table_p25[2]:,} 개** | |\n")
    f.write(f"| **10 ➔ 11** | **{table_p25[9]:,} 개** | 아직 초반 구간 |\n")
    f.write(f"| **20 ➔ 21** | **{table_p25[19]:,} 개** | |\n")
    f.write(f"| **50 ➔ 51** | **{table_p25[49]:,} 개** | 본격적인 중반 진입 |\n")
    f.write(f"| **70 ➔ 71** | **{table_p25[69]:,} 개** | 본격적인 성장의 벽 |\n")
    f.write(f"| **90 ➔ 91** | **{table_p25[89]:,} 개** | 만렙을 앞두고 폭발적 상승 |\n")
    f.write(f"| **99 ➔ 100** | **{table_p25[98]:,} 개** | 마지막 극한의 관문 |\n")
    f.write("|---|---|---|\n")
    f.write(f"| **1~100 총합** | **{sum(table_p25):,} 개** | **정확히 100만** |\n\n")
    
    f.write("---\n")
    f.write("> [!IMPORTANT]\n")
    f.write("> **리뷰 요청**\n")
    f.write("> '시작 100개', '10단위 고정이 아닌 매 레벨마다 상승', '총합 100만' 기준에 완벽하게 맞춘 배열표입니다. 초반은 훨씬 쉽게 레벨업하지만 후반부 비용은 그만큼 더 가파르게 상승합니다. 이 수치들이 마음에 드시면 승인해주세요! 즉시 코드를 교체하겠습니다.")

print("Markdown generated")
