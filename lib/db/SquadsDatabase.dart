import 'package:fc_stats_24/config_ads.dart';
import 'package:fc_stats_24/db/Squad.dart';
import 'package:fc_stats_24/db/Player.dart';
import 'package:fc_stats_24/db/players22.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class SquadsDatabase {
  static final SquadsDatabase instance = SquadsDatabase._init();
  static Database? _database;

  SquadsDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('squads$appYear.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE squads (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        formation_id TEXT NOT NULL,
        created_at TEXT NOT NULL,
        updated_at TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE squad_players (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        squad_id INTEGER NOT NULL,
        player_id INTEGER NOT NULL,
        position TEXT NOT NULL,
        position_index INTEGER NOT NULL,
        FOREIGN KEY (squad_id) REFERENCES squads (id) ON DELETE CASCADE
      )
    ''');
  }

  // Squad CRUD operations
  Future<int> createSquad(Squad squad) async {
    final db = await database;
    return await db.insert('squads', squad.toJson());
  }

  Future<List<Squad>> getAllSquads() async {
    final db = await database;
    final result = await db.query(
      'squads',
      orderBy: 'created_at DESC',
    );
    return result.map((json) => Squad.fromJson(json)).toList();
  }

  Future<Squad?> getSquad(int id) async {
    final db = await database;
    final result = await db.query(
      'squads',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (result.isEmpty) return null;
    return Squad.fromJson(result.first);
  }

  Future<int> updateSquad(Squad squad) async {
    final db = await database;
    return await db.update(
      'squads',
      squad.toJson(),
      where: 'id = ?',
      whereArgs: [squad.id],
    );
  }

  Future<int> deleteSquad(int id) async {
    final db = await database;
    // Delete squad players first (cascade)
    await db.delete(
      'squad_players',
      where: 'squad_id = ?',
      whereArgs: [id],
    );
    // Delete squad
    return await db.delete(
      'squads',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Squad Players CRUD operations
  Future<int> addPlayerToSquad(SquadPlayer squadPlayer) async {
    final db = await database;
    return await db.insert('squad_players', squadPlayer.toJson());
  }

  Future<List<SquadPlayer>> getSquadPlayers(int squadId) async {
    final db = await database;
    final result = await db.query(
      'squad_players',
      where: 'squad_id = ?',
      whereArgs: [squadId],
      orderBy: 'position_index ASC',
    );
    return result.map((json) => SquadPlayer.fromJson(json)).toList();
  }

  Future<int> updateSquadPlayer(SquadPlayer squadPlayer) async {
    final db = await database;
    return await db.update(
      'squad_players',
      squadPlayer.toJson(),
      where: 'id = ?',
      whereArgs: [squadPlayer.id],
    );
  }

  Future<int> deleteSquadPlayer(int id) async {
    final db = await database;
    return await db.delete(
      'squad_players',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> deleteAllSquadPlayers(int squadId) async {
    final db = await database;
    return await db.delete(
      'squad_players',
      where: 'squad_id = ?',
      whereArgs: [squadId],
    );
  }

  // Get player details for a squad
  Future<Map<int, Player>> getSquadPlayersWithDetails(int squadId) async {
    // Get squad players
    final squadPlayers = await getSquadPlayers(squadId);

    // Get player IDs
    final playerIds = squadPlayers.map((sp) => sp.playerId).toList();

    if (playerIds.isEmpty) return {};

    // Query players from the players database
    final playersDb = await PlayersDatabase.instance.database;

    final placeholders = List.filled(playerIds.length, '?').join(',');
    final result = await playersDb.query(
      'players',
      where: 'id IN ($placeholders)',
      whereArgs: playerIds,
    );

    // Map position index to player
    final Map<int, Player> playersMap = {};
    for (var squadPlayer in squadPlayers) {
      final playerJson = result.firstWhere(
        (p) => p['id'] == squadPlayer.playerId,
        orElse: () => {},
      );
      if (playerJson.isNotEmpty) {
        playersMap[squadPlayer.positionIndex] = Player.fromJson(playerJson);
      }
    }

    return playersMap;
  }

  Future<void> close() async {
    final db = await database;
    await db.close();
  }
}
