import 'package:fc_stats_24/db/Squad.dart';
import 'package:fc_stats_24/db/SquadsDatabase.dart';
import 'package:fc_stats_24/db/FormationData.dart';
import 'package:fc_stats_24/screens/SquadBuilderScreen.dart';
import 'package:fc_stats_24/theme.dart';
import 'package:flutter/material.dart';

class SquadsScreen extends StatefulWidget {
  const SquadsScreen({super.key});

  @override
  State<SquadsScreen> createState() => _SquadsScreenState();
}

class _SquadsScreenState extends State<SquadsScreen> {
  List<Squad> _squads = [];
  Map<int, Map<String, dynamic>> _squadStats = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSquads();
  }

  Future<void> _loadSquads() async {
    setState(() => _isLoading = true);
    try {
      final squads = await SquadsDatabase.instance.getAllSquads();

      // Load stats for each squad
      final Map<int, Map<String, dynamic>> stats = {};
      for (var squad in squads) {
        stats[squad.id!] = await _calculateSquadStats(squad.id!);
      }

      setState(() {
        _squads = squads;
        _squadStats = stats;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading squads: $e')),
        );
      }
    }
  }

  Future<Map<String, dynamic>> _calculateSquadStats(int squadId) async {
    final players =
        await SquadsDatabase.instance.getSquadPlayersWithDetails(squadId);

    if (players.isEmpty) {
      return {
        'avgOverall': 0,
        'avgPotential': 0,
        'totalValue': 0.0,
        'totalWage': 0.0,
      };
    }

    double totalOverall = 0;
    double totalPotential = 0;
    double totalValue = 0;
    double totalWage = 0;

    for (var player in players.values) {
      totalOverall += (player.overall ?? 0).toDouble();
      totalPotential += (player.potential ?? 0).toDouble();
      totalValue += (player.valueEur ?? 0).toDouble();
      totalWage += (player.wageEur ?? 0).toDouble();
    }

    final count = players.length;

    return {
      'avgOverall': (totalOverall / count).round(),
      'avgPotential': (totalPotential / count).round(),
      'totalValue': totalValue,
      'totalWage': totalWage,
    };
  }

  String _formatCurrency(double value) {
    if (value >= 1000000) {
      return '€${(value / 1000000).toStringAsFixed(1)}M';
    } else if (value >= 1000) {
      return '€${(value / 1000).toStringAsFixed(0)}K';
    }
    return '€${value.toStringAsFixed(0)}';
  }

  Future<void> _deleteSquad(int squadId) async {
    try {
      await SquadsDatabase.instance.deleteSquad(squadId);
      _loadSquads();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Squad deleted successfully')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error deleting squad: $e')),
        );
      }
    }
  }

  void _confirmDelete(Squad squad) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).colorScheme.surface,
        title:
            const Text('Delete Squad', style: TextStyle(color: Colors.white)),
        content: Text(
          'Are you sure you want to delete "${squad.name}"?',
          style: const TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _deleteSquad(squad.id!);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _navigateToBuilder({Squad? squad}) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SquadBuilderScreen(squad: squad),
      ),
    );
    if (result == true) {
      _loadSquads();
    }
  }

  @override
  Widget build(BuildContext context) {
    final appColors = Theme.of(context).extension<AppColors>()!;
    final scaffoldColor = Theme.of(context).scaffoldBackgroundColor;

    return Scaffold(
      backgroundColor: scaffoldColor,
      appBar: AppBar(
        title: const Text(
          'My Squads',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(color: appColors.posColor),
            )
          : _squads.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.sports_soccer,
                        size: 80,
                        color: Colors.grey[700],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No squads yet',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Tap the + button to create your first squad',
                        style: TextStyle(
                          color: Colors.grey[700],
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _squads.length,
                  itemBuilder: (context, index) {
                    final squad = _squads[index];
                    final formation =
                        FormationData.getFormation(squad.formationId);
                    final stats = _squadStats[squad.id] ?? {};

                    return Card(
                      color: Theme.of(context).colorScheme.surface,
                      margin: const EdgeInsets.only(bottom: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: InkWell(
                        onTap: () => _navigateToBuilder(squad: squad),
                        borderRadius: BorderRadius.circular(16),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Header row with name and delete button
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      squad.name,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete_outline,
                                        color: Colors.red),
                                    onPressed: () => _confirmDelete(squad),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              // Formation
                              Text(
                                formation.name,
                                style: TextStyle(
                                  color: appColors.posColor,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 16),
                              // Divider
                              Divider(color: Colors.grey[800], height: 1),
                              const SizedBox(height: 16),
                              // Stats row with circles and values
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  _buildStatCircle(
                                    stats['avgOverall']?.toString() ?? '0',
                                    appColors.ovrColor, // Purple
                                  ),
                                  _buildStatCircle(
                                    stats['avgPotential']?.toString() ?? '0',
                                    appColors.clubNameColor, // Cyan
                                  ),
                                  _buildStatValue(
                                    _formatCurrency(stats['totalValue'] ?? 0.0),
                                    'VALUE',
                                  ),
                                  _buildStatValue(
                                    _formatCurrency(stats['totalWage'] ?? 0.0),
                                    'WAGE',
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              // Divider
                              Divider(color: Colors.grey[800], height: 1),
                              const SizedBox(height: 12),
                              // Created date
                              Text(
                                'Created on ${_formatDate(squad.createdAt)}',
                                style: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToBuilder(),
        backgroundColor: appColors.posColor,
        child: const Icon(Icons.add, color: Colors.black),
      ),
    );
  }

  Widget _buildStatCircle(String value, Color color) {
    return Container(
      width: 55,
      height: 55,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: color, width: 2.5),
      ),
      child: Center(
        child: Text(
          value,
          style: TextStyle(
            color: color,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildStatValue(String value, String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            color: Colors.grey,
            fontSize: 10,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  String _formatDate(String dateStr) {
    try {
      final date = DateTime.parse(dateStr);
      return '${date.day}/${date.month}/${date.year}';
    } catch (e) {
      return dateStr;
    }
  }
}
