import csv

def get_headers(file_path):
    with open(file_path, 'r', encoding='utf-8') as f:
        reader = csv.reader(f)
        try:
            return next(reader)
        except StopIteration:
            return []

def compare_headers(gold_file, new_file):
    gold_headers = get_headers(gold_file)
    new_headers = get_headers(new_file)
    
    print(f"Gold File: {gold_file} ({len(gold_headers)} columns)")
    print(f"New File:  {new_file} ({len(new_headers)} columns)")
    print("-" * 50)
    
    # Check for exact matches and positions
    max_len = max(len(gold_headers), len(new_headers))
    differences = []
    
    for i in range(max_len):
        g = gold_headers[i] if i < len(gold_headers) else "[MISSING]"
        n = new_headers[i] if i < len(new_headers) else "[MISSING]"
        if g != n:
            differences.append((i, g, n))
            
    if not differences:
        print("Headers match perfectly!")
    else:
        print(f"Found {len(differences)} differences:")
        for i, g, n in differences:
            print(f"Index {i}: Gold='{g}' | New='{n}'")

if __name__ == "__main__":
    compare_headers('assets/images/players_24.csv', 'assets/images/FC26_20250921.csv')
