import 'package:fc_stats_24/theme.dart';
import 'package:flutter/material.dart';

class TacticalFieldPainter extends CustomPainter {
  final Color lineColor;

  TacticalFieldPainter({required this.lineColor});

  @override
  void paint(Canvas canvas, Size size) {
    // 1. Draw solid background first to ensure no gaps
    final bgPaint = Paint()..color = const Color(0xff0d130d);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 0, size.width, size.height),
        const Radius.circular(24),
      ),
      bgPaint,
    );

    // 2. Draw Grass Striping (6 Balanced Sections)
    final double stripeHeight = size.height / 6;
    final stripePaint = Paint()..style = PaintingStyle.fill;

    for (int i = 0; i < 6; i++) {
      if (i % 2 == 0) {
        stripePaint.color = const Color(0xff161d16);
        canvas.drawRect(
          Rect.fromLTWH(0, i * stripeHeight, size.width, stripeHeight),
          stripePaint,
        );
      }
    }

    // 3. Tactical Lines Paint (Fully Dynamic)
    final linePaint = Paint()
      ..color = lineColor.withValues(alpha: 0.25)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.8;

    final double centerX = size.width / 2;
    final double centerY = size.height / 2;

    // Outer Boundary
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), linePaint);

    // Halfway Line
    canvas.drawLine(Offset(0, centerY), Offset(size.width, centerY), linePaint);

    // Center Circle (Dynamic Radius)
    final double centerCircleRadius = size.width * 0.18;
    canvas.drawCircle(Offset(centerX, centerY), centerCircleRadius, linePaint);
    canvas.drawCircle(
        Offset(centerX, centerY), 2, linePaint..style = PaintingStyle.fill);
    linePaint.style = PaintingStyle.stroke;

    // Penalty Areas (Responsive dimensions)
    final double penAreaW = size.width * 0.75;
    final double penAreaH = size.height * 0.16;
    final double goalAreaW = size.width * 0.35;
    final double goalAreaH = size.height * 0.05;

    // Top (Away)
    canvas.drawRect(
        Rect.fromLTWH((size.width - penAreaW) / 2, 0, penAreaW, penAreaH),
        linePaint);
    canvas.drawRect(
        Rect.fromLTWH((size.width - goalAreaW) / 2, 0, goalAreaW, goalAreaH),
        linePaint);

    // Bottom (Home)
    canvas.drawRect(
        Rect.fromLTWH((size.width - penAreaW) / 2, size.height - penAreaH,
            penAreaW, penAreaH),
        linePaint);
    canvas.drawRect(
        Rect.fromLTWH((size.width - goalAreaW) / 2, size.height - goalAreaH,
            goalAreaW, goalAreaH),
        linePaint);

    // Penalty Arcs (Responsive)
    final double arcRadius = size.width * 0.12;
    canvas.drawArc(
        Rect.fromCircle(center: Offset(centerX, penAreaH), radius: arcRadius),
        0,
        3.14159,
        false,
        linePaint);
    canvas.drawArc(
        Rect.fromCircle(
            center: Offset(centerX, size.height - penAreaH), radius: arcRadius),
        3.14159,
        3.14159,
        false,
        linePaint);

    // Corner Arcs
    final double cornerSize = size.width * 0.04;
    canvas.drawArc(
        Rect.fromLTWH(-cornerSize, -cornerSize, cornerSize * 2, cornerSize * 2),
        0,
        1.57,
        false,
        linePaint);
    canvas.drawArc(
        Rect.fromLTWH(size.width - cornerSize, -cornerSize, cornerSize * 2,
            cornerSize * 2),
        1.57,
        1.57,
        false,
        linePaint);
    canvas.drawArc(
        Rect.fromLTWH(-cornerSize, size.height - cornerSize, cornerSize * 2,
            cornerSize * 2),
        4.71,
        1.57,
        false,
        linePaint);
    canvas.drawArc(
        Rect.fromLTWH(size.width - cornerSize, size.height - cornerSize,
            cornerSize * 2, cornerSize * 2),
        3.14,
        1.57,
        false,
        linePaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class TacticalFieldSelector extends StatelessWidget {
  final List<String> selectedPositions;
  final Function(String) onToggle;
  final List<String> availablePositions;

  const TacticalFieldSelector({
    super.key,
    required this.selectedPositions,
    required this.onToggle,
    required this.availablePositions,
  });

  static const Map<String, Offset> tacticalCoords = {
    'ST': Offset(0.5, 0.08),
    'CF': Offset(0.5, 0.18),
    'LW': Offset(0.18, 0.23),
    'RW': Offset(0.82, 0.23),
    'CAM': Offset(0.5, 0.35),
    'LM': Offset(0.15, 0.5),
    'CM': Offset(0.5, 0.5),
    'RM': Offset(0.85, 0.5),
    'CDM': Offset(0.5, 0.65),
    'LWB': Offset(0.1, 0.7),
    'RWB': Offset(0.9, 0.7),
    'LB': Offset(0.2, 0.8),
    'CB': Offset(0.5, 0.8),
    'RB': Offset(0.8, 0.8),
    'GK': Offset(0.5, 0.94),
  };

  @override
  Widget build(BuildContext context) {
    final appColors = Theme.of(context).extension<AppColors>()!;

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xff0a0d0a),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: AspectRatio(
        aspectRatio: 0.55, // Even taller (fuller screen) pitch
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Stack(
              children: [
                // Field Background with Lines (Now handles striping too)
                Positioned.fill(
                  child: CustomPaint(
                    painter: TacticalFieldPainter(lineColor: Colors.white),
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
                                  : Colors.white.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: isSelected
                                  ? [
                                      BoxShadow(
                                        color: appColors.posColor
                                            .withValues(alpha: 0.5),
                                        blurRadius: 15,
                                        spreadRadius: 2,
                                      )
                                    ]
                                  : [],
                              border: Border.all(
                                color: isSelected
                                    ? Colors.black.withValues(alpha: 0.1)
                                    : Colors.white.withValues(alpha: 0.15),
                                width: isSelected ? 1.5 : 1,
                              ),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              pos,
                              style: TextStyle(
                                color: isSelected
                                    ? Colors.black
                                    : Colors.white.withValues(alpha: 0.9),
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
                                      color: appColors.posColor
                                          .withValues(alpha: 0.8),
                                      blurRadius: 4,
                                    )
                                  ]),
                            ),
                        ],
                      ),
                    ),
                  );
                }),
              ],
            );
          },
        ),
      ),
    );
  }
}
