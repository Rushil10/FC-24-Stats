import 'package:flutter/material.dart';

/// A circular widget displaying a stat value with a colored border
class StatCircle extends StatelessWidget {
  final String value;
  final Color color;
  final double size;

  const StatCircle({
    super.key,
    required this.value,
    required this.color,
    this.size = 50,
  });

  @override
  Widget build(BuildContext context) {
    // Parse the value to calculate progress (0-99 scale)
    final numValue = int.tryParse(value) ?? 0;
    final progress = (numValue / 99).clamp(0.0, 1.0);

    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Circular progress indicator
          SizedBox(
            width: size,
            height: size,
            child: CircularProgressIndicator(
              value: progress,
              strokeWidth: 3.5,
              backgroundColor: color.withOpacity(0.2),
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ),
          // Value text in center
          Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: size * 0.36, // Increased for better visibility
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

/// A mini circular stat with label below (for compact displays)
class MiniStatCircle extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const MiniStatCircle({
    super.key,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    // Parse the value to calculate progress (0-99 scale)
    final numValue = int.tryParse(value) ?? 0;
    final progress = (numValue / 99).clamp(0.0, 1.0);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 38,
          height: 38,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Circular progress indicator
              SizedBox(
                width: 38,
                height: 38,
                child: CircularProgressIndicator(
                  value: progress,
                  strokeWidth: 3,
                  backgroundColor: color.withOpacity(0.2),
                  valueColor: AlwaysStoppedAnimation<Color>(color),
                ),
              ),
              // Value text in center
              Text(
                value,
                style: TextStyle(
                  color: color,
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
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
}

/// A vertical stat display with value and label
class StatValue extends StatelessWidget {
  final String value;
  final String label;

  const StatValue({
    super.key,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
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
}

/// A tiny stat item with label above value (for very compact displays)
class TinyStatItem extends StatelessWidget {
  final String label;
  final String value;

  const TinyStatItem({
    super.key,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 11,
            fontWeight: FontWeight.bold,
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
}
