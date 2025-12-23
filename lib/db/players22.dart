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
    String? roles,
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

    if (roles != null && roles.isNotEmpty) {
      whereClause += " AND (work_rate LIKE ? OR player_tags LIKE ?)";
      args.add('%$roles%');
      args.add('%$roles%');
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
