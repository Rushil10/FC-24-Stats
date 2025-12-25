
import csv

def compare_csvs(file1, file2):
    with open(file1, 'r', encoding='utf-8') as f1, open(file2, 'r', encoding='utf-8') as f2:
        h1 = next(csv.reader(f1))
        h2 = next(csv.reader(f2))
        
        print(f"FC 24 Columns: {len(h1)}")
        print(f"FIFA 23 Columns: {len(h2)}")
        print("-" * 40)
        
        max_len = max(len(h1), len(h2))
        for i in range(max_len):
            col1 = h1[i] if i < len(h1) else "[MISSING]"
            col2 = h2[i] if i < len(h2) else "[MISSING]"
            if col1 != col2:
                print(f"{i}: FC24='{col1}' | FIFA23='{col2}'")

if __name__ == "__main__":
    compare_csvs('assets/images/players_24.csv', 'assets/images/players_23.csv')
