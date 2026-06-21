import os

def generate_strict_table_mod10(power):
    raw_sum = sum(i**power for i in range(100))
    K = 100000.0 / raw_sum
    
    table = [10]
    for i in range(1, 100):
        val = int(round(10 + K * (i ** power)))
        if val <= table[-1]:
            val = table[-1] + 1
        table.append(val)
        
    diff = 100000 - sum(table)
    
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
            
    return [x * 10 for x in table]

table_p25 = generate_strict_table_mod10(2.5)

out_file = r"C:\Users\ncia\.gemini\antigravity-ide\brain\ef8e482c-5436-4b52-8192-50a464aef959\implementation_plan.md"

with open(out_file, "w", encoding="utf-8") as f:
    f.write("# 경험치 성장 밸런싱 기획안 G (10단위 딱 떨어짐 + 무중복 + 총합 100만)\n\n")
    f.write("말씀하신 피드백을 완벽하게 적용했습니다!\n")
    f.write("가루 주입 시스템이 10개씩 소모되므로, **모든 레벨업 요구량의 끝자리가 무조건 '0' (10개 단위)으로 딱 떨어지도록** 재설계했습니다.\n")
    f.write("이렇게 하면 레벨업 시 자투리(1~9개)가 전혀 발생하지 않고 10개 단위 클릭만으로 아주 깔끔하게 100%가 채워집니다.\n\n")
    
    f.write("## 📈 10단위 강제 조정 & 무중복 기하급수 곡선\n")
    f.write("이전 기획안처럼 100가지 숫자가 **단 한 번도 중복되지 않고 무조건 계속 증가**하며, **동시에 끝자리는 무조건 0**으로 끝납니다.\n\n")
    
    f.write("| 구간(레벨업) | 해당 1레벨업 필요 가루 수 | 특징 |\n")
    f.write("|---|---|---|\n")
    f.write(f"| **1 ➔ 2** | **{table_p25[0]:,} 개** | 시작 레벨 |\n")
    f.write(f"| **2 ➔ 3** | **{table_p25[1]:,} 개** | 딱 10개 상승 |\n")
    f.write(f"| **3 ➔ 4** | **{table_p25[2]:,} 개** | |\n")
    f.write(f"| **4 ➔ 5** | **{table_p25[3]:,} 개** | |\n")
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
    f.write("> теперь: '끝자리 무조건 0 (10의 배수)', '100가지 모두 다른 개수 (중복 0%)', '총합 정확히 100만' 기준에 완벽하게 일치합니다.\n")
    f.write("> 10개씩 넣었을 때 자투리 없이 아주 깔끔하게 바가 꽉 차게 될 것입니다. 이 기획안이 마음에 드시면 승인해주세요!")

print("Markdown generated")
