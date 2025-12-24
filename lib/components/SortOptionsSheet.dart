import 'package:fc_stats_24/theme.dart';
import 'package:flutter/material.dart';

/// A bottom sheet for selecting sort options
class SortOptionsSheet extends StatelessWidget {
  final String currentSort;
  final Map<String, String> sortOptions;
  final Function(String) onSortSelected;

  const SortOptionsSheet({
    super.key,
    required this.currentSort,
    required this.sortOptions,
    required this.onSortSelected,
  });

  static Future<String?> show(
    BuildContext context, {
    required String currentSort,
    required Map<String, String> sortOptions,
  }) {
    return showModalBottomSheet<String>(
      context: context,
      backgroundColor: Colors.black,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (context) => SortOptionsSheet(
        currentSort: currentSort,
        sortOptions: sortOptions,
        onSortSelected: (option) => Navigator.pop(context, option),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final appColors = Theme.of(context).extension<AppColors>()!;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.only(bottom: 20),
            decoration: BoxDecoration(
              color: Colors.grey[800],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const Text(
            'SORT BY',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w900,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 24),
          Flexible(
            child: GridView.count(
              shrinkWrap: true,
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 2.5,
              children: sortOptions.keys.map((option) {
                final isSelected = currentSort == option;
                return InkWell(
                  onTap: () => onSortSelected(option),
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    decoration: BoxDecoration(
                      color: isSelected
                          ? appColors.posColor.withOpacity(0.1)
                          : Colors.grey[900],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected
                            ? appColors.posColor
                            : Colors.transparent,
                        width: 1.5,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        option,
                        style: TextStyle(
                          color: isSelected ? appColors.posColor : Colors.white,
                          fontWeight:
                              isSelected ? FontWeight.bold : FontWeight.normal,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
