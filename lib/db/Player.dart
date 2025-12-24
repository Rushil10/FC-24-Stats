class Player {
  final int? id;
  final num? sofifaId;
  final String? playerUrl;
  final String? shortName;
  final String? longName;
  final String? playerPositions;
  final num? overall;
  final num? potential;
  final num? valueEur;
  final num? wageEur;
  final num? age;
  final String? dob;
  final num? heightCm;
  final num? weightKg;
  final num? clubTeamId;
  final String? clubName;
  final String? leagueName;
  final num? leagueLevel;
  final String? clubPosition;
  final num? clubJerseyNumber;
  final String? clubLoanedFrom;
  final String? clubJoined;
  final num? clubContractValidUntil;
  final num? nationalityId;
  final String? nationalityName;
  final num? nationTeamId;
  final String? nationPosition;
  final num? nationJerseyNumber;
  final String? preferredFoot;
  final num? weakFoot;
  final num? skillMoves;
  final num? internationalReputation;
  final String? workRate;
  final String? bodyType;
  final String? realFace;
  final num? releaseClauseEur;
  final String? playerTags;
  final String? playerTraits;
  final num? pace;
  final num? shooting;
  final num? passing;
  final num? dribbling;
  final num? defending;
  final num? physic;
  final num? attackingCrossing;
  final num? attackingFinishing;
  final num? attackingHeadingAccuracy;
  final num? attackingShortPassing;
  final num? attackingVolleys;
  final num? skillDribbling;
  final num? skillCurve;
  final num? skillFkAccuracy;
  final num? skillLongPassing;
  final num? skillBallControl;
  final num? movementAcceleration;
  final num? movementSprintSpeed;
  final num? movementAgility;
  final num? movementReactions;
  final num? movementBalance;
  final num? powerShotPower;
  final num? powerJumping;
  final num? powerStamina;
  final num? powerStrength;
  final num? powerLongShots;
  final num? mentalityAggression;
  final num? mentalityInterceptions;
  final num? mentalityPositioning;
  final num? mentalityVision;
  final num? mentalityPenalties;
  final num? mentalityComposure;
  final num? defendingMarkingAwareness;
  final num? defendingStandingTackle;
  final num? defendingSlidingTackle;
  final num? goalkeepingDiving;
  final num? goalkeepingHandling;
  final num? goalkeepingKicking;
  final num? goalkeepingPositioning;
  final num? goalkeepingReflexes;
  final num? goalkeepingSpeed;
  final String? ls;
  final String? st;
  final String? rs;
  final String? lw;
  final String? lf;
  final String? cf;
  final String? rf;
  final String? rw;
  final String? playerFaceUrl;
  final String? clubLogoUrl;
  final String? clubFlagUrl;
  final String? nationLogoUrl;
  final String? nationFlagUrl;

  Player({
    this.id,
    this.sofifaId,
    this.playerUrl,
    this.shortName,
    this.longName,
    this.playerPositions,
    this.overall,
    this.potential,
    this.valueEur,
    this.wageEur,
    this.age,
    this.dob,
    this.heightCm,
    this.weightKg,
    this.clubTeamId,
    this.clubName,
    this.leagueName,
    this.leagueLevel,
    this.clubPosition,
    this.clubJerseyNumber,
    this.clubLoanedFrom,
    this.clubJoined,
    this.clubContractValidUntil,
    this.nationalityId,
    this.nationalityName,
    this.nationTeamId,
    this.nationPosition,
    this.nationJerseyNumber,
    this.preferredFoot,
    this.weakFoot,
    this.skillMoves,
    this.internationalReputation,
    this.workRate,
    this.bodyType,
    this.realFace,
    this.releaseClauseEur,
    this.playerTags,
    this.playerTraits,
    this.pace,
    this.shooting,
    this.passing,
    this.dribbling,
    this.defending,
    this.physic,
    this.attackingCrossing,
    this.attackingFinishing,
    this.attackingHeadingAccuracy,
    this.attackingShortPassing,
    this.attackingVolleys,
    this.skillDribbling,
    this.skillCurve,
    this.skillFkAccuracy,
    this.skillLongPassing,
    this.skillBallControl,
    this.movementAcceleration,
    this.movementSprintSpeed,
    this.movementAgility,
    this.movementReactions,
    this.movementBalance,
    this.powerShotPower,
    this.powerJumping,
    this.powerStamina,
    this.powerStrength,
    this.powerLongShots,
    this.mentalityAggression,
    this.mentalityInterceptions,
    this.mentalityPositioning,
    this.mentalityVision,
    this.mentalityPenalties,
    this.mentalityComposure,
    this.defendingMarkingAwareness,
    this.defendingStandingTackle,
    this.defendingSlidingTackle,
    this.goalkeepingDiving,
    this.goalkeepingHandling,
    this.goalkeepingKicking,
    this.goalkeepingPositioning,
    this.goalkeepingReflexes,
    this.goalkeepingSpeed,
    this.ls,
    this.st,
    this.rs,
    this.lw,
    this.lf,
    this.cf,
    this.rf,
    this.rw,
    this.playerFaceUrl,
    this.clubLogoUrl,
    this.clubFlagUrl,
    this.nationLogoUrl,
    this.nationFlagUrl,
  });

  Player.fromJson(Map<String, dynamic> json)
      : id = json['id'] as int?,
        sofifaId = json['sofifa_id'] as num?,
        playerUrl = json['player_url'] as String?,
        shortName = json['short_name'] as String?,
        longName = json['long_name'] as String?,
        playerPositions = json['player_positions'] as String?,
        overall = json['overall'] as num?,
        potential = json['potential'] as num?,
        valueEur = json['value_eur'] as num?,
        wageEur = json['wage_eur'] as num?,
        age = json['age'] as num?,
        dob = json['dob'] as String?,
        heightCm = json['height_cm'] as num?,
        weightKg = json['weight_kg'] as num?,
        clubTeamId = json['club_team_id'] as num?,
        clubName = (json['club_name'] != null &&
                json['club_name'].toString().isNotEmpty)
            ? json['club_name'] as String?
            : "Free Agent",
        leagueName = json['league_name'] as String?,
        leagueLevel = json['league_level'] as num?,
        clubPosition = json['club_position'] as String?,
        clubJerseyNumber = json['club_jersey_number'] as num?,
        clubLoanedFrom = json['club_loaned_from'] as String?,
        clubJoined = json['club_joined'] as String?,
        clubContractValidUntil = json['club_contract_valid_until'] as num?,
        nationalityId = json['nationality_id'] as num?,
        nationalityName = json['nationality_name'] as String?,
        nationTeamId = json['nation_team_id'] as num?,
        nationPosition = json['nation_position'] as String?,
        nationJerseyNumber = json['nation_jersey_number'] as num?,
        preferredFoot = json['preferred_foot'] as String?,
        weakFoot = json['weak_foot'] as num?,
        skillMoves = json['skill_moves'] as num?,
        internationalReputation = json['international_reputation'] as num?,
        workRate = json['work_rate'] as String?,
        bodyType = json['body_type'] as String?,
        realFace = json['real_face']?.toString(),
        releaseClauseEur = json['release_clause_eur'] as num?,
        playerTags = json['player_tags'] as String?,
        playerTraits = json['player_traits'] as String?,
        pace = json['pace'] as num?,
        shooting = json['shooting'] as num?,
        passing = json['passing'] as num?,
        dribbling = json['dribbling'] as num?,
        defending = json['defending'] as num?,
        physic = json['physic'] as num?,
        attackingCrossing = json['attacking_crossing'] as num?,
        attackingFinishing = json['attacking_finishing'] as num?,
        attackingHeadingAccuracy = json['attacking_heading_accuracy'] as num?,
        attackingShortPassing = json['attacking_short_passing'] as num?,
        attackingVolleys = json['attacking_volleys'] as num?,
        skillDribbling = json['skill_dribbling'] as num?,
        skillCurve = json['skill_curve'] as num?,
        skillFkAccuracy = json['skill_fk_accuracy'] as num?,
        skillLongPassing = json['skill_long_passing'] as num?,
        skillBallControl = json['skill_ball_control'] as num?,
        movementAcceleration = json['movement_acceleration'] as num?,
        movementSprintSpeed = json['movement_sprint_speed'] as num?,
        movementAgility = json['movement_agility'] as num?,
        movementReactions = json['movement_reactions'] as num?,
        movementBalance = json['movement_balance'] as num?,
        powerShotPower = json['power_shot_power'] as num?,
        powerJumping = json['power_jumping'] as num?,
        powerStamina = json['power_stamina'] as num?,
        powerStrength = json['power_strength'] as num?,
        powerLongShots = json['power_long_shots'] as num?,
        mentalityAggression = json['mentality_aggression'] as num?,
        mentalityInterceptions = json['mentality_interceptions'] as num?,
        mentalityPositioning = json['mentality_positioning'] as num?,
        mentalityVision = json['mentality_vision'] as num?,
        mentalityPenalties = json['mentality_penalties'] as num?,
        mentalityComposure = json['mentality_composure'] as num?,
        defendingMarkingAwareness = json['defending_marking_awareness'] as num?,
        defendingStandingTackle = json['defending_standing_tackle'] as num?,
        defendingSlidingTackle = json['defending_sliding_tackle'] as num?,
        goalkeepingDiving = json['goalkeeping_diving'] as num?,
        goalkeepingHandling = json['goalkeeping_handling'] as num?,
        goalkeepingKicking = json['goalkeeping_kicking'] as num?,
        goalkeepingPositioning = json['goalkeeping_positioning'] as num?,
        goalkeepingReflexes = json['goalkeeping_reflexes'] as num?,
        goalkeepingSpeed = json['goalkeeping_speed'] as num?,
        ls = json['ls'] as String?,
        st = json['st'] as String?,
        rs = json['rs'] as String?,
        lw = json['lw'] as String?,
        lf = json['lf'] as String?,
        cf = json['cf'] as String?,
        rf = json['rf'] as String?,
        rw = json['rw'] as String?,
        playerFaceUrl = json['player_face_url'] as String?,
        clubLogoUrl = json['club_logo_url'] as String?,
        clubFlagUrl = json['club_flag_url'] as String?,
        nationLogoUrl = json['nation_logo_url'] as String?,
        nationFlagUrl = json['nation_flag_url'] as String?;

  Map<String, dynamic> toJson() => {
        'id': id,
        'sofifa_id': sofifaId,
        'player_url': playerUrl,
        'short_name': shortName,
        'long_name': longName,
        'player_positions': playerPositions,
        'overall': overall,
        'potential': potential,
        'value_eur': valueEur,
        'wage_eur': wageEur,
        'age': age,
        'dob': dob,
        'height_cm': heightCm,
        'weight_kg': weightKg,
        'club_team_id': clubTeamId,
        'club_name': clubName,
        'league_name': leagueName,
        'league_level': leagueLevel,
        'club_position': clubPosition,
        'club_jersey_number': clubJerseyNumber,
        'club_loaned_from': clubLoanedFrom,
        'club_joined': clubJoined,
        'club_contract_valid_until': clubContractValidUntil,
        'nationality_id': nationalityId,
        'nationality_name': nationalityName,
        'nation_team_id': nationTeamId,
        'nation_position': nationPosition,
        'nation_jersey_number': nationJerseyNumber,
        'preferred_foot': preferredFoot,
        'weak_foot': weakFoot,
        'skill_moves': skillMoves,
        'international_reputation': internationalReputation,
        'work_rate': workRate,
        'body_type': bodyType,
        'real_face': realFace,
        'release_clause_eur': releaseClauseEur,
        'player_tags': playerTags,
        'player_traits': playerTraits,
        'pace': pace,
        'shooting': shooting,
        'passing': passing,
        'dribbling': dribbling,
        'defending': defending,
        'physic': physic,
        'attacking_crossing': attackingCrossing,
        'attacking_finishing': attackingFinishing,
        'attacking_heading_accuracy': attackingHeadingAccuracy,
        'attacking_short_passing': attackingShortPassing,
        'attacking_volleys': attackingVolleys,
        'skill_dribbling': skillDribbling,
        'skill_curve': skillCurve,
        'skill_fk_accuracy': skillFkAccuracy,
        'skill_long_passing': skillLongPassing,
        'skill_ball_control': skillBallControl,
        'movement_acceleration': movementAcceleration,
        'movement_sprint_speed': movementSprintSpeed,
        'movement_agility': movementAgility,
        'movement_reactions': movementReactions,
        'movement_balance': movementBalance,
        'power_shot_power': powerShotPower,
        'power_jumping': powerJumping,
        'power_stamina': powerStamina,
        'power_strength': powerStrength,
        'power_long_shots': powerLongShots,
        'mentality_aggression': mentalityAggression,
        'mentality_interceptions': mentalityInterceptions,
        'mentality_positioning': mentalityPositioning,
        'mentality_vision': mentalityVision,
        'mentality_penalties': mentalityPenalties,
        'mentality_composure': mentalityComposure,
        'defending_marking_awareness': defendingMarkingAwareness,
        'defending_standing_tackle': defendingStandingTackle,
        'defending_sliding_tackle': defendingSlidingTackle,
        'goalkeeping_diving': goalkeepingDiving,
        'goalkeeping_handling': goalkeepingHandling,
        'goalkeeping_kicking': goalkeepingKicking,
        'goalkeeping_positioning': goalkeepingPositioning,
        'goalkeeping_reflexes': goalkeepingReflexes,
        'goalkeeping_speed': goalkeepingSpeed,
        'ls': ls,
        'st': st,
        'rs': rs,
        'lw': lw,
        'lf': lf,
        'cf': cf,
        'rf': rf,
        'rw': rw,
        'player_face_url': playerFaceUrl,
        'club_logo_url': clubLogoUrl,
        'club_flag_url': clubFlagUrl,
        'nation_logo_url': nationLogoUrl,
        'nation_flag_url': nationFlagUrl
      };

  List<String> get positionsList {
    if (playerPositions == null || playerPositions!.isEmpty) return [];
    return playerPositions!.split(',').map((e) => e.trim()).toList();
  }

  String get formattedPositions {
    return positionsList.join(' ');
  }

  List<String> get traitsList {
    if (playerTraits == null || playerTraits!.isEmpty) return [];
    return playerTraits!.split(',').map((e) => e.trim()).toList();
  }

  String get shootingWorkRate {
    if (workRate == null || !workRate!.contains('/')) return "N/A";
    return workRate!.split('/')[0].trim();
  }

  String get defensiveWorkRate {
    if (workRate == null || !workRate!.contains('/')) return "N/A";
    var parts = workRate!.split('/');
    if (parts.length < 2) return "N/A";
    return parts[1].trim();
  }
}
