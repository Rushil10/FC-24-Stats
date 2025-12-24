import 'dart:io';
import 'dart:math';
import 'dart:ui' as ui;
import 'package:fc_stats_24/components/FootballField.dart';
import 'package:fc_stats_24/components/FormationPickerSheet.dart';
import 'package:fc_stats_24/components/StatWidgets.dart';
import 'package:fc_stats_24/db/FormationData.dart';
import 'package:fc_stats_24/db/Player.dart';
import 'package:fc_stats_24/db/Squad.dart';
import 'package:fc_stats_24/db/SquadsDatabase.dart';
import 'package:fc_stats_24/screens/SquadPlayerSelectionScreen.dart';
import 'package:fc_stats_24/theme.dart';
import 'package:fc_stats_24/utils/SquadHelpers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class SquadBuilderScreen extends StatefulWidget {
  final Squad? squad;

  const SquadBuilderScreen({super.key, this.squad});

  @override
  State<SquadBuilderScreen> createState() => _SquadBuilderScreenState();
}

class _SquadBuilderScreenState extends State<SquadBuilderScreen> {
  final GlobalKey _fieldKey = GlobalKey();

  Formation _currentFormation = FormationData.formations[0];
  Map<int, Player> _selectedPlayers = {}; // position index -> Player
  bool _isLoading = false;
  bool _showStats = false;
  String _squadName = 'My Squad';
  int? _squadId; // Track the squad ID after first save
  bool _hasUnsavedChanges = false; // Track if auto-save has occurred

  @override
  void initState() {
    super.initState();
    if (widget.squad != null) {
      _loadSquad();
    }
  }

  Future<void> _loadSquad() async {
    setState(() => _isLoading = true);
    try {
      final squad = widget.squad!;
      _squadId = squad.id; // Track the squad ID
      _squadName = squad.name;
      _currentFormation = FormationData.getFormation(squad.formationId);

      final players =
          await SquadsDatabase.instance.getSquadPlayersWithDetails(squad.id!);
      setState(() {
        _selectedPlayers = players;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading squad: $e')),
        );
      }
    }
  }

  Future<void> _selectPlayer(int positionIndex) async {
    final player = await Navigator.push<Player>(
      context,
      MaterialPageRoute(
        builder: (context) => const SquadPlayerSelectionScreen(),
      ),
    );

    if (player != null) {
      setState(() {
        _selectedPlayers[positionIndex] = player;
      });
      // Auto-save after player selection
      await _autoSaveSquad();
    }
  }

  void _removePlayer(int positionIndex) {
    setState(() {
      _selectedPlayers.remove(positionIndex);
    });
    // Auto-save after player removal
    _autoSaveSquad();
  }

  void _showFormationPicker() async {
    final formation =
        await FormationPickerSheet.show(context, _currentFormation);
    if (formation != null) {
      _changeFormation(formation);
    }
  }

  void _changeFormation(Formation newFormation) {
    if (newFormation.id == _currentFormation.id) return;

    // Reassign players based on minimum distance
    final Map<int, Player> newPlayerPositions = {};
    final oldFormation = _currentFormation;

    // For each player in the old formation
    for (var entry in _selectedPlayers.entries) {
      final oldIndex = entry.key;
      final player = entry.value;
      final oldPosition = oldFormation.positions[oldIndex].position;

      // Find the closest position in the new formation
      int closestIndex = 0;
      double minDistance = double.infinity;

      for (int i = 0; i < newFormation.positions.length; i++) {
        // Skip if this position is already taken
        if (newPlayerPositions.containsKey(i)) continue;

        final newPosition = newFormation.positions[i].position;
        final distance = sqrt(
          pow(oldPosition.dx - newPosition.dx, 2) +
              pow(oldPosition.dy - newPosition.dy, 2),
        );

        if (distance < minDistance) {
          minDistance = distance;
          closestIndex = i;
        }
      }

      newPlayerPositions[closestIndex] = player;
    }

    setState(() {
      _currentFormation = newFormation;
      _selectedPlayers = newPlayerPositions;
    });

    // Auto-save after formation change
    _autoSaveSquad();
  }

