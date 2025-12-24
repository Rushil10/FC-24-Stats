import 'package:fc_stats_24/components/FieldPainter.dart';
import 'package:fc_stats_24/components/PlayerPosition.dart';
import 'package:fc_stats_24/db/FormationData.dart';
import 'package:fc_stats_24/db/Player.dart';
import 'package:flutter/material.dart';

class FootballField extends StatelessWidget {
  final Formation formation;
  final Map<int, Player> selectedPlayers;
  final Function(int) onPositionTap;
  final Function(int) onPlayerLongPress;

  const FootballField({
    super.key,
    required this.formation,
    required this.selectedPlayers,
    required this.onPositionTap,
    required this.onPlayerLongPress,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final height = constraints.maxHeight;

        return Container(
          width: width,
          height: height,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFF1a4d2e),
                Color(0xFF0d2818),
              ],
            ),
          ),
          child: CustomPaint(
            painter: FieldPainter(),
            child: Stack(
              children: [
                for (int i = 0; i < formation.positions.length; i++)
                  AnimatedPositioned(
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeInOut,
                    // Center the 48px circle at the exact coordinate
                    left: formation.positions[i].position.dx * width - 24,
                    top: formation.positions[i].position.dy * height - 24,
                    child: PlayerPosition(
                      player: selectedPlayers[i],
                      position: formation.positions[i].label,
                      onTap: () => onPositionTap(i),
                      onLongPress: selectedPlayers.containsKey(i)
                          ? () => onPlayerLongPress(i)
                          : null,
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
