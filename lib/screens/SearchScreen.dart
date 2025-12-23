import 'dart:async';
import 'package:fc_stats_24/components/SearchFilterComp.dart';
import 'package:fc_stats_24/db/players22.dart';
import 'package:fc_stats_24/screens/SearchResultsScreen.dart';
import 'package:fc_stats_24/screens/SelectionScreen.dart';
import 'package:fc_stats_24/theme.dart';
import 'package:fc_stats_24/providers/search_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  Timer? _debounce;

  // Overlay Results
  List<Map> _overlayResults = [];
  bool _isLoadingOverlay = false;
  bool _showOverlay = false;

  Future<List<String>>? _positionsFuture;
  Future<List<String>> _getPositions() {
    _positionsFuture ??= PlayersDatabase.instance.getDistinctPositions();
    return _positionsFuture!;
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    if (query.isEmpty) {
      setState(() {
        _showOverlay = false;
        _overlayResults = [];
      });
      return;
    }

    setState(() {
      _showOverlay = true;
      _isLoadingOverlay = true;
    });

    _debounce = Timer(const Duration(milliseconds: 500), () async {
      final results = await PlayersDatabase.instance.filterPlayers(
        query: query,
      );

      if (mounted) {
        setState(() {
          _overlayResults = results;
          _isLoadingOverlay = false;
          if (_searchController.text.isEmpty) {
            _showOverlay = false;
          }
        });
      }
    });
  }

  void _navigateToResults() {
    final filters = ref.read(searchFiltersProvider);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SearchResultsScreen(
          query: _searchController.text,
          minOverall: filters.overallRange.start,
          maxOverall: filters.overallRange.end,
          minPotential: filters.potentialRange.start,
          maxPotential: filters.potentialRange.end,
          minAge: filters.ageRange.start,
          maxAge: filters.ageRange.end,
          selectedPositions: filters.selectedPositions,
          preferredFoot: filters.preferredFoot,
          leagues: filters.selectedLeagues,
          nationalities: filters.selectedNationalities,
          clubs: filters.selectedClubs,
          playStyles: filters.selectedPlayStyles,
          roles: filters.selectedRoles,
        ),
      ),
    );
  }

  Future<void> _navigateToSelector({
    required String title,
    required Future<List<String>> fetcher,
    required List<String> initialSelected,
    required Function(List<String>) onResult,
  }) async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SelectionScreen(
          title: title,
          fetcher: fetcher,
          initialSelected: initialSelected,
          onChanged: onResult,
        ),
      ),
    );
  }

  void _openPositionSelector() async {
    final appColors = Theme.of(context).extension<AppColors>()!;
    final surfaceColor = Theme.of(context).colorScheme.surface;

    final positions = await _getPositions();
    if (!mounted) return;

    showModalBottomSheet(
      context: context,
      backgroundColor: surfaceColor,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Consumer(builder: (context, ref, child) {
          final currentPositions =
              ref.watch(searchFiltersProvider).selectedPositions;
          return Container(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
            height: MediaQuery.of(context).size.height * 0.7,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Field Positions",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.w900)),
                        Text("${currentPositions.length} Selected",
                            style: TextStyle(
                                color: appColors.posColor.withOpacity(0.8),
                                fontSize: 13,
                                fontWeight: FontWeight.bold)),
                      ],
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close, color: Colors.white),
                    )
                  ],
                ),
                const SizedBox(height: 24),
                Expanded(
                  child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      childAspectRatio: 2.2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                    ),
                    itemCount: positions.length,
                    itemBuilder: (context, index) {
                      final pos = positions[index];
                      final isSelected = currentPositions.contains(pos);
                      return InkWell(
                        onTap: () {
                          ref
                              .read(searchFiltersProvider.notifier)
                              .togglePosition(pos);
                        },
                        borderRadius: BorderRadius.circular(12),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? appColors.posColor.withOpacity(0.1)
                                : Colors.white.withOpacity(0.05),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isSelected
                                  ? appColors.posColor
                                  : Colors.transparent,
                              width: 1.5,
                            ),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            pos,
                            style: TextStyle(
                              color: isSelected
                                  ? Colors.white
                                  : Colors.white.withOpacity(0.6),
                              fontWeight: isSelected
                                  ? FontWeight.w900
                                  : FontWeight.w600,
                              fontSize: 15,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: appColors.posColor,
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)),
                      elevation: 0,
                    ),
                    child: const Text("DONE",
                        style: TextStyle(
                            fontWeight: FontWeight.w900, letterSpacing: 1.1)),
                  ),
                ),
              ],
            ),
          );
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final appColors = Theme.of(context).extension<AppColors>()!;
    final surfaceColor = Theme.of(context).colorScheme.surface;
    final scaffoldColor = Theme.of(context).scaffoldBackgroundColor;
    final filters = ref.watch(searchFiltersProvider);
    final filtersNotifier = ref.read(searchFiltersProvider.notifier);

    return Scaffold(
      backgroundColor: scaffoldColor,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text("Player Potentials",
            style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_alt_off),
            onPressed: () => filtersNotifier.reset(),
          )
        ],
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 80),
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  RangeFilterSection(
                    title: "Overall",
                    values: filters.overallRange,
                    min: 0,
                    max: 99,
                    onChanged: (v) => filtersNotifier.setOverallRange(v),
                  ),
                  RangeFilterSection(
                    title: "Potential",
                    values: filters.potentialRange,
                    min: 0,
                    max: 99,
                    onChanged: (v) => filtersNotifier.setPotentialRange(v),
                  ),
                  RangeFilterSection(
                    title: "Age",
                    values: filters.ageRange,
                    min: 15,
                    max: 45,
                    onChanged: (v) => filtersNotifier.setAgeRange(v),
                  ),
                  const SizedBox(height: 16),
                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 2.5,
                    children: [
                      FilterGridButton(
                        label: "Position",
                        icon: Icons.place,
                        value: filters.selectedPositions.isEmpty
                            ? "All"
                            : "(${filters.selectedPositions.length}) Selected",
                        onTap: _openPositionSelector,
                      ),
                      FilterGridButton(
                        label: "Foot",
                        icon: Icons.directions_walk,
                        value: filters.preferredFoot ?? "Any",
                        onTap: () {
                          if (filters.preferredFoot == null)
                            filtersNotifier.setPreferredFoot("Left");
                          else if (filters.preferredFoot == "Left")
                            filtersNotifier.setPreferredFoot("Right");
                          else
                            filtersNotifier.setPreferredFoot(null);
                        },
                      ),
                      FilterGridButton(
                        label: "League",
                        icon: Icons.emoji_events,
                        value: filters.selectedLeagues.isEmpty
                            ? "Any"
                            : filters.selectedLeagues.length == 1
                                ? filters.selectedLeagues.first
                                : "(${filters.selectedLeagues.length}) Selected",
                        onTap: () => _navigateToSelector(
                          title: "League",
                          fetcher:
                              PlayersDatabase.instance.getDistinctLeagues(),
                          initialSelected: filters.selectedLeagues,
                          onResult: (res) => filtersNotifier.setLeagues(res),
                        ),
                      ),
                      FilterGridButton(
                        label: "Nationality",
                        icon: Icons.flag,
                        value: filters.selectedNationalities.isEmpty
                            ? "Any"
                            : filters.selectedNationalities.length == 1
                                ? filters.selectedNationalities.first
                                : "(${filters.selectedNationalities.length}) Selected",
                        onTap: () => _navigateToSelector(
                          title: "Nationality",
                          fetcher: PlayersDatabase.instance
                              .getDistinctNationalities(),
                          initialSelected: filters.selectedNationalities,
                          onResult: (res) =>
                              filtersNotifier.setNationalities(res),
                        ),
                      ),
                      FilterGridButton(
                        label: "Club",
                        icon: Icons.home,
                        value: filters.selectedClubs.isEmpty
                            ? "Any"
                            : filters.selectedClubs.length == 1
                                ? filters.selectedClubs.first
                                : "(${filters.selectedClubs.length}) Selected",
                        onTap: () => _navigateToSelector(
                          title: "Club",
                          fetcher: PlayersDatabase.instance.getDistinctClubs(),
                          initialSelected: filters.selectedClubs,
                          onResult: (res) => filtersNotifier.setClubs(res),
                        ),
                      ),
                      FilterGridButton(
                        label: "Play Styles",
                        icon: Icons.star,
                        value: filters.selectedPlayStyles.isEmpty
                            ? "Any"
                            : "(${filters.selectedPlayStyles.length}) Selected",
                        onTap: () => _navigateToSelector(
                          title: "Play Styles",
                          fetcher: PlayersDatabase.instance.getDistinctTraits(),
                          initialSelected: filters.selectedPlayStyles,
                          onResult: (res) => filtersNotifier.setPlayStyles(res),
                        ),
                      ),
                      FilterGridButton(
                        label: "Roles",
                        icon: Icons.work,
                        value: filters.selectedRoles ?? "Any",
                        onTap: () {
                          // Roles (Work rate) can still be a simple text or a dialog for now
                          // User specifically asked for full screen for League, Club, Nationality, Play Style
                          _openRolesSelector();
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              color: scaffoldColor,
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: _searchController,
                focusNode: _searchFocusNode,
                onChanged: _onSearchChanged,
                onTap: () {
                  if (_searchController.text.isNotEmpty) {
                    setState(() => _showOverlay = true);
                  }
                },
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: "SEARCH",
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
          ),
          if (_showOverlay)
            Positioned(
              top: 80,
              left: 16,
              right: 16,
              height: MediaQuery.of(context).size.height * 0.5,
              child: Container(
                decoration: BoxDecoration(
                  color: surfaceColor,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    const BoxShadow(
                        color: Colors.black54, blurRadius: 10, spreadRadius: 2)
                  ],
                  border: Border.all(color: Colors.grey[800]!),
                ),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                          border: Border(
                              bottom: BorderSide(color: Colors.grey[800]!))),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Quick Results (${_overlayResults.length})",
                              style: const TextStyle(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.bold)),
                          GestureDetector(
                            onTap: () => setState(() => _showOverlay = false),
                            child: const Icon(Icons.close,
                                color: Colors.grey, size: 20),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: _isLoadingOverlay
                          ? Center(
                              child: CircularProgressIndicator(
                                  color: appColors.posColor))
                          : _overlayResults.isEmpty
                              ? const Center(
                                  child: Text("No players found",
                                      style: TextStyle(color: Colors.grey)))
                              : ListView.builder(
                                  itemCount: _overlayResults.length,
                                  itemBuilder: (context, index) {
                                    final p = _overlayResults[index];
                                    return ListTile(
                                      leading: CircleAvatar(
                                        backgroundColor: Colors.transparent,
                                        child: Image.network(
                                            p['player_face_url'] ?? '',
                                            errorBuilder: (c, o, s) =>
                                                const Icon(Icons.person,
                                                    color: Colors.grey)),
                                      ),
                                      title: Text(p['short_name'] ?? 'Unknown',
                                          style: const TextStyle(
                                              color: Colors.white)),
                                      subtitle: Text(
                                          "${p['overall']} | ${p['player_positions']}",
                                          style: TextStyle(
                                              color: appColors.posColor)),
                                      onTap: () {
                                        // Preview - just typing
                                      },
                                    );
                                  },
                                ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
      bottomSheet: Container(
        color: scaffoldColor,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        width: double.infinity,
        child: ElevatedButton(
          onPressed: _navigateToResults,
          style: ElevatedButton.styleFrom(
            backgroundColor: appColors.posColor,
            foregroundColor: Colors.black,
            elevation: 0,
            padding: const EdgeInsets.symmetric(vertical: 18),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          ),
          child: const Text("SEARCH",
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.2)),
        ),
      ),
    );
  }

  void _openRolesSelector() {
    final appColors = Theme.of(context).extension<AppColors>()!;
    final surfaceColor = Theme.of(context).colorScheme.surface;
    final currentValue = ref.read(searchFiltersProvider).selectedRoles;

    TextEditingController c = TextEditingController(text: currentValue);
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: surfaceColor,
            title: const Text("Enter Roles / Work Rate",
                style: TextStyle(color: Colors.white)),
            content: TextField(
              controller: c,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                  hintText: "e.g. High/High",
                  hintStyle: TextStyle(color: Colors.grey)),
            ),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Cancel")),
              TextButton(
                  onPressed: () {
                    ref
                        .read(searchFiltersProvider.notifier)
                        .setSelectedRoles(c.text.isEmpty ? null : c.text);
                    Navigator.pop(context);
                  },
                  child: Text("Save",
                      style: TextStyle(color: appColors.posColor))),
            ],
          );
        });
  }
}
