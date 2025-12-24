import 'dart:io';
import 'dart:math';
import 'dart:ui' as ui;
import 'package:fc_stats_24/db/FormationData.dart';
import 'package:fc_stats_24/db/Player.dart';
import 'package:fc_stats_24/db/Squad.dart';
import 'package:fc_stats_24/db/SquadsDatabase.dart';
import 'package:fc_stats_24/screens/SquadPlayerSelectionScreen.dart';
import 'package:fc_stats_24/theme.dart';
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
  bool _showStats = true;
  String _squadName = 'My Squad';

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

  void _showFormationPicker() {
    final appColors = Theme.of(context).extension<AppColors>()!;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.black,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.7,
          minChildSize: 0.5,
          maxChildSize: 0.95,
          expand: false,
          builder: (context, scrollController) {
            return Container(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(left: 4, bottom: 16),
                    child: Text(
                      'Select Formation',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Expanded(
                    child: GridView.builder(
                      controller: scrollController,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        childAspectRatio: 0.75,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                      ),
                      itemCount: FormationData.formations.length,
                      itemBuilder: (context, index) {
                        final formation = FormationData.formations[index];
                        final isSelected = formation.id == _currentFormation.id;

                        return GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                            _changeFormation(formation);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? appColors.posColor.withOpacity(0.15)
                                  : appColors.surfaceColor,
                              borderRadius: BorderRadius.circular(12),
                              border: isSelected
                                  ? Border.all(
                                      color: appColors.posColor, width: 2)
                                  : Border.all(
                                      color: Colors.grey[800]!, width: 1),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // Mini Formation Preview
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8),
                                    child: _buildFormationPreview(
                                        formation, isSelected, appColors),
                                  ),
                                ),
                                // Formation Name
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 8, horizontal: 4),
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? appColors.posColor.withOpacity(0.2)
                                        : Colors.transparent,
                                    borderRadius: const BorderRadius.only(
                                      bottomLeft: Radius.circular(12),
                                      bottomRight: Radius.circular(12),
                                    ),
                                  ),
                                  child: Column(
                                    children: [
                                      Text(
                                        formation.name,
                                        style: TextStyle(
                                          color: isSelected
                                              ? appColors.posColor
                                              : Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 11,
                                        ),
                                        textAlign: TextAlign.center,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      if (isSelected)
                                        Icon(
                                          Icons.check_circle,
                                          color: appColors.posColor,
                                          size: 16,
                                        ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildFormationPreview(
      Formation formation, bool isSelected, AppColors appColors) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final height = constraints.maxHeight;

        return Container(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFF1a4d2e),
                Color(0xFF0d2818),
              ],
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Stack(
            children: [
              // Draw mini field lines
              CustomPaint(
                size: Size(width, height),
                painter: MiniFieldPainter(),
              ),
              // Draw player positions as dots
              ...formation.positions.map((pos) {
                return Positioned(
                  left: pos.position.dx * width - 3,
                  top: pos.position.dy * height - 3,
                  child: Container(
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isSelected ? appColors.posColor : Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.5),
                          blurRadius: 2,
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ],
          ),
        );
      },
    );
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
    if (widget.squad == null) return; // Don't auto-save new squads

    try {
      final now = DateTime.now().toIso8601String();

      final updatedSquad = Squad(
        id: widget.squad!.id,
        name: _squadName,
        formationId: _currentFormation.id,
        createdAt: widget.squad!.createdAt,
        updatedAt: now,
      );
      await SquadsDatabase.instance.updateSquad(updatedSquad);

      // Delete old players
      await SquadsDatabase.instance.deleteAllSquadPlayers(widget.squad!.id!);

      // Add current players
      for (var entry in _selectedPlayers.entries) {
        final positionIndex = entry.key;
        final player = entry.value;
        final position = _currentFormation.positions[positionIndex].label;

        final squadPlayer = SquadPlayer(
          squadId: widget.squad!.id!,
          playerId: player.id!,
          position: position,
          positionIndex: positionIndex,
        );

        await SquadsDatabase.instance.addPlayerToSquad(squadPlayer);
      }
    } catch (e) {
      // Silently fail for auto-save
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
      if (widget.squad != null) {
        // Update existing squad
        final updatedSquad = Squad(
          id: widget.squad!.id,
          name: _squadName,
          formationId: _currentFormation.id,
          createdAt: widget.squad!.createdAt,
          updatedAt: now,
        );
        await SquadsDatabase.instance.updateSquad(updatedSquad);
        squadId = widget.squad!.id!;

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
    if (_selectedPlayers.isEmpty) {
      return {
        'avgOverall': 0,
        'avgPotential': 0,
        'totalValue': 0,
        'totalWage': 0,
        'avgAge': 0,
        'playerCount': 0,
      };
    }

    double totalOverall = 0;
    double totalPotential = 0;
    double totalValue = 0;
    double totalWage = 0;
    double totalAge = 0;

    for (var player in _selectedPlayers.values) {
      totalOverall += (player.overall ?? 0).toDouble();
      totalPotential += (player.potential ?? 0).toDouble();
      totalValue += (player.valueEur ?? 0).toDouble();
      totalWage += (player.wageEur ?? 0).toDouble();
      totalAge += (player.age ?? 0).toDouble();
    }

    final count = _selectedPlayers.length;

    return {
      'avgOverall': (totalOverall / count).round(),
      'avgPotential': (totalPotential / count).round(),
      'totalValue': totalValue,
      'totalWage': totalWage,
      'avgAge': (totalAge / count).round(),
      'playerCount': count,
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

    return Scaffold(
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
          ? Center(child: CircularProgressIndicator(color: appColors.posColor))
          : Column(
              children: [
                // Compact Professional Stats Panel
                Container(
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
                          onTap: () => setState(() => _showStats = !_showStats),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 8),
                            decoration: BoxDecoration(
                              color: appColors.surfaceColor.withOpacity(0.5),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  _currentFormation.name,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Icon(
                                  _showStats
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
                          child: _showStats
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
                ),
                // Football Field
                Expanded(
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
                // Formation Button with SafeArea
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: appColors.surfaceColor,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 10,
                        offset: const Offset(0, -2),
                      ),
                    ],
                  ),
                  child: SafeArea(
                    top: false,
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: _showFormationPicker,
                        icon: const Icon(Icons.grid_view, color: Colors.black),
                        label: Text(
                          _currentFormation.name,
                          style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: appColors.posColor,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildMiniStatCircle(String label, String value, Color color) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 38,
          height: 38,
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
        const SizedBox(height: 2),
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

  Widget _buildTinyStatItem(String label, String value) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.grey,
            fontSize: 8,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 11,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

// Mini field painter for formation previews
class MiniFieldPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.5;

    // Center line
    canvas.drawLine(
      Offset(0, size.height / 2),
      Offset(size.width, size.height / 2),
      paint,
    );

    // Center circle (small)
    canvas.drawCircle(
      Offset(size.width / 2, size.height / 2),
      size.width * 0.12,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

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
                    left: formation.positions[i].position.dx * width - 35,
                    top: formation.positions[i].position.dy * height - 35,
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

class FieldPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    // Center circle
    canvas.drawCircle(
      Offset(size.width / 2, size.height / 2),
      size.width * 0.15,
      paint,
    );

    // Center line
    canvas.drawLine(
      Offset(0, size.height / 2),
      Offset(size.width, size.height / 2),
      paint,
    );

    // Penalty boxes
    final penaltyBoxWidth = size.width * 0.6;
    final penaltyBoxHeight = size.height * 0.18;

    // Top penalty box
    canvas.drawRect(
      Rect.fromLTWH(
        (size.width - penaltyBoxWidth) / 2,
        0,
        penaltyBoxWidth,
        penaltyBoxHeight,
      ),
      paint,
    );

    // Bottom penalty box
    canvas.drawRect(
      Rect.fromLTWH(
        (size.width - penaltyBoxWidth) / 2,
        size.height - penaltyBoxHeight,
        penaltyBoxWidth,
        penaltyBoxHeight,
      ),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class PlayerPosition extends StatelessWidget {
  final Player? player;
  final String position;
  final VoidCallback onTap;
  final VoidCallback? onLongPress;

  const PlayerPosition({
    super.key,
    this.player,
    required this.position,
    required this.onTap,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    final appColors = Theme.of(context).extension<AppColors>()!;

    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: player != null
                      ? appColors.posColor.withOpacity(0.9)
                      : Colors.white.withOpacity(0.2),
                  border: Border.all(
                    color: Colors.white,
                    width: 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 8,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: player != null
                    ? ClipOval(
                        child: Image.network(
                          player!.playerFaceUrl ?? '',
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Center(
                              child: Text(
                                player!.shortName
                                        ?.substring(0, 1)
                                        .toUpperCase() ??
                                    '?',
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            );
                          },
                        ),
                      )
                    : const Icon(
                        Icons.add,
                        color: Colors.white,
                        size: 30,
                      ),
              ),
              // OVR badge - top left
              if (player != null)
                Positioned(
                  top: -2,
                  left: -2,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                    decoration: BoxDecoration(
                      color: appColors.ovrColor, // Purple
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(color: Colors.white, width: 1),
                    ),
                    child: Text(
                      '${player!.overall ?? 0}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              // POT badge - top right
              if (player != null)
                Positioned(
                  top: -2,
                  right: -2,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                    decoration: BoxDecoration(
                      color: appColors.clubNameColor,
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(color: Colors.black, width: 1),
                    ),
                    child: Text(
                      '${player!.potential ?? 0}',
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 4),
          if (player != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.7),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                player!.shortName ?? 'Unknown',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            )
          else
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.7),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                position,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
