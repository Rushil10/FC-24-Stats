import csv
import argparse
import os

# Exactly 110 columns in the exact order the Flutter app mapping expects (configureDB.dart)
TARGET_COLUMNS = [
    'sofifa_id', 'player_url', 'short_name', 'long_name', 'player_positions', 
    'overall', 'potential', 'value_eur', 'wage_eur', 'age', 'dob', 'height_cm', 
    'weight_kg', 'club_team_id', 'club_name', 'league_name', 'league_level', 
    'club_position', 'club_jersey_number', 'club_loaned_from', 'club_joined', 
    'club_contract_valid_until', 'nationality_id', 'nationality_name', 
    'nation_team_id', 'nation_position', 'nation_jersey_number', 'preferred_foot', 
    'weak_foot', 'skill_moves', 'international_reputation', 'work_rate', 'body_type', 
    'real_face', 'release_clause_eur', 'player_tags', 'player_traits', 'pace', 
    'shooting', 'passing', 'dribbling', 'defending', 'physic', 'attacking_crossing', 
    'attacking_finishing', 'attacking_heading_accuracy', 'attacking_short_passing', 
    'attacking_volleys', 'skill_dribbling', 'skill_curve', 'skill_fk_accuracy', 
    'skill_long_passing', 'skill_ball_control', 'movement_acceleration', 
    'movement_sprint_speed', 'movement_agility', 'movement_reactions', 
    'movement_balance', 'power_shot_power', 'power_jumping', 'power_stamina', 
    'power_strength', 'power_long_shots', 'mentality_aggression', 
    'mentality_interceptions', 'mentality_positioning', 'mentality_vision', 
    'mentality_penalties', 'mentality_composure', 'defending_marking_awareness', 
    'defending_standing_tackle', 'defending_sliding_tackle', 'goalkeeping_diving', 
    'goalkeeping_handling', 'goalkeeping_kicking', 'goalkeeping_positioning', 
    'goalkeeping_reflexes', 'goalkeeping_speed', 'ls', 'st', 'rs', 'lw', 'lf', 'cf', 
    'rf', 'rw', 'lam', 'cam', 'ram', 'lm', 'lcm', 'cm', 'rcm', 'rm', 'lwb', 'ldm', 
    'cdm', 'rdm', 'rwb', 'lb', 'lcb', 'cb', 'rcb', 'rb', 'gk', 'player_face_url', 
    'club_logo_url', 'club_flag_url', 'nation_logo_url', 'nation_flag_url'
]

# Manual overrides for specific source formats
MAPPINGS = {
    'fifa23': {
        'club_joined_date': 'club_joined',
        'club_contract_valid_until_year': 'club_contract_valid_until',
        'player_positions': 'player_pos', # FIFA 23 used 'player_pos' in some versions
    },
    'fc26': {
        'player_id': 'sofifa_id',
        'club_joined_date': 'club_joined',
        'club_contract_valid_until_year': 'club_contract_valid_until',
    }
}

def load_reference_assets(ref_path):
    club_assets = {} # club_name -> (logo, flag)
    nation_assets = {} # nation_name -> (logo, flag)
    
    if not ref_path or not os.path.exists(ref_path):
        return club_assets, nation_assets

    with open(ref_path, 'r', encoding='utf-8') as f:
        reader = csv.DictReader(f)
        for row in reader:
            club = row.get('club_name')
            if club and club not in club_assets:
                logo = row.get('club_logo_url')
                flag = row.get('club_flag_url')
                if logo or flag:
                    club_assets[club] = (logo, flag)
            
            nation = row.get('nationality_name')
            if nation and nation not in nation_assets:
                logo = row.get('nation_logo_url')
                flag = row.get('nation_flag_url')
                if logo or flag:
                    nation_assets[nation] = (logo, flag)
                    
    return club_assets, nation_assets

def normalize_csv(input_path, output_path, source_type=None, reference_path=None):
    if not os.path.exists(input_path):
        print(f"Error: Input file {input_path} not found.")
        return

    # Load fallbacks if reference provided
    club_map, nation_map = load_reference_assets(reference_path)
    if reference_path:
        print(f"Loaded asset fallbacks from {reference_path}")

    with open(input_path, 'r', encoding='utf-8') as f:
        # Detect if we need to apply specific mappings
        line = f.readline()
        f.seek(0)
        
        mapping = MAPPINGS.get(source_type, {})
        
        # Automatic detection for common shifts if not specified
        if not source_type:
            if 'player_id' in line and 'sofifa_id' not in line:
                mapping.update(MAPPINGS['fc26'])

        reader = csv.DictReader(f)
        output_rows = []
        for row in reader:
            normalized_row = {}
            for target_col in TARGET_COLUMNS:
                # 1. Check if we have a direct match or mapped match
                source_key = None
                if target_col in row:
                    source_key = target_col
                else:
                    # Check mapping
                    for src, target in mapping.items():
                        if target == target_col and src in row:
                            source_key = src
                            break
                
                val = row[source_key] if source_key else ""
                
                # 2. Apply Asset Fallbacks if value is empty/null
                if not val or val.lower() == 'null':
                    if target_col in ['club_logo_url', 'club_flag_url']:
                        club_name = row.get('club_name') or row.get(mapping.get('club_name'))
                        if club_name in club_map:
                            val = club_map[club_name][0] if target_col == 'club_logo_url' else club_map[club_name][1]
                    
                    elif target_col in ['nation_logo_url', 'nation_flag_url']:
                        nation_name = row.get('nationality_name') or row.get(mapping.get('nationality_name'))
                        if nation_name in nation_map:
                            val = nation_map[nation_name][0] if target_col == 'nation_logo_url' else nation_map[nation_name][1]

                normalized_row[target_col] = val
            
            output_rows.append(normalized_row)

    # Ensure output directory exists
    os.makedirs(os.path.dirname(output_path), exist_ok=True)

    with open(output_path, 'w', encoding='utf-8', newline='') as f:
        writer = csv.DictWriter(f, fieldnames=TARGET_COLUMNS)
        writer.writeheader()
        writer.writerows(output_rows)

    print(f"Successfully normalized {input_path}")
    print(f"Output saved to: {output_path}")
    print(f"Final Column count: {len(TARGET_COLUMNS)}")

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Normalize Player Stats CSVs to FC 24 standard.")
    parser.add_argument("--input", required=True, help="Path to source CSV")
    parser.add_argument("--output", required=True, help="Path to save normalized CSV")
    parser.add_argument("--type", help="Source type for custom mappings (e.g. 'fifa23', 'fc26')")
    parser.add_argument("--reference", help="Optional reference CSV for asset fallbacks (e.g. players_24.csv)")
    
    args = parser.parse_args()
    normalize_csv(args.input, args.output, args.type, args.reference)
