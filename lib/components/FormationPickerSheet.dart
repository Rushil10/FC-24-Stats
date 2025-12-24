import 'package:fc_stats_24/components/MiniFieldPainter.dart';
import 'package:fc_stats_24/db/FormationData.dart';
import 'package:fc_stats_24/theme.dart';
import 'package:flutter/material.dart';

class FormationPickerSheet extends StatelessWidget {
  final Formation currentFormation;
  final Function(Formation) onFormationSelected;

  const FormationPickerSheet({
    super.key,
    required this.currentFormation,
    required this.onFormationSelected,
  });

  static Future<Formation?> show(
    BuildContext context,
    Formation currentFormation,
  ) {
    return showModalBottomSheet<Formation>(
      context: context,
      backgroundColor: Colors.black,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => FormationPickerSheet(
        currentFormation: currentFormation,
        onFormationSelected: (formation) {
          Navigator.pop(context, formation);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final appColors = Theme.of(context).extension<AppColors>()!;
    final selectedIndex =
        FormationData.formations.indexWhere((f) => f.id == currentFormation.id);

    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      expand: false,
      builder: (context, scrollController) {
        // Auto-scroll to selected formation after build
        if (selectedIndex >= 0) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            final row = selectedIndex ~/ 3;
            final scrollOffset = row.toDouble() * 162.0;

            if (scrollController.hasClients) {
              scrollController.animateTo(
                scrollOffset,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOut,
              );
            }
          });
        }

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
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    childAspectRatio: 0.75,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  itemCount: FormationData.formations.length,
                  itemBuilder: (context, index) {
                    final formation = FormationData.formations[index];
                    final isSelected = formation.id == currentFormation.id;

                    return GestureDetector(
                      onTap: () => onFormationSelected(formation),
                      child: Container(
                        decoration: BoxDecoration(
                          color: isSelected
                              ? appColors.posColor.withOpacity(0.15)
                              : appColors.surfaceColor,
                          borderRadius: BorderRadius.circular(12),
                          border: isSelected
                              ? Border.all(color: appColors.posColor, width: 2)
                              : Border.all(color: Colors.grey[800]!, width: 1),
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
}
