import csv

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

def analyze_fc26(file_path):
    with open(file_path, 'r', encoding='utf-8') as f:
        reader = csv.reader(f)
        headers = next(reader)
        
    print(f"FC 26 Headers ({len(headers)}):")
    print(headers)
    print("\n" + "="*50)
    
    mapping = {}
    missing = []
    
    # Try fuzzy matching or common aliases
    aliases = {
        'sofifa_id': 'player_id',
        'club_joined': 'club_joined_date',
        'club_contract_valid_until': 'club_contract_valid_until_year'
    }
    
    for target in TARGET_COLUMNS:
        if target in headers:
            mapping[target] = target
        elif target in aliases and aliases[target] in headers:
            mapping[target] = aliases[target]
        else:
            missing.append(target)
            
    print("\nMissing Columns in FC 26:")
    for m in missing:
        print(f"  - {m}")
        
    print("\nNew Columns in FC 26 (not in TARGET):")
    target_set = set(TARGET_COLUMNS)
    for h in headers:
        if h not in mapping.values() and h not in target_set:
            print(f"  - {h}")

if __name__ == "__main__":
    analyze_fc26('assets/images/FC26_20250921.csv')