  // Auto-save squad without showing dialog
  Future<void> _autoSaveSquad() async {
    try {
      final now = DateTime.now().toIso8601String();

      if (_squadId == null) {
        // Create new squad only if we haven't created one yet
        final squad = Squad(
          name: _squadName,
          formationId: _currentFormation.id,
          createdAt: now,
        );
        _squadId = await SquadsDatabase.instance.createSquad(squad);
        if (kDebugMode) {
          print('Auto-save: Created new squad with ID: $_squadId');
        }

        // Add current players
        for (var entry in _selectedPlayers.entries) {
          final positionIndex = entry.key;
          final player = entry.value;
          final position = _currentFormation.positions[positionIndex].label;

          final squadPlayer = SquadPlayer(
            squadId: _squadId!,
            playerId: player.id!,
            position: position,
            positionIndex: positionIndex,
          );

          await SquadsDatabase.instance.addPlayerToSquad(squadPlayer);
        }
      } else {
        // Update existing squad using _squadId
        if (kDebugMode) {
          print('Auto-save: Updating squad ID: $_squadId');
        }
        final updatedSquad = Squad(
          id: _squadId,
          name: _squadName,
          formationId: _currentFormation.id,
          createdAt:
              widget.squad?.createdAt ?? DateTime.now().toIso8601String(),
          updatedAt: now,
        );
        await SquadsDatabase.instance.updateSquad(updatedSquad);

        // Delete old players
        await SquadsDatabase.instance.deleteAllSquadPlayers(_squadId!);

        // Add current players
        for (var entry in _selectedPlayers.entries) {
          final positionIndex = entry.key;
          final player = entry.value;
          final position = _currentFormation.positions[positionIndex].label;

          final squadPlayer = SquadPlayer(
            squadId: _squadId!,
            playerId: player.id!,
            position: position,
            positionIndex: positionIndex,
          );

          await SquadsDatabase.instance.addPlayerToSquad(squadPlayer);
        }
      }
      if (kDebugMode) {
        print('Auto-save: Success! Squad ID: $_squadId');
      }
      _hasUnsavedChanges = true; // Mark that changes have been saved
    } catch (e) {
      // Log the error for debugging
      if (kDebugMode) {
        print('Auto-save error: $e');
      }
    }
  }

  Future<void> _showSaveDialog() async {
    final TextEditingController nameController =
        TextEditingController(text: _squadName);

    final result = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).colorScheme.surface,
        title: const Text('Save Squad', style: TextStyle(color: Colors.white)),
        content: TextField(
          controller: nameController,
          autofocus: true,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: 'Enter squad name',
            hintStyle: TextStyle(color: Colors.grey[600]),
            filled: true,
            fillColor: Theme.of(context).scaffoldBackgroundColor,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              if (nameController.text.trim().isNotEmpty) {
                Navigator.pop(context, nameController.text.trim());
              }
            },
            child: Text(
              'Save',
              style: TextStyle(
                color: Theme.of(context).extension<AppColors>()!.posColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );

    if (result != null && result.isNotEmpty) {
      _squadName = result;
      await _saveSquad();
    }
  }

