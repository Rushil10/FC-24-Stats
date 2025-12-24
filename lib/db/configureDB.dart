import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'package:csv/csv.dart';
import 'package:fc_stats_24/db/Player.dart';
import 'package:fc_stats_24/db/players22.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

Future<void> readDB() async {
  await PlayersDatabase.instance.readDb();
}

Future<bool> checkDbExists() async {
  try {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'players22.db');
    final exists = await databaseExists(path);
    return exists;
  } catch (e) {
    return false;
  }
}

// Smart setup that only runs once or resumes if interrupted
Future<void> setupDatabaseIfNeeded(Function(int) progressCallback) async {
  try {
    // Check if database exists
    final exists = await checkDbExists();

    if (!exists) {
      await _performFullSetup(progressCallback);
      return;
    }

    // Try to get row count to verify database is valid
    int currentRows = 0;
    bool isCorrupted = false;

    try {
      // Add timeout to detect hanging database
      currentRows = await PlayersDatabase.instance.getNumberOfRows().timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          throw Exception('Database query timeout');
        },
      );
    } catch (e) {
      isCorrupted = true;
    }

    // If corrupted, delete and start fresh
    if (isCorrupted) {
      await PlayersDatabase.instance.deleteDB();
      await _performFullSetup(progressCallback);
      return;
    }

    // Check if setup is complete (expected ~18,000+ rows)
    if (currentRows >= 18000) {
      return;
    }

    // Setup was interrupted, resume from where we left off
    if (currentRows > 0) {
      await createListOfFields(currentRows + 1, progressCallback);
    } else {
      // Database exists but empty, start from beginning
      await createListOfFields(1, progressCallback);
    }
  } catch (e) {
    rethrow;
  }
}

// Full fresh setup
Future<void> _performFullSetup(Function(int) progressCallback) async {
  // Ensure we start with a clean slate by deleting any existing files
  await PlayersDatabase.instance.deleteDB();
  await PlayersDatabase.instance.database; // Trigger onCreate
  await createListOfFields(1, progressCallback);
}

// ... helper functions omitted for brevity in tool call, usually we'd keep them ...
// Helper function to safely parse numeric values from CSV
num? _parseNum(dynamic value) {
  if (value == null || value == '' || value == 'null') return null;
  if (value is num) return value;
  if (value is String) {
    final trimmed = value.trim();
    if (trimmed.isEmpty || trimmed == 'null') return null;
    return num.tryParse(trimmed);
  }
  return null;
}

// Helper function to safely parse string values from CSV
String? _parseString(dynamic value) {
  if (value == null || value == 'null') return null;
  if (value is String) {
    final trimmed = value.trim();
    return trimmed.isEmpty ? null : trimmed;
  }
  return value.toString();
}

Future<void> createListOfFields(int start, Function(int) f) async {
  try {
    final mydata = await rootBundle.loadString('assets/images/players_24.csv');

    // Parse CSV in a background isolate to avoid freezing the UI
    final con = await compute(_parseCsv, mydata);

    // Get database instance
    final db = await PlayersDatabase.instance.database;

    // final int batchSize = 500; // Insert 500 players at a time
    const int batchSize = 500;
    List<Player> batch = [];

    // Start from the resume point (skip header row 0)
    final startRow = start <= 0 ? 1 : start;
    final totalRows = con.length;

    // We iterate through all available rows in the CSV
    for (int i = startRow; i < totalRows; i++) {
      try {
        final row = con[i];

        // Basic validation - ensure row has enough columns
        // The CSV structure seems to have 110 columns based on previous logic
        if (row.length < 110) {
          continue;
        }

        // Map row to Player object
        final player = _mapRowToPlayer(row);
        batch.add(player);

        // When batch is full, insert all at once using a transaction
        if (batch.length >= batchSize) {
          await _insertBatch(db, batch);

          // Update UI with current row number
          f(i);

          // Give UI thread a chance to update
          await Future.delayed(const Duration(milliseconds: 10));

          batch.clear();
        }
      } catch (e) {
        continue;
      }
    }

    // Insert remaining players in batch
    if (batch.isNotEmpty) {
      await _insertBatch(db, batch);
      f(totalRows - 1);
    }

    // Verify final count
    await PlayersDatabase.instance.getNumberOfRows();
  } catch (e) {
    rethrow;
  }
}

