import 'dart:async';
import 'package:fc_stats_24/components/SearchFilterComp.dart';
import 'package:fc_stats_24/db/Player.dart';
import 'package:fc_stats_24/db/players22.dart';
import 'package:fc_stats_24/screens/PositionSelectionScreen.dart';
import 'package:fc_stats_24/screens/SearchResultsScreen.dart';
import 'package:fc_stats_24/screens/SelectionScreen.dart';
import 'package:fc_stats_24/screens/SkillsSelectionScreen.dart';
import 'package:fc_stats_24/screens/GameAttributesSelectionScreen.dart';
import 'package:fc_stats_24/theme.dart';
import 'package:fc_stats_24/providers/search_provider.dart';
import 'package:fc_stats_24/screens/PlayerDetails.dart';
import 'package:fc_stats_24/State/VideoAdState.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  Timer? _debounce;

  // Overlay Results
  List<Player> _overlayResults = [];
  bool _isLoadingOverlay = false;
  bool _showOverlay = false;

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
          filters: filters,
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

  void _openPositionSelector() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PositionSelectionScreen(
          provider: searchFiltersProvider,
        ),
      ),
    );
  }

  void _openSkillsSelector() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SkillsSelectionScreen(
          provider: searchFiltersProvider,
        ),
      ),
    );
  }

  void _openGameAttributesSelector() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GameAttributesSelectionScreen(
          provider: searchFiltersProvider,
        ),
      ),
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
            padding: const EdgeInsets.only(top: 75),
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
                  const SizedBox(height: 8),
                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    crossAxisSpacing: 6,
                    mainAxisSpacing: 6,
                    childAspectRatio: 3.1,
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
                          if (filters.preferredFoot == null) {
                            filtersNotifier.setPreferredFoot("Left");
                          } else if (filters.preferredFoot == "Left") {
                            filtersNotifier.setPreferredFoot("Right");
                          } else {
                            filtersNotifier.setPreferredFoot(null);
                          }
                        },
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
                        label: "Game Attributes",
                        icon: Icons.bar_chart,
                        value:
                            filters.isGameAttributesSelected ? "Active" : "Any",
                        onTap: _openSkillsSelector,
                      ),
                      FilterGridButton(
                        label: "Physical & Skills",
                        icon: Icons.settings_applications,
                        value: filters.isSkillsSelected ? "Active" : "Any",
                        onTap: _openGameAttributesSelector,
                      ),
                    ],
                  ),
                  const SizedBox(height: 80),
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
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
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
                  contentPadding: const EdgeInsets.symmetric(vertical: 0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
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
                  boxShadow: const [
                    BoxShadow(
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
                                            p.playerFaceUrl ?? '',
                                            errorBuilder: (c, o, s) =>
                                                const Icon(Icons.person,
                                                    color: Colors.grey)),
                                      ),
                                      title: Text(p.shortName ?? 'Unknown',
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 16)),
                                      subtitle: Text(
                                          "${p.overall} | ${p.formattedPositions}",
                                          style: TextStyle(
                                              color: appColors.posColor,
                                              fontSize: 14)),
                                      onTap: () {
                                        final count = ref.read(videoAdProvider);
                                        ref
                                            .read(videoAdProvider.notifier)
                                            .increment();
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => PlayerDetails(
                                              player: p,
                                              count: count,
                                            ),
                                          ),
                                        );
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
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 10),
        width: double.infinity,
        child: ElevatedButton(
          onPressed: _navigateToResults,
          style: ElevatedButton.styleFrom(
            backgroundColor: appColors.posColor,
            foregroundColor: Colors.black,
            elevation: 0,
            padding: const EdgeInsets.symmetric(vertical: 12),
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
}
