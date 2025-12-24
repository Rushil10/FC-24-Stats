import 'package:fc_stats_24/theme.dart';
import 'package:flutter/material.dart';

class SelectionScreen extends StatefulWidget {
  final String title;
  final Future<List<String>> fetcher;
  final List<String> initialSelected;
  final bool multiSelect;
  final Function(List<String>)? onChanged;

  const SelectionScreen({
    super.key,
    required this.title,
    required this.fetcher,
    this.initialSelected = const [],
    this.multiSelect = true,
    this.onChanged,
  });

  @override
  State<SelectionScreen> createState() => _SelectionScreenState();
}

class _SelectionScreenState extends State<SelectionScreen> {
  List<String> _allItems = [];
  List<String> _filteredItems = [];
  List<String> _selectedItems = [];
  bool _loading = true;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _selectedItems = List.from(widget.initialSelected);
    _loadItems();
  }

  Future<void> _loadItems() async {
    final items = await widget.fetcher;
    if (mounted) {
      setState(() {
        _allItems = items;
        _filteredItems = items;
        _sortItems();
        _loading = false;
      });
    }
  }

  void _onSearchChanged(String query) {
    setState(() {
      _filteredItems = _allItems
          .where((item) => item.toLowerCase().contains(query.toLowerCase()))
          .toList();
      _sortItems();
    });
  }

  void _sortItems() {
    _filteredItems.sort((a, b) {
      bool aSel = _selectedItems.contains(a);
      bool bSel = _selectedItems.contains(b);
      if (aSel && !bSel) return -1;
      if (!aSel && bSel) return 1;
      return a.compareTo(b);
    });
  }

  @override
  Widget build(BuildContext context) {
    final appColors = Theme.of(context).extension<AppColors>()!;
    final surfaceColor = Theme.of(context).colorScheme.surface;
    final scaffoldColor = Theme.of(context).scaffoldBackgroundColor;

    return Scaffold(
      backgroundColor: scaffoldColor,
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              onChanged: _onSearchChanged,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: "Search ${widget.title}...",
                hintStyle: TextStyle(color: Colors.grey[600]),
                prefixIcon: Icon(Icons.search, color: Colors.grey[600]),
                filled: true,
                fillColor: surfaceColor,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          Expanded(
            child: _loading
                ? Center(
                    child: CircularProgressIndicator(color: appColors.posColor))
                : ListView.builder(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    itemCount: _filteredItems.length,
                    itemBuilder: (context, index) {
                      final item = _filteredItems[index];
                      final isSelected = _selectedItems.contains(item);
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              if (widget.multiSelect) {
                                if (isSelected) {
                                  _selectedItems.remove(item);
                                } else {
                                  _selectedItems.add(item);
                                }
                                widget.onChanged?.call(_selectedItems);
                                _sortItems();
                              } else {
                                widget.onChanged?.call([item]);
                                Navigator.pop(context);
                              }
                            });
                          },
                          borderRadius: BorderRadius.circular(12),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 14),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? appColors.posColor.withValues(alpha: 0.06)
                                  : surfaceColor,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: isSelected
                                    ? appColors.posColor.withValues(alpha: 0.4)
                                    : Colors.white.withValues(alpha: 0.03),
                                width: 1.0,
                              ),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    item,
                                    style: TextStyle(
                                      color: isSelected
                                          ? Colors.white
                                          : Colors.white.withValues(alpha: 0.7),
                                      fontWeight: isSelected
                                          ? FontWeight.w700
                                          : FontWeight.w400,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                                if (isSelected)
                                  Icon(Icons.check_circle,
                                      color: appColors.posColor, size: 20)
                                else
                                  Icon(Icons.circle_outlined,
                                      color:
                                          Colors.white.withValues(alpha: 0.1),
                                      size: 20),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: scaffoldColor,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.3),
                  blurRadius: 20,
                  offset: const Offset(0, -5),
                )
              ],
            ),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: appColors.posColor,
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                  elevation: 0,
                ),
                child: const Text("DONE",
                    style: TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 16,
                        letterSpacing: 1.2)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