// Extracted method to keep the main loop clean
Player _mapRowToPlayer(List<dynamic> row) {
  return Player(
    sofifaId: _parseNum(row[0]),
    playerUrl: _parseString(row[1]),
    shortName: _parseString(row[2]),
    longName: _parseString(row[3]),
    playerPositions: _parseString(row[4]),
    overall: _parseNum(row[5]),
    potential: _parseNum(row[6]),
    valueEur: _parseNum(row[7]),
    wageEur: _parseNum(row[8]),
    age: _parseNum(row[9]),
    dob: _parseString(row[10]),
    heightCm: _parseNum(row[11]),
    weightKg: _parseNum(row[12]),
    clubTeamId: _parseNum(row[13]),
    clubName: _parseString(row[14]),
    leagueName: _parseString(row[15]),
    leagueLevel: _parseNum(row[16]),
    clubPosition: _parseString(row[17]),
    clubJerseyNumber: _parseNum(row[18]),
    clubLoanedFrom: _parseString(row[19]),
    clubJoined: _parseString(row[20]),
    clubContractValidUntil: _parseNum(row[21]),
    nationalityId: _parseNum(row[22]),
    nationalityName: _parseString(row[23]),
    nationTeamId: _parseNum(row[24]),
    nationPosition: _parseString(row[25]),
    nationJerseyNumber: _parseNum(row[26]),
    preferredFoot: _parseString(row[27]),
    weakFoot: _parseNum(row[28]),
    skillMoves: _parseNum(row[29]),
    internationalReputation: _parseNum(row[30]),
    workRate: _parseString(row[31]),
    bodyType: _parseString(row[32]),
    realFace: _parseString(row[33]),
    releaseClauseEur: _parseNum(row[34]),
    playerTags: _parseString(row[35]),
    playerTraits: _parseString(row[36]),
    pace: _parseNum(row[37]),
    shooting: _parseNum(row[38]),
    passing: _parseNum(row[39]),
    dribbling: _parseNum(row[40]),
    defending: _parseNum(row[41]),
    physic: _parseNum(row[42]),
    attackingCrossing: _parseNum(row[43]),
    attackingFinishing: _parseNum(row[44]),
    attackingHeadingAccuracy: _parseNum(row[45]),
    attackingShortPassing: _parseNum(row[46]),
    attackingVolleys: _parseNum(row[47]),
    skillDribbling: _parseNum(row[48]),
    skillCurve: _parseNum(row[49]),
    skillFkAccuracy: _parseNum(row[50]),
    skillLongPassing: _parseNum(row[51]),
    skillBallControl: _parseNum(row[52]),
    movementAcceleration: _parseNum(row[53]),
    movementSprintSpeed: _parseNum(row[54]),
    movementAgility: _parseNum(row[55]),
    movementReactions: _parseNum(row[56]),
    movementBalance: _parseNum(row[57]),
    powerShotPower: _parseNum(row[58]),
    powerJumping: _parseNum(row[59]),
    powerStamina: _parseNum(row[60]),
    powerStrength: _parseNum(row[61]),
    powerLongShots: _parseNum(row[62]),
    mentalityAggression: _parseNum(row[63]),
    mentalityInterceptions: _parseNum(row[64]),
    mentalityPositioning: _parseNum(row[65]),
    mentalityVision: _parseNum(row[66]),
    mentalityPenalties: _parseNum(row[67]),
    mentalityComposure: _parseNum(row[68]),
    defendingMarkingAwareness: _parseNum(row[69]),
    defendingStandingTackle: _parseNum(row[70]),
    defendingSlidingTackle: _parseNum(row[71]),
    goalkeepingDiving: _parseNum(row[72]),
    goalkeepingHandling: _parseNum(row[73]),
    goalkeepingKicking: _parseNum(row[74]),
    goalkeepingPositioning: _parseNum(row[75]),
    goalkeepingReflexes: _parseNum(row[76]),
    goalkeepingSpeed: _parseNum(row[77]),
    ls: _parseString(row[78]),
    st: _parseString(row[79]),
    rs: _parseString(row[80]),
    lw: _parseString(row[81]),
    lf: _parseString(row[82]),
    cf: _parseString(row[83]),
    rf: _parseString(row[84]),
    rw: _parseString(row[85]),
    playerFaceUrl: _parseString(row[105]),
    clubLogoUrl: _parseString(row[106]),
    clubFlagUrl: _parseString(row[107]),
    nationLogoUrl: _parseString(row[108]),
    nationFlagUrl: _parseString(row[109]),
  );
}

// Helper function to insert a batch of players in a single transaction
Future<void> _insertBatch(Database db, List<Player> players) async {
  await db.transaction((txn) async {
    final batch = txn.batch();
    for (var player in players) {
      batch.insert('players', player.toJson());
    }
    await batch.commit(noResult: true);
  });
}

// Top-level function for compute
List<List<dynamic>> _parseCsv(String data) {
  return const CsvToListConverter().convert(data);
}
