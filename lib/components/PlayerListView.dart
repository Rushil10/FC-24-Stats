import 'package:fc_stats_24/components/playerCard.dart';
import 'package:fc_stats_24/db/Player.dart';
import 'package:fc_stats_24/theme.dart';
import 'package:flutter/material.dart';

/// A reusable player list widget with loading and empty states
class PlayerListView extends StatelessWidget {
  final List<Player> players;
  final bool isLoading;
  final String emptyMessage;
  final Function(Player) onPlayerTap;

  const PlayerListView({
    super.key,
    required this.players,
    required this.isLoading,
    required this.onPlayerTap,
    this.emptyMessage = 'No players found',
  });

  @override
  Widget build(BuildContext context) {
    final appColors = Theme.of(context).extension<AppColors>()!;

    if (isLoading) {
      return Center(
        child: CircularProgressIndicator(color: appColors.posColor),
      );
    }

    if (players.isEmpty) {
      return Center(
        child: Text(
          emptyMessage,
          style: const TextStyle(color: Colors.grey, fontSize: 16),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: players.length,
      itemBuilder: (context, index) {
        final player = players[index];
        return PlayerCard(
          playerData: player,
          onTap: () => onPlayerTap(player),
        );
      },
    );
  }
}
