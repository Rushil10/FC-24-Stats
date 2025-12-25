import 'package:fc_stats_24/components/StatWidgets.dart';
import 'package:fc_stats_24/db/Squad.dart';
import 'package:fc_stats_24/db/SquadsDatabase.dart';
import 'package:fc_stats_24/db/FormationData.dart';
import 'package:fc_stats_24/screens/SquadBuilderScreen.dart';
import 'package:fc_stats_24/theme.dart';
import 'package:fc_stats_24/utils/SquadHelpers.dart';
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
    return SquadHelpers.calculateSquadStats(players);
  }

  String _formatCurrency(double value) {
    return SquadHelpers.formatCurrency(value);
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

                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        color: appColors.surfaceColor.withOpacity(0.3),
                        border: Border.all(
                          color: appColors.posColor.withOpacity(0.3),
                          width: 1.5,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: InkWell(
                        onTap: () => _navigateToBuilder(squad: squad),
                        borderRadius: BorderRadius.circular(12),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
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
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete_outline,
                                        color: Colors.red, size: 20),
                                    padding: EdgeInsets.zero,
                                    constraints: const BoxConstraints(),
                                    onPressed: () => _confirmDelete(squad),
                                  ),
                                ],
                              ),
                              // Formation
                              Text(
                                formation.name,
                                style: TextStyle(
                                  color: appColors.posColor,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 10),
                              // Divider
                              Container(
                                height: 1,
                                color: appColors.posColor.withOpacity(0.2),
                              ),
                              const SizedBox(height: 10),
                              // Stats row - more compact
                              Row(
                                children: [
                                  // OVR
                                  Expanded(
                                    child: Column(
                                      children: [
                                        _buildStatCircle(
                                          stats['avgOverall']?.toString() ??
                                              '0',
                                          appColors.ovrColor,
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          'OVR',
                                          style: TextStyle(
                                            color: appColors.ovrColor,
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  // POT
                                  Expanded(
                                    child: Column(
                                      children: [
                                        _buildStatCircle(
                                          stats['avgPotential']?.toString() ??
                                              '0',
                                          appColors.clubNameColor,
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          'POT',
                                          style: TextStyle(
                                            color: appColors.clubNameColor,
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  // Vertical separator
                                  Container(
                                    width: 1,
                                    height: 50,
                                    color: appColors.posColor.withOpacity(0.2),
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 8),
                                  ),
                                  // VALUE & WAGE
                                  Expanded(
                                    flex: 2,
                                    child: Column(
                                      children: [
                                        _buildStatValue(
                                          _formatCurrency(
                                              stats['totalValue'] ?? 0.0),
                                          'VALUE',
                                        ),
                                        const SizedBox(height: 6),
                                        _buildStatValue(
                                          _formatCurrency(
                                              stats['totalWage'] ?? 0.0),
                                          'WAGE',
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              // Divider
                              Container(
                                height: 1,
                                color: appColors.posColor.withOpacity(0.2),
                              ),
                              const SizedBox(height: 8),
                              // Created date
                              Text(
                                'Created on ${_formatDate(squad.createdAt)}',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 11,
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
    return StatCircle(value: value, color: color);
  }

  Widget _buildStatValue(String value, String label) {
    return StatValue(value: value, label: label);
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
