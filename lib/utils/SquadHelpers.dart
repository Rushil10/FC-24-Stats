import 'package:fc_stats_24/db/Player.dart';

class SquadHelpers {
  /// Calculate squad statistics from selected players
  static Map<String, dynamic> calculateSquadStats(
      Map<int, Player> selectedPlayers) {
    if (selectedPlayers.isEmpty) {
      return {
        'avgOverall': 0,
        'avgPotential': 0,
        'totalValue': 0.0,
        'totalWage': 0.0,
        'avgAge': 0,
        'playerCount': 0,
      };
    }

    double totalOverall = 0;
    double totalPotential = 0;
    double totalValue = 0;
    double totalWage = 0;
    double totalAge = 0;

    for (var player in selectedPlayers.values) {
      totalOverall += (player.overall ?? 0).toDouble();
      totalPotential += (player.potential ?? 0).toDouble();
      totalValue += (player.valueEur ?? 0).toDouble();
      totalWage += (player.wageEur ?? 0).toDouble();
      totalAge += (player.age ?? 0).toDouble();
    }

    final count = selectedPlayers.length;

    return {
      'avgOverall': (totalOverall / count).round(),
      'avgPotential': (totalPotential / count).round(),
      'totalValue': totalValue,
      'totalWage': totalWage,
      'avgAge': (totalAge / count).round(),
      'playerCount': count,
    };
  }

  /// Format currency values for display
  static String formatCurrency(double value) {
    if (value >= 1000000) {
      return '€${(value / 1000000).toStringAsFixed(1)}M';
    } else if (value >= 1000) {
      return '€${(value / 1000).toStringAsFixed(0)}K';
    }
    return '€${value.toStringAsFixed(0)}';
  }
}
