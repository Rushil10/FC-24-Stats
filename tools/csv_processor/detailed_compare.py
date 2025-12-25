import csv

h24 = next(csv.reader(open('assets/images/players_24.csv', 'r', encoding='utf-8')))
h26 = next(csv.reader(open('assets/images/FC26_20250921.csv', 'r', encoding='utf-8')))

print(f"{'Index':<6} | {'FC 24 Header':<30} | {'FC 26 Header':<30}")
print("-" * 75)
for i in range(110):
    if h24[i] != h26[i]:
        print(f"{i:<6} | {h24[i]:<30} | {h26[i]:<30}")
