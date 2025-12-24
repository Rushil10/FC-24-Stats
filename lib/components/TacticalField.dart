import 'package:fc_stats_24/theme.dart';
import 'package:flutter/material.dart';

class TacticalFieldPainter extends CustomPainter {
  final Color lineColor;

  TacticalFieldPainter({required this.lineColor});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = lineColor.withOpacity(0.15)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    // Outer Boundary
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paint);

    // Halfway Line
    canvas.drawLine(
        Offset(0, size.height / 2), Offset(size.width, size.height / 2), paint);

    // Center Circle
    canvas.drawCircle(Offset(size.width / 2, size.height / 2), 50, paint);
    canvas.drawCircle(Offset(size.width / 2, size.height / 2), 2,
        paint..style = PaintingStyle.fill);

    // Penalty Areas
    // Top
    canvas.drawRect(
        Rect.fromLTWH(
            size.width * 0.2, 0, size.width * 0.6, size.height * 0.15),
        paint..style = PaintingStyle.stroke);
    canvas.drawRect(
        Rect.fromLTWH(
            size.width * 0.35, 0, size.width * 0.3, size.height * 0.05),
        paint);

    // Bottom
    canvas.drawRect(
        Rect.fromLTWH(size.width * 0.2, size.height * 0.85, size.width * 0.6,
            size.height * 0.15),
        paint);
    canvas.drawRect(
        Rect.fromLTWH(size.width * 0.35, size.height * 0.95, size.width * 0.3,
            size.height * 0.05),
        paint);

    // Arc
    final arcPaint = Paint()
      ..color = lineColor.withOpacity(0.15)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    canvas.drawArc(
        Rect.fromCircle(
            center: Offset(size.width / 2, size.height * 0.15), radius: 40),
        0,
        3.14,
        false,
        arcPaint);
    canvas.drawArc(
        Rect.fromCircle(
            center: Offset(size.width / 2, size.height * 0.85), radius: 40),
        3.14,
        3.14,
        false,
        arcPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class TacticalFieldSelector extends StatelessWidget {
  final List<String> selectedPositions;
  final Function(String) onToggle;
  final List<String> availablePositions;

  TacticalFieldSelector({
    required this.selectedPositions,
    required this.onToggle,
    required this.availablePositions,
  });

  final Map<String, Offset> tacticalCoords = {
    'ST': const Offset(0.5, 0.08),
    'CF': const Offset(0.5, 0.18),
    'LW': const Offset(0.18, 0.23),
    'RW': const Offset(0.82, 0.23),
    'CAM': const Offset(0.5, 0.35),
    'LM': const Offset(0.15, 0.5),
    'CM': const Offset(0.5, 0.5),
    'RM': const Offset(0.85, 0.5),
    'CDM': const Offset(0.5, 0.65),
    'LWB': const Offset(0.1, 0.7),
    'RWB': const Offset(0.9, 0.7),
    'LB': const Offset(0.2, 0.8),
    'CB': const Offset(0.5, 0.8),
    'RB': const Offset(0.8, 0.8),
    'GK': const Offset(0.5, 0.93),
  };

  @override
  Widget build(BuildContext context) {
    final appColors = Theme.of(context).extension<AppColors>()!;

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xff0a0d0a),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withOpacity(0.08)),
      ),
      child: AspectRatio(
        aspectRatio: 0.62, // Taller field to take more vertical space
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Stack(
              children: [
                // Grass Texture / Gradient
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                      gradient: const LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Color(0xff161d16),
                          Color(0xff0a0d0a),
                        ],
                      ),
                    ),
                  ),
                ),

                // Field Background with Lines
                Positioned.fill(
                  child: Opacity(
                    opacity: 0.6,
                    child: CustomPaint(
                      painter: TacticalFieldPainter(lineColor: Colors.white),
                    ),
                  ),
                ),

                // Position Markers
                ...tacticalCoords.entries.map((entry) {
                  final pos = entry.key;
                  final offset = entry.value;
                  final isSelected = selectedPositions.contains(pos);
                  final bool isActuallyAvailable =
                      availablePositions.contains(pos);

                  if (!isActuallyAvailable) return const SizedBox.shrink();

                  // Increased marker size
                  const double markerWidth = 52.0;
                  const double markerHeight = 34.0;

                  return Positioned(
                    left: offset.dx * constraints.maxWidth - (markerWidth / 2),
                    top: offset.dy * constraints.maxHeight - (markerHeight / 2),
                    child: GestureDetector(
                      onTap: () => onToggle(pos),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 250),
                            width: markerWidth,
                            height: markerHeight,
                            curve: Curves.easeOut,
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? appColors.posColor
                                  : Colors.white.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: isSelected
                                  ? [
                                      BoxShadow(
                                        color:
                                            appColors.posColor.withOpacity(0.5),
                                        blurRadius: 15,
                                        spreadRadius: 2,
                                      )
                                    ]
                                  : [],
                              border: Border.all(
                                color: isSelected
                                    ? Colors.black.withOpacity(0.1)
                                    : Colors.white.withOpacity(0.15),
                                width: isSelected ? 1.5 : 1,
                              ),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              pos,
                              style: TextStyle(
                                color: isSelected
                                    ? Colors.black
                                    : Colors.white.withOpacity(0.9),
                                fontSize: 11,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                          const SizedBox(height: 3),
                          if (isSelected)
                            Container(
                              width: 5,
                              height: 5,
                              decoration: BoxDecoration(
                                  color: appColors.posColor,
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color:
                                          appColors.posColor.withOpacity(0.8),
                                      blurRadius: 4,
                                    )
                                  ]),
                            ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ],
            );
          },
        ),
      ),
    );
  }
}
