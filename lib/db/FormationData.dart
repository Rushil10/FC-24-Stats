import 'package:flutter/material.dart';

class FormationPosition {
  final String label; // e.g., "GK", "LB", "CB1", "CB2", etc.
  final Offset position; // Normalized position (0.0 to 1.0)

  FormationPosition({
    required this.label,
    required this.position,
  });
}

class Formation {
  final String id;
  final String name;
  final List<FormationPosition> positions;

  Formation({
    required this.id,
    required this.name,
    required this.positions,
  });
}

class FormationData {
  static final List<Formation> formations = [
    Formation(
      id: '4-3-3',
      name: '4-3-3 Attack',
      positions: [
        // GK
        FormationPosition(label: 'GK', position: const Offset(0.5, 0.9)),
        // Defenders
        FormationPosition(label: 'LB', position: const Offset(0.15, 0.72)),
        FormationPosition(label: 'CB1', position: const Offset(0.35, 0.75)),
        FormationPosition(label: 'CB2', position: const Offset(0.65, 0.75)),
        FormationPosition(label: 'RB', position: const Offset(0.85, 0.72)),
        // Midfielders
        FormationPosition(label: 'CM1', position: const Offset(0.3, 0.5)),
        FormationPosition(label: 'CM2', position: const Offset(0.5, 0.55)),
        FormationPosition(label: 'CM3', position: const Offset(0.7, 0.5)),
        // Forwards
        FormationPosition(label: 'LW', position: const Offset(0.15, 0.25)),
        FormationPosition(label: 'ST', position: const Offset(0.5, 0.2)),
        FormationPosition(label: 'RW', position: const Offset(0.85, 0.25)),
      ],
    ),
    Formation(
      id: '4-4-2',
      name: '4-4-2 Flat',
      positions: [
        // GK
        FormationPosition(label: 'GK', position: const Offset(0.5, 0.9)),
        // Defenders
        FormationPosition(label: 'LB', position: const Offset(0.15, 0.72)),
        FormationPosition(label: 'CB1', position: const Offset(0.35, 0.75)),
        FormationPosition(label: 'CB2', position: const Offset(0.65, 0.75)),
        FormationPosition(label: 'RB', position: const Offset(0.85, 0.72)),
        // Midfielders
        FormationPosition(label: 'LM', position: const Offset(0.15, 0.5)),
        FormationPosition(label: 'CM1', position: const Offset(0.4, 0.52)),
        FormationPosition(label: 'CM2', position: const Offset(0.6, 0.52)),
        FormationPosition(label: 'RM', position: const Offset(0.85, 0.5)),
        // Forwards
        FormationPosition(label: 'ST1', position: const Offset(0.4, 0.22)),
        FormationPosition(label: 'ST2', position: const Offset(0.6, 0.22)),
      ],
    ),
    Formation(
      id: '4-3-3-D',
      name: '4-3-3 Defend',
      positions: [
        // GK
        FormationPosition(label: 'GK', position: const Offset(0.5, 0.9)),
        // Defenders
        FormationPosition(label: 'LB', position: const Offset(0.15, 0.72)),
        FormationPosition(label: 'CB1', position: const Offset(0.35, 0.75)),
        FormationPosition(label: 'CB2', position: const Offset(0.65, 0.75)),
        FormationPosition(label: 'RB', position: const Offset(0.85, 0.72)),
        // Midfielders
        FormationPosition(label: 'CDM', position: const Offset(0.5, 0.62)),
        FormationPosition(label: 'CM1', position: const Offset(0.3, 0.48)),
        FormationPosition(label: 'CM2', position: const Offset(0.7, 0.48)),
        // Forwards
        FormationPosition(label: 'LW', position: const Offset(0.15, 0.25)),
        FormationPosition(label: 'ST', position: const Offset(0.5, 0.2)),
        FormationPosition(label: 'RW', position: const Offset(0.85, 0.25)),
      ],
    ),
    Formation(
      id: '4-2-3-1',
      name: '4-2-3-1',
      positions: [
        // GK
        FormationPosition(label: 'GK', position: const Offset(0.5, 0.9)),
        // Defenders
        FormationPosition(label: 'LB', position: const Offset(0.15, 0.72)),
        FormationPosition(label: 'CB1', position: const Offset(0.35, 0.75)),
        FormationPosition(label: 'CB2', position: const Offset(0.65, 0.75)),
        FormationPosition(label: 'RB', position: const Offset(0.85, 0.72)),
        // Defensive Midfielders
        FormationPosition(label: 'CDM1', position: const Offset(0.35, 0.58)),
        FormationPosition(label: 'CDM2', position: const Offset(0.65, 0.58)),
        // Attacking Midfielders
        FormationPosition(label: 'LM', position: const Offset(0.15, 0.38)),
        FormationPosition(label: 'CAM', position: const Offset(0.5, 0.35)),
        FormationPosition(label: 'RM', position: const Offset(0.85, 0.38)),
        // Forward
        FormationPosition(label: 'ST', position: const Offset(0.5, 0.18)),
      ],
    ),
    Formation(
      id: '3-5-2',
      name: '3-5-2',
      positions: [
        // GK
        FormationPosition(label: 'GK', position: const Offset(0.5, 0.9)),
        // Defenders
        FormationPosition(label: 'CB1', position: const Offset(0.25, 0.75)),
        FormationPosition(label: 'CB2', position: const Offset(0.5, 0.77)),
        FormationPosition(label: 'CB3', position: const Offset(0.75, 0.75)),
        // Midfielders
        FormationPosition(label: 'LWB', position: const Offset(0.1, 0.55)),
        FormationPosition(label: 'CM1', position: const Offset(0.35, 0.5)),
        FormationPosition(label: 'CM2', position: const Offset(0.5, 0.52)),
        FormationPosition(label: 'CM3', position: const Offset(0.65, 0.5)),
        FormationPosition(label: 'RWB', position: const Offset(0.9, 0.55)),
        // Forwards
        FormationPosition(label: 'ST1', position: const Offset(0.4, 0.22)),
        FormationPosition(label: 'ST2', position: const Offset(0.6, 0.22)),
      ],
    ),
    Formation(
      id: '4-1-2-1-2',
      name: '4-1-2-1-2 Narrow',
      positions: [
        // GK
        FormationPosition(label: 'GK', position: const Offset(0.5, 0.9)),
        // Defenders
        FormationPosition(label: 'LB', position: const Offset(0.15, 0.72)),
        FormationPosition(label: 'CB1', position: const Offset(0.35, 0.75)),
        FormationPosition(label: 'CB2', position: const Offset(0.65, 0.75)),
        FormationPosition(label: 'RB', position: const Offset(0.85, 0.72)),
        // Midfielders
        FormationPosition(label: 'CDM', position: const Offset(0.5, 0.6)),
        FormationPosition(label: 'CM1', position: const Offset(0.35, 0.48)),
        FormationPosition(label: 'CM2', position: const Offset(0.65, 0.48)),
        FormationPosition(label: 'CAM', position: const Offset(0.5, 0.32)),
        // Forwards
        FormationPosition(label: 'ST1', position: const Offset(0.4, 0.18)),
        FormationPosition(label: 'ST2', position: const Offset(0.6, 0.18)),
      ],
    ),
    Formation(
      id: '3-4-3',
      name: '3-4-3',
      positions: [
        // GK
        FormationPosition(label: 'GK', position: const Offset(0.5, 0.9)),
        // Defenders
        FormationPosition(label: 'CB1', position: const Offset(0.25, 0.75)),
        FormationPosition(label: 'CB2', position: const Offset(0.5, 0.77)),
        FormationPosition(label: 'CB3', position: const Offset(0.75, 0.75)),
        // Midfielders
        FormationPosition(label: 'LM', position: const Offset(0.15, 0.52)),
        FormationPosition(label: 'CM1', position: const Offset(0.4, 0.55)),
        FormationPosition(label: 'CM2', position: const Offset(0.6, 0.55)),
        FormationPosition(label: 'RM', position: const Offset(0.85, 0.52)),
        // Forwards
        FormationPosition(label: 'LW', position: const Offset(0.2, 0.25)),
        FormationPosition(label: 'ST', position: const Offset(0.5, 0.2)),
        FormationPosition(label: 'RW', position: const Offset(0.8, 0.25)),
      ],
    ),
    Formation(
      id: '5-3-2',
      name: '5-3-2',
      positions: [
        // GK
        FormationPosition(label: 'GK', position: const Offset(0.5, 0.9)),
        // Defenders
        FormationPosition(label: 'LWB', position: const Offset(0.1, 0.7)),
        FormationPosition(label: 'CB1', position: const Offset(0.3, 0.75)),
        FormationPosition(label: 'CB2', position: const Offset(0.5, 0.77)),
        FormationPosition(label: 'CB3', position: const Offset(0.7, 0.75)),
        FormationPosition(label: 'RWB', position: const Offset(0.9, 0.7)),
        // Midfielders
        FormationPosition(label: 'CM1', position: const Offset(0.3, 0.5)),
        FormationPosition(label: 'CM2', position: const Offset(0.5, 0.52)),
        FormationPosition(label: 'CM3', position: const Offset(0.7, 0.5)),
        // Forwards
        FormationPosition(label: 'ST1', position: const Offset(0.4, 0.22)),
        FormationPosition(label: 'ST2', position: const Offset(0.6, 0.22)),
      ],
    ),
    // New formations
    Formation(
      id: '4-5-1',
      name: '4-5-1 Attack',
      positions: [
        FormationPosition(label: 'GK', position: const Offset(0.5, 0.9)),
        FormationPosition(label: 'LB', position: const Offset(0.15, 0.72)),
        FormationPosition(label: 'CB1', position: const Offset(0.35, 0.75)),
        FormationPosition(label: 'CB2', position: const Offset(0.65, 0.75)),
        FormationPosition(label: 'RB', position: const Offset(0.85, 0.72)),
        FormationPosition(label: 'LM', position: const Offset(0.1, 0.45)),
        FormationPosition(label: 'CM1', position: const Offset(0.3, 0.5)),
        FormationPosition(label: 'CM2', position: const Offset(0.5, 0.52)),
        FormationPosition(label: 'CM3', position: const Offset(0.7, 0.5)),
        FormationPosition(label: 'RM', position: const Offset(0.9, 0.45)),
        FormationPosition(label: 'ST', position: const Offset(0.5, 0.18)),
      ],
    ),
    Formation(
      id: '4-1-4-1',
      name: '4-1-4-1',
      positions: [
        FormationPosition(label: 'GK', position: const Offset(0.5, 0.9)),
        FormationPosition(label: 'LB', position: const Offset(0.15, 0.72)),
        FormationPosition(label: 'CB1', position: const Offset(0.35, 0.75)),
        FormationPosition(label: 'CB2', position: const Offset(0.65, 0.75)),
        FormationPosition(label: 'RB', position: const Offset(0.85, 0.72)),
        FormationPosition(label: 'CDM', position: const Offset(0.5, 0.6)),
        FormationPosition(label: 'LM', position: const Offset(0.15, 0.45)),
        FormationPosition(label: 'CM1', position: const Offset(0.4, 0.48)),
        FormationPosition(label: 'CM2', position: const Offset(0.6, 0.48)),
        FormationPosition(label: 'RM', position: const Offset(0.85, 0.45)),
        FormationPosition(label: 'ST', position: const Offset(0.5, 0.18)),
      ],
    ),
    Formation(
      id: '4-2-3-1-N',
      name: '4-2-3-1 Narrow',
      positions: [
        FormationPosition(label: 'GK', position: const Offset(0.5, 0.9)),
        FormationPosition(label: 'LB', position: const Offset(0.15, 0.72)),
        FormationPosition(label: 'CB1', position: const Offset(0.35, 0.75)),
        FormationPosition(label: 'CB2', position: const Offset(0.65, 0.75)),
        FormationPosition(label: 'RB', position: const Offset(0.85, 0.72)),
        FormationPosition(label: 'CDM1', position: const Offset(0.35, 0.58)),
        FormationPosition(label: 'CDM2', position: const Offset(0.65, 0.58)),
        FormationPosition(label: 'LM', position: const Offset(0.3, 0.38)),
        FormationPosition(label: 'CAM', position: const Offset(0.5, 0.35)),
        FormationPosition(label: 'RM', position: const Offset(0.7, 0.38)),
        FormationPosition(label: 'ST', position: const Offset(0.5, 0.18)),
      ],
    ),
    Formation(
      id: '4-3-2-1',
      name: '4-3-2-1 Wide',
      positions: [
        FormationPosition(label: 'GK', position: const Offset(0.5, 0.9)),
        FormationPosition(label: 'LB', position: const Offset(0.15, 0.72)),
        FormationPosition(label: 'CB1', position: const Offset(0.35, 0.75)),
        FormationPosition(label: 'CB2', position: const Offset(0.65, 0.75)),
        FormationPosition(label: 'RB', position: const Offset(0.85, 0.72)),
        FormationPosition(label: 'CM1', position: const Offset(0.3, 0.55)),
        FormationPosition(label: 'CM2', position: const Offset(0.5, 0.57)),
        FormationPosition(label: 'CM3', position: const Offset(0.7, 0.55)),
        FormationPosition(label: 'LW', position: const Offset(0.2, 0.32)),
        FormationPosition(label: 'RW', position: const Offset(0.8, 0.32)),
        FormationPosition(label: 'ST', position: const Offset(0.5, 0.18)),
      ],
    ),
    Formation(
      id: '4-5-1-F',
      name: '4-5-1 Flat',
      positions: [
        FormationPosition(label: 'GK', position: const Offset(0.5, 0.9)),
        FormationPosition(label: 'LB', position: const Offset(0.15, 0.72)),
        FormationPosition(label: 'CB1', position: const Offset(0.35, 0.75)),
        FormationPosition(label: 'CB2', position: const Offset(0.65, 0.75)),
        FormationPosition(label: 'RB', position: const Offset(0.85, 0.72)),
        FormationPosition(label: 'LM', position: const Offset(0.1, 0.5)),
        FormationPosition(label: 'CM1', position: const Offset(0.3, 0.52)),
        FormationPosition(label: 'CM2', position: const Offset(0.5, 0.53)),
        FormationPosition(label: 'CM3', position: const Offset(0.7, 0.52)),
        FormationPosition(label: 'RM', position: const Offset(0.9, 0.5)),
        FormationPosition(label: 'ST', position: const Offset(0.5, 0.18)),
      ],
    ),
    Formation(
      id: '4-4-1-1-M',
      name: '4-4-1-1 Midfield',
      positions: [
        FormationPosition(label: 'GK', position: const Offset(0.5, 0.9)),
        FormationPosition(label: 'LB', position: const Offset(0.15, 0.72)),
        FormationPosition(label: 'CB1', position: const Offset(0.35, 0.75)),
        FormationPosition(label: 'CB2', position: const Offset(0.65, 0.75)),
        FormationPosition(label: 'RB', position: const Offset(0.85, 0.72)),
        FormationPosition(label: 'LM', position: const Offset(0.15, 0.5)),
        FormationPosition(label: 'CM1', position: const Offset(0.4, 0.52)),
        FormationPosition(label: 'CM2', position: const Offset(0.6, 0.52)),
        FormationPosition(label: 'RM', position: const Offset(0.85, 0.5)),
        FormationPosition(label: 'CAM', position: const Offset(0.5, 0.32)),
        FormationPosition(label: 'ST', position: const Offset(0.5, 0.18)),
      ],
    ),
    Formation(
      id: '4-4-1-1-A',
      name: '4-4-1-1 Attack',
      positions: [
        FormationPosition(label: 'GK', position: const Offset(0.5, 0.9)),
        FormationPosition(label: 'LB', position: const Offset(0.15, 0.72)),
        FormationPosition(label: 'CB1', position: const Offset(0.35, 0.75)),
        FormationPosition(label: 'CB2', position: const Offset(0.65, 0.75)),
        FormationPosition(label: 'RB', position: const Offset(0.85, 0.72)),
        FormationPosition(label: 'LM', position: const Offset(0.15, 0.5)),
        FormationPosition(label: 'CM1', position: const Offset(0.4, 0.52)),
        FormationPosition(label: 'CM2', position: const Offset(0.6, 0.52)),
        FormationPosition(label: 'RM', position: const Offset(0.85, 0.5)),
        FormationPosition(label: 'CF', position: const Offset(0.5, 0.28)),
        FormationPosition(label: 'ST', position: const Offset(0.5, 0.15)),
      ],
    ),
    Formation(
      id: '4-4-2-H',
      name: '4-4-2 Holding',
      positions: [
        FormationPosition(label: 'GK', position: const Offset(0.5, 0.9)),
        FormationPosition(label: 'LB', position: const Offset(0.15, 0.72)),
        FormationPosition(label: 'CB1', position: const Offset(0.35, 0.75)),
        FormationPosition(label: 'CB2', position: const Offset(0.65, 0.75)),
        FormationPosition(label: 'RB', position: const Offset(0.85, 0.72)),
        FormationPosition(label: 'LM', position: const Offset(0.15, 0.5)),
        FormationPosition(label: 'CDM1', position: const Offset(0.4, 0.58)),
        FormationPosition(label: 'CDM2', position: const Offset(0.6, 0.58)),
        FormationPosition(label: 'RM', position: const Offset(0.85, 0.5)),
        FormationPosition(label: 'ST1', position: const Offset(0.4, 0.22)),
        FormationPosition(label: 'ST2', position: const Offset(0.6, 0.22)),
      ],
    ),
    Formation(
      id: '4-2-2-2',
      name: '4-2-2-2',
      positions: [
        FormationPosition(label: 'GK', position: const Offset(0.5, 0.9)),
        FormationPosition(label: 'LB', position: const Offset(0.15, 0.72)),
        FormationPosition(label: 'CB1', position: const Offset(0.35, 0.75)),
        FormationPosition(label: 'CB2', position: const Offset(0.65, 0.75)),
        FormationPosition(label: 'RB', position: const Offset(0.85, 0.72)),
        FormationPosition(label: 'CDM1', position: const Offset(0.35, 0.58)),
        FormationPosition(label: 'CDM2', position: const Offset(0.65, 0.58)),
        FormationPosition(label: 'LM', position: const Offset(0.25, 0.38)),
        FormationPosition(label: 'RM', position: const Offset(0.75, 0.38)),
        FormationPosition(label: 'ST1', position: const Offset(0.4, 0.2)),
        FormationPosition(label: 'ST2', position: const Offset(0.6, 0.2)),
      ],
    ),
    Formation(
      id: '4-3-3-F',
      name: '4-3-3 Flat',
      positions: [
        FormationPosition(label: 'GK', position: const Offset(0.5, 0.9)),
        FormationPosition(label: 'LB', position: const Offset(0.15, 0.72)),
        FormationPosition(label: 'CB1', position: const Offset(0.35, 0.75)),
        FormationPosition(label: 'CB2', position: const Offset(0.65, 0.75)),
        FormationPosition(label: 'RB', position: const Offset(0.85, 0.72)),
        FormationPosition(label: 'CM1', position: const Offset(0.3, 0.52)),
        FormationPosition(label: 'CM2', position: const Offset(0.5, 0.53)),
        FormationPosition(label: 'CM3', position: const Offset(0.7, 0.52)),
        FormationPosition(label: 'LW', position: const Offset(0.15, 0.25)),
        FormationPosition(label: 'ST', position: const Offset(0.5, 0.2)),
        FormationPosition(label: 'RW', position: const Offset(0.85, 0.25)),
      ],
    ),
    Formation(
      id: '5-4-1-D',
      name: '5-4-1 Diamond',
      positions: [
        FormationPosition(label: 'GK', position: const Offset(0.5, 0.9)),
        FormationPosition(label: 'LWB', position: const Offset(0.1, 0.7)),
        FormationPosition(label: 'CB1', position: const Offset(0.3, 0.75)),
        FormationPosition(label: 'CB2', position: const Offset(0.5, 0.77)),
        FormationPosition(label: 'CB3', position: const Offset(0.7, 0.75)),
        FormationPosition(label: 'RWB', position: const Offset(0.9, 0.7)),
        FormationPosition(label: 'CDM', position: const Offset(0.5, 0.58)),
        FormationPosition(label: 'LM', position: const Offset(0.25, 0.45)),
        FormationPosition(label: 'RM', position: const Offset(0.75, 0.45)),
        FormationPosition(label: 'CAM', position: const Offset(0.5, 0.32)),
        FormationPosition(label: 'ST', position: const Offset(0.5, 0.18)),
      ],
    ),
    Formation(
      id: '4-2-4',
      name: '4-2-4',
      positions: [
        FormationPosition(label: 'GK', position: const Offset(0.5, 0.9)),
        FormationPosition(label: 'LB', position: const Offset(0.15, 0.72)),
        FormationPosition(label: 'CB1', position: const Offset(0.35, 0.75)),
        FormationPosition(label: 'CB2', position: const Offset(0.65, 0.75)),
        FormationPosition(label: 'RB', position: const Offset(0.85, 0.72)),
        FormationPosition(label: 'CDM1', position: const Offset(0.35, 0.55)),
        FormationPosition(label: 'CDM2', position: const Offset(0.65, 0.55)),
        FormationPosition(label: 'LW', position: const Offset(0.15, 0.28)),
        FormationPosition(label: 'ST1', position: const Offset(0.4, 0.2)),
        FormationPosition(label: 'ST2', position: const Offset(0.6, 0.2)),
        FormationPosition(label: 'RW', position: const Offset(0.85, 0.28)),
      ],
    ),
    Formation(
      id: '5-1-2-1-1',
      name: '5-1-2-1-1',
      positions: [
        FormationPosition(label: 'GK', position: const Offset(0.5, 0.9)),
        FormationPosition(label: 'LWB', position: const Offset(0.1, 0.7)),
        FormationPosition(label: 'CB1', position: const Offset(0.3, 0.75)),
        FormationPosition(label: 'CB2', position: const Offset(0.5, 0.77)),
        FormationPosition(label: 'CB3', position: const Offset(0.7, 0.75)),
        FormationPosition(label: 'RWB', position: const Offset(0.9, 0.7)),
        FormationPosition(label: 'CDM', position: const Offset(0.5, 0.58)),
        FormationPosition(label: 'CM1', position: const Offset(0.35, 0.45)),
        FormationPosition(label: 'CM2', position: const Offset(0.65, 0.45)),
        FormationPosition(label: 'CAM', position: const Offset(0.5, 0.28)),
        FormationPosition(label: 'ST', position: const Offset(0.5, 0.15)),
      ],
    ),
    Formation(
      id: '5-2-1-2',
      name: '5-2-1-2',
      positions: [
        FormationPosition(label: 'GK', position: const Offset(0.5, 0.9)),
        FormationPosition(label: 'LWB', position: const Offset(0.1, 0.7)),
        FormationPosition(label: 'CB1', position: const Offset(0.3, 0.75)),
        FormationPosition(label: 'CB2', position: const Offset(0.5, 0.77)),
        FormationPosition(label: 'CB3', position: const Offset(0.7, 0.75)),
        FormationPosition(label: 'RWB', position: const Offset(0.9, 0.7)),
        FormationPosition(label: 'CM1', position: const Offset(0.35, 0.52)),
        FormationPosition(label: 'CM2', position: const Offset(0.65, 0.52)),
        FormationPosition(label: 'CAM', position: const Offset(0.5, 0.35)),
        FormationPosition(label: 'ST1', position: const Offset(0.4, 0.2)),
        FormationPosition(label: 'ST2', position: const Offset(0.6, 0.2)),
      ],
    ),
    Formation(
      id: '3-1-4-2',
      name: '3-1-4-2',
      positions: [
        FormationPosition(label: 'GK', position: const Offset(0.5, 0.9)),
        FormationPosition(label: 'CB1', position: const Offset(0.25, 0.75)),
        FormationPosition(label: 'CB2', position: const Offset(0.5, 0.77)),
        FormationPosition(label: 'CB3', position: const Offset(0.75, 0.75)),
        FormationPosition(label: 'CDM', position: const Offset(0.5, 0.6)),
        FormationPosition(label: 'LM', position: const Offset(0.15, 0.45)),
        FormationPosition(label: 'CM1', position: const Offset(0.4, 0.48)),
        FormationPosition(label: 'CM2', position: const Offset(0.6, 0.48)),
        FormationPosition(label: 'RM', position: const Offset(0.85, 0.45)),
        FormationPosition(label: 'ST1', position: const Offset(0.4, 0.2)),
        FormationPosition(label: 'ST2', position: const Offset(0.6, 0.2)),
      ],
    ),
    Formation(
      id: '3-4-3-D',
      name: '3-4-3 Diamond',
      positions: [
        FormationPosition(label: 'GK', position: const Offset(0.5, 0.9)),
        FormationPosition(label: 'CB1', position: const Offset(0.25, 0.75)),
        FormationPosition(label: 'CB2', position: const Offset(0.5, 0.77)),
        FormationPosition(label: 'CB3', position: const Offset(0.75, 0.75)),
        FormationPosition(label: 'CDM', position: const Offset(0.5, 0.58)),
        FormationPosition(label: 'LM', position: const Offset(0.25, 0.45)),
        FormationPosition(label: 'RM', position: const Offset(0.75, 0.45)),
        FormationPosition(label: 'CAM', position: const Offset(0.5, 0.32)),
        FormationPosition(label: 'LW', position: const Offset(0.2, 0.2)),
        FormationPosition(label: 'ST', position: const Offset(0.5, 0.15)),
        FormationPosition(label: 'RW', position: const Offset(0.8, 0.2)),
      ],
    ),
    Formation(
      id: '3-4-2-1',
      name: '3-4-2-1',
      positions: [
        FormationPosition(label: 'GK', position: const Offset(0.5, 0.9)),
        FormationPosition(label: 'CB1', position: const Offset(0.25, 0.75)),
        FormationPosition(label: 'CB2', position: const Offset(0.5, 0.77)),
        FormationPosition(label: 'CB3', position: const Offset(0.75, 0.75)),
        FormationPosition(label: 'LM', position: const Offset(0.15, 0.52)),
        FormationPosition(label: 'CM1', position: const Offset(0.4, 0.55)),
        FormationPosition(label: 'CM2', position: const Offset(0.6, 0.55)),
        FormationPosition(label: 'RM', position: const Offset(0.85, 0.52)),
        FormationPosition(label: 'LW', position: const Offset(0.3, 0.28)),
        FormationPosition(label: 'RW', position: const Offset(0.7, 0.28)),
        FormationPosition(label: 'ST', position: const Offset(0.5, 0.15)),
      ],
    ),
    Formation(
      id: '3-4-3-F',
      name: '3-4-3 Flat',
      positions: [
        FormationPosition(label: 'GK', position: const Offset(0.5, 0.9)),
        FormationPosition(label: 'CB1', position: const Offset(0.25, 0.75)),
        FormationPosition(label: 'CB2', position: const Offset(0.5, 0.77)),
        FormationPosition(label: 'CB3', position: const Offset(0.75, 0.75)),
        FormationPosition(label: 'LM', position: const Offset(0.15, 0.52)),
        FormationPosition(label: 'CM1', position: const Offset(0.4, 0.53)),
        FormationPosition(label: 'CM2', position: const Offset(0.6, 0.53)),
        FormationPosition(label: 'RM', position: const Offset(0.85, 0.52)),
        FormationPosition(label: 'LW', position: const Offset(0.2, 0.25)),
        FormationPosition(label: 'ST', position: const Offset(0.5, 0.2)),
        FormationPosition(label: 'RW', position: const Offset(0.8, 0.25)),
      ],
    ),
    Formation(
      id: '3-5-1-1',
      name: '3-5-1-1',
      positions: [
        FormationPosition(label: 'GK', position: const Offset(0.5, 0.9)),
        FormationPosition(label: 'CB1', position: const Offset(0.25, 0.75)),
        FormationPosition(label: 'CB2', position: const Offset(0.5, 0.77)),
        FormationPosition(label: 'CB3', position: const Offset(0.75, 0.75)),
        FormationPosition(label: 'LWB', position: const Offset(0.1, 0.55)),
        FormationPosition(label: 'CM1', position: const Offset(0.35, 0.5)),
        FormationPosition(label: 'CM2', position: const Offset(0.5, 0.52)),
        FormationPosition(label: 'CM3', position: const Offset(0.65, 0.5)),
        FormationPosition(label: 'RWB', position: const Offset(0.9, 0.55)),
        FormationPosition(label: 'CAM', position: const Offset(0.5, 0.3)),
        FormationPosition(label: 'ST', position: const Offset(0.5, 0.15)),
      ],
    ),
    Formation(
      id: '3-4-1-2',
      name: '3-4-1-2',
      positions: [
        FormationPosition(label: 'GK', position: const Offset(0.5, 0.9)),
        FormationPosition(label: 'CB1', position: const Offset(0.25, 0.75)),
        FormationPosition(label: 'CB2', position: const Offset(0.5, 0.77)),
        FormationPosition(label: 'CB3', position: const Offset(0.75, 0.75)),
        FormationPosition(label: 'LM', position: const Offset(0.15, 0.52)),
        FormationPosition(label: 'CM1', position: const Offset(0.4, 0.55)),
        FormationPosition(label: 'CM2', position: const Offset(0.6, 0.55)),
        FormationPosition(label: 'RM', position: const Offset(0.85, 0.52)),
        FormationPosition(label: 'CAM', position: const Offset(0.5, 0.32)),
        FormationPosition(label: 'ST1', position: const Offset(0.4, 0.18)),
        FormationPosition(label: 'ST2', position: const Offset(0.6, 0.18)),
      ],
    ),
  ];

  static Formation getFormation(String id) {
    return formations.firstWhere(
      (f) => f.id == id,
      orElse: () => formations[0], // Default to 4-3-3
    );
  }
}
