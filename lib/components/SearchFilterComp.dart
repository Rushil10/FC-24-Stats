import 'package:flutter/material.dart';
import 'package:fc_stats_24/theme.dart';

// A generic button for the filter grid
class FilterGridButton extends StatelessWidget {
  final String label;
  final String? value;
  final IconData icon;
  final VoidCallback onTap;

  const FilterGridButton({
    super.key,
    required this.label,
    this.value,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final appColors = Theme.of(context).extension<AppColors>()!;
    final surfaceColor = Theme.of(context).colorScheme.surface;
    final bool isSelected = value != null && value != 'Any' && value != 'All';

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: isSelected
              ? appColors.posColor.withValues(alpha: 0.08)
              : surfaceColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected
                ? appColors.posColor.withValues(alpha: 0.5)
                : Colors.white.withValues(alpha: 0.08),
            width: 1.0,
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: isSelected
                    ? appColors.posColor.withValues(alpha: 0.15)
                    : Colors.grey[850],
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: isSelected
                    ? appColors.posColor
                    : Colors.white.withValues(alpha: 0.6),
                size: 14,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label.toUpperCase(),
                    style: TextStyle(
                      color: isSelected
                          ? appColors.posColor.withValues(alpha: 0.9)
                          : Colors.white.withValues(alpha: 0.85),
                      fontWeight: FontWeight.w900,
                      fontSize: 11,
                      letterSpacing: 0.8,
                    ),
                  ),
                  if (isSelected) ...[
                    const SizedBox(height: 2),
                    Text(
                      value!,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// A widget for the range sliders (Overall, Potential, Age)
class RangeFilterSection extends StatelessWidget {
  final String title;
  final RangeValues values;
  final double min;
  final double max;
  final Function(RangeValues) onChanged;
  final bool showBackground;

  const RangeFilterSection({
    super.key,
    required this.title,
    required this.values,
    required this.min,
    required this.max,
    required this.onChanged,
    this.showBackground = true,
  });

  @override
  Widget build(BuildContext context) {
    final appColors = Theme.of(context).extension<AppColors>()!;
    final surfaceColor = Theme.of(context).colorScheme.surface;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 2),
      padding: showBackground
          ? const EdgeInsets.fromLTRB(14, 8, 8, 2)
          : const EdgeInsets.symmetric(horizontal: 4, vertical: 0),
      decoration: showBackground
          ? BoxDecoration(
              color: surfaceColor,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
            )
          : null,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title.toUpperCase(),
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.5),
              fontWeight: FontWeight.w700,
              fontSize: 11,
              letterSpacing: 0.8,
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: 72,
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "${values.start.round()} - ${values.end.round()}",
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: SliderTheme(
                  data: SliderThemeData(
                    activeTrackColor: appColors.posColor.withValues(alpha: 0.7),
                    inactiveTrackColor: Colors.white.withValues(alpha: 0.1),
                    thumbColor: Colors.white,
                    overlayColor: appColors.posColor.withValues(alpha: 0.1),
                    trackHeight: 1.5,
                    rangeThumbShape:
                        const RoundRangeSliderThumbShape(enabledThumbRadius: 6),
                    rangeTrackShape: const RoundedRectRangeSliderTrackShape(),
                  ),
                  child: RangeSlider(
                    values: values,
                    min: min,
                    max: max,
                    onChanged: onChanged,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class SkillGroup extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const SkillGroup({
    super.key,
    required this.title,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    final appColors = Theme.of(context).extension<AppColors>()!;
    final surfaceColor = Theme.of(context).colorScheme.surface;

    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      decoration: BoxDecoration(
        color: surfaceColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: appColors.posColor.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.03),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(23),
                topRight: Radius.circular(23),
              ),
            ),
            child: Text(
              title,
              style: TextStyle(
                color: appColors.posColor,
                fontWeight: FontWeight.w900,
                fontSize: 16,
                letterSpacing: 1.5,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: children,
            ),
          ),
        ],
      ),
    );
  }
}