  Future<void> _saveSquad() async {
    setState(() => _isLoading = true);

    try {
      final now = DateTime.now().toIso8601String();

      int squadId;
      if (_squadId != null) {
        // Update existing squad
        final updatedSquad = Squad(
          id: _squadId,
          name: _squadName,
          formationId: _currentFormation.id,
          createdAt:
              widget.squad?.createdAt ?? DateTime.now().toIso8601String(),
          updatedAt: now,
        );
        await SquadsDatabase.instance.updateSquad(updatedSquad);
        squadId = _squadId!;

        // Delete old players
        await SquadsDatabase.instance.deleteAllSquadPlayers(squadId);
      } else {
        // Create new squad
        final squad = Squad(
          name: _squadName,
          formationId: _currentFormation.id,
          createdAt: now,
        );
        squadId = await SquadsDatabase.instance.createSquad(squad);
        _squadId = squadId; // Track the new squad ID
      }

      // Add players
      for (var entry in _selectedPlayers.entries) {
        final positionIndex = entry.key;
        final player = entry.value;
        final position = _currentFormation.positions[positionIndex].label;

        final squadPlayer = SquadPlayer(
          squadId: squadId,
          playerId: player.id!,
          position: position,
          positionIndex: positionIndex,
        );

        await SquadsDatabase.instance.addPlayerToSquad(squadPlayer);
      }

      setState(() => _isLoading = false);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Squad saved successfully!')),
        );
        Navigator.pop(context, true);
      }
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving squad: $e')),
        );
      }
    }
  }

  // Calculate squad statistics
  Map<String, dynamic> _calculateSquadStats() {
    return SquadHelpers.calculateSquadStats(_selectedPlayers);
  }

  String _formatCurrency(double value) {
    return SquadHelpers.formatCurrency(value);
  }

  Future<void> _captureAndShareSquad() async {
    try {
      RenderRepaintBoundary boundary =
          _fieldKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
      ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      final pngBytes = byteData!.buffer.asUint8List();

      final tempDir = await getTemporaryDirectory();
      final file = await File(
              '${tempDir.path}/squad_${DateTime.now().millisecondsSinceEpoch}.png')
          .create();
      await file.writeAsBytes(pngBytes);

      await Share.shareXFiles(
        [XFile(file.path)],
        text: '$_squadName - ${_currentFormation.name}',
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error sharing squad: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final appColors = Theme.of(context).extension<AppColors>()!;
    final scaffoldColor = Theme.of(context).scaffoldBackgroundColor;
    final stats = _calculateSquadStats();

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (!didPop) {
          // Pop with result indicating if changes were made
          Navigator.of(context).pop(_hasUnsavedChanges);
        }
      },
      child: Scaffold(
        backgroundColor: scaffoldColor,
        extendBodyBehindAppBar: false,
        appBar: AppBar(
          title: Text(
            _squadName,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          actions: [
            IconButton(
              icon: const Icon(Icons.screenshot_outlined),
              onPressed: _captureAndShareSquad,
              tooltip: 'Share Squad',
            ),
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: _isLoading ? null : _showSaveDialog,
              tooltip: 'Rename Squad',
            ),
          ],
        ),
        body: _isLoading
            ? Center(
                child: CircularProgressIndicator(color: appColors.posColor))
            : Column(
                children: [
                  const SizedBox(height: 12),
                  // Football Field
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: RepaintBoundary(
                        key: _fieldKey,
                        child: Container(
                          color: scaffoldColor,
                          child: FootballField(
                            formation: _currentFormation,
                            selectedPlayers: _selectedPlayers,
                            onPositionTap: _selectPlayer,
                            onPlayerLongPress: _removePlayer,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Formation Box | Stats Box (in same row at bottom)
                  SafeArea(
                    top: false,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Row with Formation and Stats buttons
                        Row(
                          children: [
                            // Formation Selector Box
                            Expanded(
                              child: InkWell(
                                onTap: _showFormationPicker,
                                child: Container(
                                  margin:
                                      const EdgeInsets.fromLTRB(12, 0, 6, 0),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 10),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color:
                                          appColors.posColor.withOpacity(0.3),
                                      width: 1.5,
                                    ),
                                    borderRadius: BorderRadius.circular(12),
                                    color:
                                        appColors.surfaceColor.withOpacity(0.5),
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Icon(
                                        Icons.grid_view,
                                        color: Colors.white,
                                        size: 16,
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          _currentFormation.name,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      Icon(
                                        Icons.chevron_right,
                                        color: appColors.posColor,
                                        size: 16,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            // Stats Toggle Button
                            Expanded(
                              child: InkWell(
                                onTap: () =>
                                    setState(() => _showStats = !_showStats),
                                child: Container(
                                  margin:
                                      const EdgeInsets.fromLTRB(6, 0, 12, 0),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 10),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color:
                                          appColors.posColor.withOpacity(0.3),
                                      width: 1.5,
                                    ),
                                    borderRadius: BorderRadius.circular(12),
                                    color:
                                        appColors.surfaceColor.withOpacity(0.5),
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text(
                                        'Stats',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Icon(
                                        _showStats
                                            ? Icons.keyboard_arrow_down
                                            : Icons.keyboard_arrow_up,
                                        color: appColors.posColor,
                                        size: 16,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        // Expanded Stats Panel (full width, appears below)
                        AnimatedSize(
                          duration: const Duration(milliseconds: 200),
                          curve: Curves.easeInOut,
                          child: _showStats
                              ? Container(
                                  margin:
                                      const EdgeInsets.fromLTRB(12, 8, 12, 8),
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color:
                                          appColors.posColor.withOpacity(0.3),
                                      width: 1.5,
                                    ),
                                    borderRadius: BorderRadius.circular(12),
                                    color:
                                        appColors.surfaceColor.withOpacity(0.5),
                                  ),
                                  child: Row(
                                    children: [
                                      // Left Column - Overall & Potential
                                      Expanded(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
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
                                        margin: const EdgeInsets.symmetric(
                                            horizontal: 8),
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
                                                  _formatCurrency(
                                                      stats['totalValue']),
                                                ),
                                                _buildTinyStatItem(
                                                  'WAGE',
                                                  _formatCurrency(
                                                      stats['totalWage']),
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
                ],
              ),
      ), // Close Scaffold
    ); // Close PopScope
  }

  Widget _buildMiniStatCircle(String label, String value, Color color) {
    return MiniStatCircle(label: label, value: value, color: color);
  }

  Widget _buildTinyStatItem(String label, String value) {
    return TinyStatItem(label: label, value: value);
  }
}
