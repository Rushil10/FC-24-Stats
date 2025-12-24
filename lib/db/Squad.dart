class Squad {
  final int? id;
  final String name;
  final String formationId;
  final String createdAt;
  final String? updatedAt;

  Squad({
    this.id,
    required this.name,
    required this.formationId,
    required this.createdAt,
    this.updatedAt,
  });

  factory Squad.fromJson(Map<String, dynamic> json) {
    return Squad(
      id: json['id'] as int?,
      name: json['name'] as String,
      formationId: json['formation_id'] as String,
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'formation_id': formationId,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}

class SquadPlayer {
  final int? id;
  final int squadId;
  final int playerId;
  final String position; // e.g., "GK", "LB", "CB1", "CB2", etc.
  final int positionIndex; // 0-10 for 11 players

  SquadPlayer({
    this.id,
    required this.squadId,
    required this.playerId,
    required this.position,
    required this.positionIndex,
  });

  factory SquadPlayer.fromJson(Map<String, dynamic> json) {
    return SquadPlayer(
      id: json['id'] as int?,
      squadId: json['squad_id'] as int,
      playerId: json['player_id'] as int,
      position: json['position'] as String,
      positionIndex: json['position_index'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'squad_id': squadId,
      'player_id': playerId,
      'position': position,
      'position_index': positionIndex,
    };
  }
}
