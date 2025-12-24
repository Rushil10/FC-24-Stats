import 'package:fc_stats_24/db/Player.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class PlayersDatabase {
  static final PlayersDatabase instance = PlayersDatabase._init();

  static Database? _database;

  PlayersDatabase._init();

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    _database = await _initDB('players22.db');
    return _database!;
  }

  Future deleteDB() async {
    try {
      // Close existing connection first
      if (_database != null) {
        try {
          await _database!.close();
        } catch (e) {}
        _database = null;
      }

      final dbPath = await getDatabasesPath();
      final path = join(dbPath, 'players22.db');

      if (await databaseExists(path)) {
        await deleteDatabase(path);
      } else {}
    } catch (e, stackTrace) {
      rethrow;
    }
  }

  Future<Database> _initDB(String filePath) async {
    try {
      final dbPath = await getDatabasesPath();
      final path = join(dbPath, filePath);

      // Add a timeout to the open operation
      final db = await openDatabase(
        path,
        version: 3,
        onCreate: _createDB,
        onUpgrade: (db, oldVersion, newVersion) async {
          if (oldVersion < 3) {
            await db.execute("DROP TABLE IF EXISTS players");
            await _createDB(db, newVersion);
          }
        },
      ).timeout(const Duration(seconds: 10), onTimeout: () {
        throw Exception('openDatabase timeout');
      });

      return db;
    } catch (e, stackTrace) {
      // If there's an error, try to delete corrupted database
      try {
        final dbPath = await getDatabasesPath();
        final path = join(dbPath, filePath);
        // Don't use databaseExists check here, just try to delete
        await deleteDatabase(path);
      } catch (deleteError) {}

      rethrow;
    }
  }

  Future<void> dropTable() async {
    final db = await instance.database;
    await db.execute('DROP TABLE IF EXISTS players');
  }

  void checkIfDBCreated() async {
    var created = await PlayersDatabase.instance.database;
  }

  Future<bool> checkDbExists() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'players22.db');
    return await databaseExists(path);
  }

  Future<void> readDb() async {
    final db = await instance.database;
    List<Map> li = await db.query('players');
  }

  Future getNumberOfRows() async {
    try {
      final db = await instance.database.timeout(
        Duration(seconds: 5),
        onTimeout: () {
          throw Exception('Database connection timeout');
        },
      );

      // Use COUNT(*) instead of SELECT id - much faster!
      final result =
          await db.rawQuery('SELECT COUNT(*) as count FROM players').timeout(
        Duration(seconds: 5),
        onTimeout: () {
          throw Exception('Query timeout');
        },
      );
      final count = Sqflite.firstIntValue(result) ?? 0;
      return count;
    } catch (e, stackTrace) {
      rethrow;
    }
  }

  Future top100Players() async {
    final db = await instance.database;
    List<Map> li = await db.rawQuery(
        'SELECT id,sofifa_id,player_url,player_positions,short_name,potential,age,overall,club_name,player_face_url FROM players LIMIT 500');
    return li;
  }

  Future getPlayerDetails(var id) async {
    final db = await instance.database;
    List<Map> li = await db.rawQuery('''
    SELECT * FROM players WHERE id=$id;
    ''');
    return li;
  }

  Future searchPlayers(var st) async {
    final db = await instance.database;
    List<Map> li = await db.rawQuery('''
    SELECT * FROM players WHERE long_name like '%$st%' limit 50;
    ''');
    return li;
  }

  Future<bool> checkFav(var id) async {
    final db = await instance.database;
    List<Map> li = await db.rawQuery('''
    SELECT * FROM favourites Where playerId=$id;
    ''');
    return li.isNotEmpty;
  }

  Future getFavourites() async {
    final db = await instance.database;
    List<Map> li = await db.rawQuery('''
    SELECT * FROM players JOIN favourites Where players.id=favourites.playerId
    ''');
    return li;
  }

  Future getFreeAgents() async {
    final db = await instance.database;
    List<Map> li = await db.rawQuery('''
    SELECT * FROM players where club_name ="" or club_name is null
    ''');
    return li;
  }

  Future getYoungPlayers() async {
    final db = await instance.database;
    List<Map> li = await db.rawQuery('''
    SELECT * FROM players Where age<22 limit 100
    ''');
    return li;
  }

  Future searchFavourites(var id) async {
    final db = await instance.database;
    List<Map> li = await db.rawQuery('''
    SELECT * FROM favourites Where playerId=$id;
    ''');
    if (li.isNotEmpty) {
      await db.execute('''
      DELETE FROM favourites Where playerId=$id
      ''');
    } else {
      Map<String, dynamic> fav = {
        'playerId': id,
      };
      await db.insert("favourites", fav);
    }
  }

  Future _createDB(Database db, int version) async {
    try {
      await db.execute('''
CREATE TABLE players (
        id INTEGER PRIMARY KEY,
        sofifa_id DECIMAL NOT NULL,
        player_url VARCHAR NOT NULL,
        short_name VARCHAR NOT NULL,
        long_name VARCHAR NOT NULL,
        player_positions VARCHAR NOT NULL,
        overall DECIMAL NOT NULL,
        potential DECIMAL NOT NULL,
        value_eur DECIMAL,
        wage_eur DECIMAL,
        age DECIMAL NOT NULL,
        dob DATE NOT NULL,
        height_cm DECIMAL NOT NULL,
        weight_kg DECIMAL NOT NULL,
        club_team_id DECIMAL,
        club_name VARCHAR,
        league_name VARCHAR,
        league_level DECIMAL,
        club_position VARCHAR,
        club_jersey_number DECIMAL,
        club_loaned_from VARCHAR,
        club_joined DATE,
        club_contract_valid_until DECIMAL,
        nationality_id DECIMAL,
        nationality_name VARCHAR,
        nation_team_id DECIMAL,
        nation_position VARCHAR,
        nation_jersey_number DECIMAL,
        preferred_foot VARCHAR,
        weak_foot DECIMAL,
        skill_moves DECIMAL,
        international_reputation DECIMAL,
        work_rate VARCHAR,
        body_type VARCHAR,
        real_face BOOLEAN,
        release_clause_eur DECIMAL,
        player_tags VARCHAR,
        player_traits VARCHAR,
        pace DECIMAL,
        shooting DECIMAL,
        passing DECIMAL,
        dribbling DECIMAL,
        defending DECIMAL,
        physic DECIMAL,
        attacking_crossing DECIMAL,
        attacking_finishing DECIMAL,
        attacking_heading_accuracy DECIMAL,
        attacking_short_passing DECIMAL,
        attacking_volleys DECIMAL,
        skill_dribbling DECIMAL,
        skill_curve DECIMAL,
        skill_fk_accuracy DECIMAL,
        skill_long_passing DECIMAL,
        skill_ball_control DECIMAL,
        movement_acceleration DECIMAL,
        movement_sprint_speed DECIMAL,
        movement_agility DECIMAL,
        movement_reactions DECIMAL,
        movement_balance DECIMAL,
        power_shot_power DECIMAL,
        power_jumping DECIMAL,
        power_stamina DECIMAL,
        power_strength DECIMAL,
        power_long_shots DECIMAL,
        mentality_aggression DECIMAL,
        mentality_interceptions DECIMAL,
        mentality_positioning DECIMAL,
        mentality_vision DECIMAL,
        mentality_penalties DECIMAL,
        mentality_composure DECIMAL,
        defending_marking_awareness DECIMAL,
        defending_standing_tackle DECIMAL,
        defending_sliding_tackle DECIMAL,
        goalkeeping_diving DECIMAL,
        goalkeeping_handling DECIMAL,
        goalkeeping_kicking DECIMAL,
        goalkeeping_positioning DECIMAL,
        goalkeeping_reflexes DECIMAL,
        goalkeeping_speed DECIMAL,
        ls VARCHAR,
        st VARCHAR,
        rs VARCHAR,
        lw VARCHAR,
        lf VARCHAR,
        cf VARCHAR,
        rf VARCHAR,
        rw VARCHAR,
        club_flag_url VARCHAR,
        player_face_url VARCHAR,
        club_logo_url VARCHAR,
        nation_logo_url VARCHAR,
        nation_flag_url VARCHAR
)
''');
      await db.execute('''
    CREATE TABLE favourites
    (fid INTEGER PRIMARY KEY,
    playerId INTEGER)
''');
    } catch (e, stackTrace) {
      rethrow;
    }
  }

  Future insertPlayer(Player player) async {
    try {
      final db = await instance.database;
      final id = await db.insert("players", player.toJson());
    } catch (e, stackTrace) {
      rethrow;
    }
  }

  Future<List<String>> getDistinctLeagues() async {
    final db = await instance.database;
    final result = await db.rawQuery(
        'SELECT DISTINCT league_name FROM players WHERE league_name IS NOT NULL AND league_name != "" ORDER BY league_name');
    return result.map((e) => e['league_name'] as String).toList();
  }

  Future<List<String>> getDistinctNationalities() async {
    final db = await instance.database;
    final result = await db.rawQuery(
        'SELECT DISTINCT nationality_name FROM players WHERE nationality_name IS NOT NULL AND nationality_name != "" ORDER BY nationality_name');
    return result.map((e) => e['nationality_name'] as String).toList();
  }

  Future<List<String>> getDistinctClubs() async {
    final db = await instance.database;
    final result = await db.rawQuery(
        'SELECT DISTINCT club_name FROM players WHERE club_name IS NOT NULL AND club_name != "" ORDER BY club_name');
    return result.map((e) => e['club_name'] as String).toList();
  }

  Future<List<String>> getDistinctTraits() async {
    final db = await instance.database;
    // player_traits is a comma separated string
    final result = await db.rawQuery(
        'SELECT DISTINCT player_traits FROM players WHERE player_traits IS NOT NULL AND player_traits != ""');

    Set<String> traits = {};
    for (var row in result) {
      String traitStr = row['player_traits'] as String;
      List<String> traitList = traitStr.split(',');
      for (var t in traitList) {
        String trimmed = t.trim();
        if (trimmed.isNotEmpty) {
          traits.add(trimmed);
        }
      }
    }
    List<String> sortedTraits = traits.toList();
    sortedTraits.sort();
    return sortedTraits;
  }

  Future<List<String>> getDistinctPositions() async {
    final db = await instance.database;
    final result = await db.rawQuery(
        'SELECT DISTINCT player_positions FROM players WHERE player_positions IS NOT NULL AND player_positions != ""');

    Set<String> positions = {};
    for (var row in result) {
      String posStr = row['player_positions'] as String;
      List<String> posList = posStr.split(',');
      for (var p in posList) {
        String trimmed = p.trim();
        if (trimmed.isNotEmpty) {
          positions.add(trimmed);
        }
      }
    }
    List<String> sortedPositions = positions.toList();
    // Logical football order is better but alphabetical is a safe start for now unless I define the order.
    // Let's use a standard priority order.
    const order = [
      'GK',
      'CB',
      'LB',
      'LWB',
      'RB',
      'RWB',
      'CDM',
      'CM',
      'LM',
      'RM',
      'CAM',
      'LW',
      'RW',
      'CF',
      'ST'
    ];
    sortedPositions.sort((a, b) {
      int idxA = order.indexOf(a);
      int idxB = order.indexOf(b);
      if (idxA != -1 && idxB != -1) return idxA.compareTo(idxB);
      if (idxA != -1) return -1;
      if (idxB != -1) return 1;
      return a.compareTo(b);
    });
    return sortedPositions;
  }

  Future<List<Map>> filterPlayers({
    String? query,
    double? minOverall,
    double? maxOverall,
    double? minPotential,
    double? maxPotential,
    double? minAge,
    double? maxAge,
    List<String>? positions,
    String? preferredFoot,
    List<String>? leagues,
    List<String>? nationalities,
    List<String>? clubs,
    List<String>? playStyles,
    double? minHeight,
    double? maxHeight,
    double? minWeight,
    double? maxWeight,
    double? minSkillMoves,
    double? maxSkillMoves,
    double? minWeakFoot,
    double? maxWeakFoot,
    double? minReputation,
    double? maxReputation,
    double? minPace,
    double? maxPace,
    double? minShooting,
    double? maxShooting,
    double? minPassing,
    double? maxPassing,
    double? minDribbling,
    double? maxDribbling,
    double? minDefending,
    double? maxDefending,
    double? minPhysic,
    double? maxPhysic,
    double? minAcceleration,
    double? maxAcceleration,
    double? minSprintSpeed,
    double? maxSprintSpeed,
    double? minPositioning,
    double? maxPositioning,
    double? minFinishing,
    double? maxFinishing,
    double? minShotPower,
    double? maxShotPower,
    double? minLongShots,
    double? maxLongShots,
    double? minVolleys,
    double? maxVolleys,
    double? minPenalties,
    double? maxPenalties,
    double? minVision,
    double? maxVision,
    double? minCrossing,
    double? maxCrossing,
    double? minFkAccuracy,
    double? maxFkAccuracy,
    double? minShortPassing,
    double? maxShortPassing,
    double? minLongPassing,
    double? maxLongPassing,
    double? minCurve,
    double? maxCurve,
    double? minAgility,
    double? maxAgility,
    double? minBalance,
    double? maxBalance,
    double? minReactions,
    double? maxReactions,
    double? minBallControl,
    double? maxBallControl,
    double? minDribblingSkill,
    double? maxDribblingSkill,
    double? minComposure,
    double? maxComposure,
    double? minInterceptions,
    double? maxInterceptions,
    double? minHeadingAccuracy,
    double? maxHeadingAccuracy,
    double? minMarking,
    double? maxMarking,
    double? minStandingTackle,
    double? maxStandingTackle,
    double? minSlidingTackle,
    double? maxSlidingTackle,
    double? minJumping,
    double? maxJumping,
    double? minStamina,
    double? maxStamina,
    double? minStrength,
    double? maxStrength,
    double? minAggression,
    double? maxAggression,
    double? minGkDiving,
    double? maxGkDiving,
    double? minGkHandling,
    double? maxGkHandling,
    double? minGkKicking,
    double? maxGkKicking,
    double? minGkReflexes,
    double? maxGkReflexes,
    double? minGkSpeed,
    double? maxGkSpeed,
    double? minGkPositioning,
    double? maxGkPositioning,
  }) async {
    final db = await instance.database;
    String whereClause = '1=1';
    List<dynamic> args = [];

    if (query != null && query.isNotEmpty) {
      whereClause += " AND (long_name LIKE ? OR short_name LIKE ?)";
      args.add('%$query%');
      args.add('%$query%');
    }
    if (minOverall != null) {
      whereClause += " AND overall >= ?";
      args.add(minOverall);
    }
    if (maxOverall != null) {
      whereClause += " AND overall <= ?";
      args.add(maxOverall);
    }
    if (minPotential != null) {
      whereClause += " AND potential >= ?";
      args.add(minPotential);
    }
    if (maxPotential != null) {
      whereClause += " AND potential <= ?";
      args.add(maxPotential);
    }
    if (minAge != null) {
      whereClause += " AND age >= ?";
      args.add(minAge);
    }
    if (maxAge != null) {
      whereClause += " AND age <= ?";
      args.add(maxAge);
    }

    if (minHeight != null && minHeight > 120) {
      whereClause += " AND height_cm >= ?";
      args.add(minHeight);
    }
    if (maxHeight != null && maxHeight < 220) {
      whereClause += " AND height_cm <= ?";
      args.add(maxHeight);
    }
    if (minWeight != null && minWeight > 40) {
      whereClause += " AND weight_kg >= ?";
      args.add(minWeight);
    }
    if (maxWeight != null && maxWeight < 110) {
      whereClause += " AND weight_kg <= ?";
      args.add(maxWeight);
    }
    if (minSkillMoves != null && minSkillMoves > 1) {
      whereClause += " AND skill_moves >= ?";
      args.add(minSkillMoves);
    }
    if (maxSkillMoves != null && maxSkillMoves < 5) {
      whereClause += " AND skill_moves <= ?";
      args.add(maxSkillMoves);
    }
    if (minWeakFoot != null && minWeakFoot > 1) {
      whereClause += " AND weak_foot >= ?";
      args.add(minWeakFoot);
    }
    if (maxWeakFoot != null && maxWeakFoot < 5) {
      whereClause += " AND weak_foot <= ?";
      args.add(maxWeakFoot);
    }
    if (minReputation != null && minReputation > 1) {
      whereClause += " AND international_reputation >= ?";
      args.add(minReputation);
    }
    if (maxReputation != null && maxReputation < 5) {
      whereClause += " AND international_reputation <= ?";
      args.add(maxReputation);
    }

    if (minPace != null && minPace > 0) {
      whereClause += " AND pace >= ?";
      args.add(minPace);
    }
    if (maxPace != null && maxPace < 99) {
      whereClause += " AND pace <= ?";
      args.add(maxPace);
    }
    if (minShooting != null && minShooting > 0) {
      whereClause += " AND shooting >= ?";
      args.add(minShooting);
    }
    if (maxShooting != null && maxShooting < 99) {
      whereClause += " AND shooting <= ?";
      args.add(maxShooting);
    }
    if (minPassing != null && minPassing > 0) {
      whereClause += " AND passing >= ?";
      args.add(minPassing);
    }
    if (maxPassing != null && maxPassing < 99) {
      whereClause += " AND passing <= ?";
      args.add(maxPassing);
    }
    if (minDribbling != null && minDribbling > 0) {
      whereClause += " AND dribbling >= ?";
      args.add(minDribbling);
    }
    if (maxDribbling != null && maxDribbling < 99) {
      whereClause += " AND dribbling <= ?";
      args.add(maxDribbling);
    }
    if (minDefending != null && minDefending > 0) {
      whereClause += " AND defending >= ?";
      args.add(minDefending);
    }
    if (maxDefending != null && maxDefending < 99) {
      whereClause += " AND defending <= ?";
      args.add(maxDefending);
    }
    if (minPhysic != null && minPhysic > 0) {
      whereClause += " AND physic >= ?";
      args.add(minPhysic);
    }
    if (maxPhysic != null && maxPhysic < 99) {
      whereClause += " AND physic <= ?";
      args.add(maxPhysic);
    }

    // Sub-attributes PAC
    if (minAcceleration != null && minAcceleration > 0) {
      whereClause += " AND movement_acceleration >= ?";
      args.add(minAcceleration);
    }
    if (maxAcceleration != null && maxAcceleration < 99) {
      whereClause += " AND movement_acceleration <= ?";
      args.add(maxAcceleration);
    }
    if (minSprintSpeed != null && minSprintSpeed > 0) {
      whereClause += " AND movement_sprint_speed >= ?";
      args.add(minSprintSpeed);
    }
    if (maxSprintSpeed != null && maxSprintSpeed < 99) {
      whereClause += " AND movement_sprint_speed <= ?";
      args.add(maxSprintSpeed);
    }

    // SHO
    if (minPositioning != null && minPositioning > 0) {
      whereClause += " AND mentality_positioning >= ?";
      args.add(minPositioning);
    }
    if (maxPositioning != null && maxPositioning < 99) {
      whereClause += " AND mentality_positioning <= ?";
      args.add(maxPositioning);
    }
    if (minFinishing != null && minFinishing > 0) {
      whereClause += " AND attacking_finishing >= ?";
      args.add(minFinishing);
    }
    if (maxFinishing != null && maxFinishing < 99) {
      whereClause += " AND attacking_finishing <= ?";
      args.add(maxFinishing);
    }
    if (minShotPower != null && minShotPower > 0) {
      whereClause += " AND power_shot_power >= ?";
      args.add(minShotPower);
    }
    if (maxShotPower != null && maxShotPower < 99) {
      whereClause += " AND power_shot_power <= ?";
      args.add(maxShotPower);
    }
    if (minLongShots != null && minLongShots > 0) {
      whereClause += " AND power_long_shots >= ?";
      args.add(minLongShots);
    }
    if (maxLongShots != null && maxLongShots < 99) {
      whereClause += " AND power_long_shots <= ?";
      args.add(maxLongShots);
    }
    if (minVolleys != null && minVolleys > 0) {
      whereClause += " AND attacking_volleys >= ?";
      args.add(minVolleys);
    }
    if (maxVolleys != null && maxVolleys < 99) {
      whereClause += " AND attacking_volleys <= ?";
      args.add(maxVolleys);
    }
    if (minPenalties != null && minPenalties > 0) {
      whereClause += " AND mentality_penalties >= ?";
      args.add(minPenalties);
    }
    if (maxPenalties != null && maxPenalties < 99) {
      whereClause += " AND mentality_penalties <= ?";
      args.add(maxPenalties);
    }

    // PAS
    if (minVision != null && minVision > 0) {
      whereClause += " AND mentality_vision >= ?";
      args.add(minVision);
    }
    if (maxVision != null && maxVision < 99) {
      whereClause += " AND mentality_vision <= ?";
      args.add(maxVision);
    }
    if (minCrossing != null && minCrossing > 0) {
      whereClause += " AND attacking_crossing >= ?";
      args.add(minCrossing);
    }
    if (maxCrossing != null && maxCrossing < 99) {
      whereClause += " AND attacking_crossing <= ?";
      args.add(maxCrossing);
    }
    if (minFkAccuracy != null && minFkAccuracy > 0) {
      whereClause += " AND skill_fk_accuracy >= ?";
      args.add(minFkAccuracy);
    }
    if (maxFkAccuracy != null && maxFkAccuracy < 99) {
      whereClause += " AND skill_fk_accuracy <= ?";
      args.add(maxFkAccuracy);
    }
    if (minShortPassing != null && minShortPassing > 0) {
      whereClause += " AND attacking_short_passing >= ?";
      args.add(minShortPassing);
    }
    if (maxShortPassing != null && maxShortPassing < 99) {
      whereClause += " AND attacking_short_passing <= ?";
      args.add(maxShortPassing);
    }
    if (minLongPassing != null && minLongPassing > 0) {
      whereClause += " AND skill_long_passing >= ?";
      args.add(minLongPassing);
    }
    if (maxLongPassing != null && maxLongPassing < 99) {
      whereClause += " AND skill_long_passing <= ?";
      args.add(maxLongPassing);
    }
    if (minCurve != null && minCurve > 0) {
      whereClause += " AND skill_curve >= ?";
      args.add(minCurve);
    }
    if (maxCurve != null && maxCurve < 99) {
      whereClause += " AND skill_curve <= ?";
      args.add(maxCurve);
    }

    // DRI
    if (minAgility != null && minAgility > 0) {
      whereClause += " AND movement_agility >= ?";
      args.add(minAgility);
    }
    if (maxAgility != null && maxAgility < 99) {
      whereClause += " AND movement_agility <= ?";
      args.add(maxAgility);
    }
    if (minBalance != null && minBalance > 0) {
      whereClause += " AND movement_balance >= ?";
      args.add(minBalance);
    }
    if (maxBalance != null && maxBalance < 99) {
      whereClause += " AND movement_balance <= ?";
      args.add(maxBalance);
    }
    if (minReactions != null && minReactions > 0) {
      whereClause += " AND movement_reactions >= ?";
      args.add(minReactions);
    }
    if (maxReactions != null && maxReactions < 99) {
      whereClause += " AND movement_reactions <= ?";
      args.add(maxReactions);
    }
    if (minBallControl != null && minBallControl > 0) {
      whereClause += " AND skill_ball_control >= ?";
      args.add(minBallControl);
    }
    if (maxBallControl != null && maxBallControl < 99) {
      whereClause += " AND skill_ball_control <= ?";
      args.add(maxBallControl);
    }
    if (minDribblingSkill != null && minDribblingSkill > 0) {
      whereClause += " AND skill_dribbling >= ?";
      args.add(minDribblingSkill);
    }
    if (maxDribblingSkill != null && maxDribblingSkill < 99) {
      whereClause += " AND skill_dribbling <= ?";
      args.add(maxDribblingSkill);
    }
    if (minComposure != null && minComposure > 0) {
      whereClause += " AND mentality_composure >= ?";
      args.add(minComposure);
    }
    if (maxComposure != null && maxComposure < 99) {
      whereClause += " AND mentality_composure <= ?";
      args.add(maxComposure);
    }

    // DEF
    if (minInterceptions != null && minInterceptions > 0) {
      whereClause += " AND mentality_interceptions >= ?";
      args.add(minInterceptions);
    }
    if (maxInterceptions != null && maxInterceptions < 99) {
      whereClause += " AND mentality_interceptions <= ?";
      args.add(maxInterceptions);
    }
    if (minHeadingAccuracy != null && minHeadingAccuracy > 0) {
      whereClause += " AND attacking_heading_accuracy >= ?";
      args.add(minHeadingAccuracy);
    }
    if (maxHeadingAccuracy != null && maxHeadingAccuracy < 99) {
      whereClause += " AND attacking_heading_accuracy <= ?";
      args.add(maxHeadingAccuracy);
    }
    if (minMarking != null && minMarking > 0) {
      whereClause += " AND defending_marking_awareness >= ?";
      args.add(minMarking);
    }
    if (maxMarking != null && maxMarking < 99) {
      whereClause += " AND defending_marking_awareness <= ?";
      args.add(maxMarking);
    }
    if (minStandingTackle != null && minStandingTackle > 0) {
      whereClause += " AND defending_standing_tackle >= ?";
      args.add(minStandingTackle);
    }
    if (maxStandingTackle != null && maxStandingTackle < 99) {
      whereClause += " AND defending_standing_tackle <= ?";
      args.add(maxStandingTackle);
    }
    if (minSlidingTackle != null && minSlidingTackle > 0) {
      whereClause += " AND defending_sliding_tackle >= ?";
      args.add(minSlidingTackle);
    }
    if (maxSlidingTackle != null && maxSlidingTackle < 99) {
      whereClause += " AND defending_sliding_tackle <= ?";
      args.add(maxSlidingTackle);
    }
    if (minJumping != null && minJumping > 0) {
      whereClause += " AND power_jumping >= ?";
      args.add(minJumping);
    }
    if (maxJumping != null && maxJumping < 99) {
      whereClause += " AND power_jumping <= ?";
      args.add(maxJumping);
    }

    // PHY
    if (minStamina != null && minStamina > 0) {
      whereClause += " AND power_stamina >= ?";
      args.add(minStamina);
    }
    if (maxStamina != null && maxStamina < 99) {
      whereClause += " AND power_stamina <= ?";
      args.add(maxStamina);
    }
    if (minStrength != null && minStrength > 0) {
      whereClause += " AND power_strength >= ?";
      args.add(minStrength);
    }
    if (maxStrength != null && maxStrength < 99) {
      whereClause += " AND power_strength <= ?";
      args.add(maxStrength);
    }
    if (minAggression != null && minAggression > 0) {
      whereClause += " AND mentality_aggression >= ?";
      args.add(minAggression);
    }
    if (maxAggression != null && maxAggression < 99) {
      whereClause += " AND mentality_aggression <= ?";
      args.add(maxAggression);
    }

    // GK
    if (minGkDiving != null && minGkDiving > 0) {
      whereClause += " AND goalkeeping_diving >= ?";
      args.add(minGkDiving);
    }
    if (maxGkDiving != null && maxGkDiving < 99) {
      whereClause += " AND goalkeeping_diving <= ?";
      args.add(maxGkDiving);
    }
    if (minGkHandling != null && minGkHandling > 0) {
      whereClause += " AND goalkeeping_handling >= ?";
      args.add(minGkHandling);
    }
    if (maxGkHandling != null && maxGkHandling < 99) {
      whereClause += " AND goalkeeping_handling <= ?";
      args.add(maxGkHandling);
    }
    if (minGkKicking != null && minGkKicking > 0) {
      whereClause += " AND goalkeeping_kicking >= ?";
      args.add(minGkKicking);
    }
    if (maxGkKicking != null && maxGkKicking < 99) {
      whereClause += " AND goalkeeping_kicking <= ?";
      args.add(maxGkKicking);
    }
    if (minGkReflexes != null && minGkReflexes > 0) {
      whereClause += " AND goalkeeping_reflexes >= ?";
      args.add(minGkReflexes);
    }
    if (maxGkReflexes != null && maxGkReflexes < 99) {
      whereClause += " AND goalkeeping_reflexes <= ?";
      args.add(maxGkReflexes);
    }
    if (minGkSpeed != null && minGkSpeed > 0) {
      whereClause += " AND goalkeeping_speed >= ?";
      args.add(minGkSpeed);
    }
    if (maxGkSpeed != null && maxGkSpeed < 99) {
      whereClause += " AND goalkeeping_speed <= ?";
      args.add(maxGkSpeed);
    }
    if (minGkPositioning != null && minGkPositioning > 0) {
      whereClause += " AND goalkeeping_positioning >= ?";
      args.add(minGkPositioning);
    }
    if (maxGkPositioning != null && maxGkPositioning < 99) {
      whereClause += " AND goalkeeping_positioning <= ?";
      args.add(maxGkPositioning);
    }

    if (preferredFoot != null) {
      whereClause += " AND preferred_foot = ?";
      args.add(preferredFoot);
    }

    if (leagues != null && leagues.isNotEmpty) {
      String inClause = leagues.map((_) => "?").join(',');
      whereClause += " AND league_name IN ($inClause)";
      args.addAll(leagues);
    }

    if (nationalities != null && nationalities.isNotEmpty) {
      String inClause = nationalities.map((_) => "?").join(',');
      whereClause += " AND nationality_name IN ($inClause)";
      args.addAll(nationalities);
    }

    if (clubs != null && clubs.isNotEmpty) {
      String inClause = clubs.map((_) => "?").join(',');
      whereClause += " AND club_name IN ($inClause)";
      args.addAll(clubs);
    }

    if (playStyles != null && playStyles.isNotEmpty) {
      for (var trait in playStyles) {
        whereClause += " AND player_traits LIKE ?";
        args.add('%$trait%');
      }
    }

    if (positions != null && positions.isNotEmpty) {
      String posWhere =
          positions.map((_) => "player_positions LIKE ?").join(' OR ');
      whereClause += " AND ($posWhere)";
      args.addAll(positions.map((p) => '%$p%'));
    }

    final result = await db.rawQuery(
        'SELECT * FROM players WHERE $whereClause LIMIT 100', args);
    return result;
  }
}
