import 'package:fc_stats_24/theme.dart';
import 'package:flutter/material.dart';

class SquadStatsPanel extends StatelessWidget {
  final String formationName;
  final Map<String, dynamic> stats;
  final bool showStats;
  final VoidCallback onToggle;
  final String Function(double) formatCurrency;

  const SquadStatsPanel({
    super.key,
    required this.formationName,
    required this.stats,
    required this.showStats,
    required this.onToggle,
    required this.formatCurrency,
  });

  @override
  Widget build(BuildContext context) {
    final appColors = Theme.of(context).extension<AppColors>()!;

    return Container(
      margin: const EdgeInsets.fromLTRB(12, 4, 12, 8),
      decoration: BoxDecoration(
        border: Border.all(
          color: appColors.posColor.withOpacity(0.3),
          width: 1.5,
        ),
        borderRadius: BorderRadius.circular(12),
        color: Colors.transparent,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header - Always visible
            InkWell(
              onTap: onToggle,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: appColors.surfaceColor.withOpacity(0.5),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      formationName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Icon(
                      showStats
                          ? Icons.keyboard_arrow_up
                          : Icons.keyboard_arrow_down,
                      color: appColors.posColor,
                      size: 18,
                    ),
                  ],
                ),
              ),
            ),
            // Animated Stats Content
            AnimatedSize(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOut,
              child: showStats
                  ? Container(
                      padding: const EdgeInsets.all(10),
                      decoration: const BoxDecoration(
                        color: Colors.transparent,
                      ),
                      child: Row(
                        children: [
                          // Left Column - Overall & Potential
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                _buildMiniStatCircle(
                                  'OVR',
                                  stats['avgOverall'].toString(),
                                  appColors.ovrColor,
                                ),
                                _buildMiniStatCircle(
                                  'POT',
                                  stats['avgPotential'].toString(),
                                  appColors.clubNameColor,
                                ),
                              ],
                            ),
                          ),
                          // Vertical Divider
                          Container(
                            width: 1,
                            height: 50,
                            color: Colors.grey[800],
                            margin: const EdgeInsets.symmetric(horizontal: 8),
                          ),
                          // Right Column - Value/Wage & Ages
                          Expanded(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                // Row 1: Value & Wage
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    _buildTinyStatItem(
                                      'VALUE',
                                      formatCurrency(stats['totalValue']),
                                    ),
                                    _buildTinyStatItem(
                                      'WAGE',
                                      formatCurrency(stats['totalWage']),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 6),
                                // Row 2: Ages & Players
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    _buildTinyStatItem(
                                      'AVG AGE',
                                      '${stats['avgAge']}',
                                    ),
                                    _buildTinyStatItem(
                                      'PLAYERS',
                                      '${stats['playerCount']}/11',
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                  : const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMiniStatCircle(String label, String value, Color color) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: color, width: 2),
          ),
          child: Center(
            child: Text(
              value,
              style: TextStyle(
                color: color,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            color: Colors.grey,
            fontSize: 9,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildTinyStatItem(String label, String value) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 11,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            color: Colors.grey,
            fontSize: 8,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
