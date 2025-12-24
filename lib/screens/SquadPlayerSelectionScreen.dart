import 'dart:async';
import 'package:fc_stats_24/db/Player.dart';
import 'package:fc_stats_24/db/players22.dart';
import 'package:fc_stats_24/providers/favorites_provider.dart';
import 'package:fc_stats_24/theme.dart';
import 'package:fc_stats_24/components/playerCard.dart';
import 'package:fc_stats_24/components/SearchFilterComp.dart';
import 'package:fc_stats_24/screens/PositionSelectionScreen.dart';
import 'package:fc_stats_24/screens/SkillsSelectionScreen.dart';
import 'package:fc_stats_24/screens/GameAttributesSelectionScreen.dart';
import 'package:fc_stats_24/screens/SelectionScreen.dart';
import 'package:fc_stats_24/providers/search_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SquadPlayerSelectionScreen extends ConsumerStatefulWidget {
  const SquadPlayerSelectionScreen({super.key});

  @override
  ConsumerState<SquadPlayerSelectionScreen> createState() =>
      _SquadPlayerSelectionScreenState();
}

class _SquadPlayerSelectionScreenState
    extends ConsumerState<SquadPlayerSelectionScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;

  List<Player> _searchResults = [];
  List<Player> _bestPlayers = [];
  List<Player> _filteredResults = [];
  bool _isLoadingSearch = false;
  bool _isLoadingBest = false;
  bool _isLoadingFiltered = false;
  bool _showFilteredResults = false;
  String _sortOption = 'Overall';

  final Map<String, String> _sortMap = {
    'Overall': 'overall DESC',
    'Potential': 'potential DESC',
    'Position': 'player_positions ASC',
    'Age': 'age ASC',
    'Name': 'short_name ASC',
    'Height': 'height_cm DESC',
    'Value': 'value_eur DESC',
  };

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        setState(() {});
      }
    });
    _loadBestPlayers();
  }

  Future<void> _performAdvancedSearch() async {
    setState(() {
      _isLoadingFiltered = true;
      _showFilteredResults = true;
    });

    final filters = ref.read(squadSearchFiltersProvider);

    try {
      final results = await PlayersDatabase.instance.filterPlayers(
        minOverall: filters.overallRange.start,
        maxOverall: filters.overallRange.end,
        minPotential: filters.potentialRange.start,
        maxPotential: filters.potentialRange.end,
        minAge: filters.ageRange.start,
        maxAge: filters.ageRange.end,
        positions: filters.selectedPositions,
        preferredFoot: filters.preferredFoot,
        leagues: filters.selectedLeagues,
        nationalities: filters.selectedNationalities,
        clubs: filters.selectedClubs,
        playStyles: filters.selectedPlayStyles,
        minPace: filters.paceRange.start,
        maxPace: filters.paceRange.end,
        minHeight: filters.heightRange.start,
        maxHeight: filters.heightRange.end,
        minWeight: filters.weightRange.start,
        maxWeight: filters.weightRange.end,
        minSkillMoves: filters.skillMovesRange.start,
        maxSkillMoves: filters.skillMovesRange.end,
        minWeakFoot: filters.weakFootRange.start,
        maxWeakFoot: filters.weakFootRange.end,
        minReputation: filters.internationalReputationRange.start,
        maxReputation: filters.internationalReputationRange.end,
        minShooting: filters.shootingRange.start,
        maxShooting: filters.shootingRange.end,
        minPassing: filters.passingRange.start,
        maxPassing: filters.passingRange.end,
        minDribbling: filters.dribblingRange.start,
        maxDribbling: filters.dribblingRange.end,
        minDefending: filters.defendingRange.start,
        maxDefending: filters.defendingRange.end,
        minPhysic: filters.physicalRange.start,
        maxPhysic: filters.physicalRange.end,
        orderBy: _sortMap[_sortOption],
      );

      if (mounted) {
        setState(() {
          _filteredResults = results;
          _isLoadingFiltered = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() => _isLoadingFiltered = false);
    }
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

  Future<void> _loadBestPlayers() async {
    setState(() => _isLoadingBest = true);
    try {
      final players = await PlayersDatabase.instance.filterPlayers(
        minOverall: 85,
        orderBy: _sortMap[_sortOption],
      );
      setState(() {
        _bestPlayers = players;
        _isLoadingBest = false;
      });
    } catch (e) {
      setState(() => _isLoadingBest = false);
    }
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    if (query.isEmpty) {
      setState(() {
        _searchResults = [];
      });
      return;
    }

    setState(() => _isLoadingSearch = true);

    _debounce = Timer(const Duration(milliseconds: 500), () async {
      final results = await PlayersDatabase.instance.filterPlayers(
        query: query,
        orderBy: _sortMap[_sortOption],
      );

      if (mounted) {
        setState(() {
          _searchResults = results;
          _isLoadingSearch = false;
        });
      }
    });
  }

  void _showSortOptions() {
    final appColors = Theme.of(context).extension<AppColors>()!;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.black,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (context) {
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
                  children: _sortMap.keys.map((option) {
                    final isSelected = _sortOption == option;
                    return InkWell(
                      onTap: () {
                        Navigator.pop(context);
                        setState(() {
                          _sortOption = option;
                        });
                        if (_searchController.text.isNotEmpty) {
                          _onSearchChanged(_searchController.text);
                        } else {
                          _loadBestPlayers();
                        }
                      },
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
                              color: isSelected
                                  ? appColors.posColor
                                  : Colors.white,
                              fontWeight: isSelected
                                  ? FontWeight.bold
                                  : FontWeight.normal,
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
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final appColors = Theme.of(context).extension<AppColors>()!;
    final scaffoldColor = Theme.of(context).scaffoldBackgroundColor;
    final surfaceColor = Theme.of(context).colorScheme.surface;
    final favorites = ref.watch(favoritesProvider);

    return Scaffold(
      backgroundColor: scaffoldColor,
      appBar: AppBar(
        title: const Text(
          'Select a Player',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          if (_tabController.index == 2)
            IconButton(
              icon: const Icon(Icons.filter_alt_off),
              tooltip: 'Clear Filters',
              onPressed: () {
                ref.read(squadSearchFiltersProvider.notifier).reset();
                setState(() => _showFilteredResults = false);
              },
            ),
          IconButton(
            icon: const Icon(Icons.sort),
            onPressed: _showSortOptions,
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(110),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                child: TextField(
                  controller: _searchController,
                  onChanged: _onSearchChanged,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'SEARCH',
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
              TabBar(
                controller: _tabController,
                indicatorColor: appColors.posColor,
                labelColor: appColors.posColor,
                unselectedLabelColor: Colors.grey,
                tabs: const [
                  Tab(text: 'Best Players'),
                  Tab(text: 'Favorites'),
                  Tab(text: 'Filters'),
                ],
              ),
            ],
          ),
        ),
      ),
      body: _searchController.text.isNotEmpty
          ? _buildSearchResults()
          : TabBarView(
              controller: _tabController,
              children: [
                _buildBestPlayersList(),
                _buildFavoritesList(favorites),
                _buildFiltersTab(),
              ],
            ),
    );
  }

  Widget _buildFiltersTab() {
    if (_showFilteredResults) {
      return Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            color: Colors.white.withOpacity(0.05),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Results (${_filteredResults.length})",
                  style: const TextStyle(
                      color: Colors.grey, fontWeight: FontWeight.bold),
                ),
                TextButton.icon(
                  onPressed: () => setState(() => _showFilteredResults = false),
                  icon: const Icon(Icons.filter_list, size: 18),
                  label: const Text("Edit Filters"),
                  style: TextButton.styleFrom(
                    foregroundColor:
                        Theme.of(context).extension<AppColors>()!.posColor,
                  ),
                ),
              ],
            ),
          ),
          Expanded(child: _buildFilteredList()),
        ],
      );
    }

    final filters = ref.watch(squadSearchFiltersProvider);
    final filtersNotifier = ref.read(squadSearchFiltersProvider.notifier);

    return Stack(
      children: [
        ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "ADVANCED SEARCH",
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.5),
                    fontWeight: FontWeight.w900,
                    fontSize: 12,
                    letterSpacing: 1.2,
                  ),
                ),
                TextButton.icon(
                  onPressed: () {
                    filtersNotifier.reset();
                    setState(() => _showFilteredResults = false);
                  },
                  icon: const Icon(Icons.refresh, size: 16),
                  label: const Text("RESET ALL"),
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.redAccent,
                    textStyle: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
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
            const SizedBox(height: 12),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              childAspectRatio: 2.8,
              children: [
                FilterGridButton(
                  label: "Positions",
                  icon: Icons.place,
                  value: filters.selectedPositions.isEmpty
                      ? "All"
                      : "(${filters.selectedPositions.length}) Selected",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PositionSelectionScreen(
                          provider: squadSearchFiltersProvider,
                        ),
                      ),
                    );
                  },
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
                  label: "Clubs",
                  icon: Icons.home,
                  onTap: () => _navigateToSelector(
                    title: "Club",
                    fetcher: PlayersDatabase.instance.getDistinctClubs(),
                    initialSelected: filters.selectedClubs,
                    onResult: (res) => filtersNotifier.setClubs(res),
                  ),
                ),
                FilterGridButton(
                  label: "Leagues",
                  icon: Icons.emoji_events,
                  onTap: () => _navigateToSelector(
                    title: "League",
                    fetcher: PlayersDatabase.instance.getDistinctLeagues(),
                    initialSelected: filters.selectedLeagues,
                    onResult: (res) => filtersNotifier.setLeagues(res),
                  ),
                ),
                FilterGridButton(
                  label: "Attributes",
                  icon: Icons.bar_chart,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SkillsSelectionScreen(
                          provider: squadSearchFiltersProvider,
                        ),
                      ),
                    );
                  },
                ),
                FilterGridButton(
                  label: "Physical",
                  icon: Icons.settings_applications,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => GameAttributesSelectionScreen(
                          provider: squadSearchFiltersProvider,
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 100),
          ],
        ),
        Positioned(
          bottom: 16,
          left: 16,
          right: 16,
          child: ElevatedButton(
            onPressed: _performAdvancedSearch,
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  Theme.of(context).extension<AppColors>()!.posColor,
              foregroundColor: Colors.black,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
            ),
            child: const Text("SEARCH PLAYERS",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          ),
        ),
      ],
    );
  }

  Widget _buildFilteredList() {
    final appColors = Theme.of(context).extension<AppColors>()!;

    if (_isLoadingFiltered) {
      return Center(
        child: CircularProgressIndicator(color: appColors.posColor),
      );
    }

    if (_filteredResults.isEmpty) {
      return const Center(
        child: Text(
          'No players found matching filters',
          style: TextStyle(color: Colors.grey, fontSize: 16),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _filteredResults.length,
      itemBuilder: (context, index) {
        final player = _filteredResults[index];
        return PlayerCard(
          playerData: player,
          onTap: () => Navigator.pop(context, player),
        );
      },
    );
  }

  Widget _buildSearchResults() {
    final appColors = Theme.of(context).extension<AppColors>()!;

    if (_isLoadingSearch) {
      return Center(
        child: CircularProgressIndicator(color: appColors.posColor),
      );
    }

    if (_searchResults.isEmpty) {
      return const Center(
        child: Text(
          'No players found',
          style: TextStyle(color: Colors.grey, fontSize: 16),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _searchResults.length,
      itemBuilder: (context, index) {
        final player = _searchResults[index];
        return PlayerCard(
          playerData: player,
          onTap: () => Navigator.pop(context, player),
        );
      },
    );
  }

  Widget _buildBestPlayersList() {
    final appColors = Theme.of(context).extension<AppColors>()!;

    if (_isLoadingBest) {
      return Center(
        child: CircularProgressIndicator(color: appColors.posColor),
      );
    }

    if (_bestPlayers.isEmpty) {
      return const Center(
        child: Text(
          'No players available',
          style: TextStyle(color: Colors.grey, fontSize: 16),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _bestPlayers.length,
      itemBuilder: (context, index) {
        final player = _bestPlayers[index];
        return PlayerCard(
          playerData: player,
          onTap: () => Navigator.pop(context, player),
        );
      },
    );
  }

  Widget _buildFavoritesList(List<int> favoriteIds) {
    if (favoriteIds.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.favorite_border, size: 64, color: Colors.grey[700]),
            const SizedBox(height: 16),
            Text(
              'No favorite players yet',
              style: TextStyle(color: Colors.grey[600], fontSize: 16),
            ),
          ],
        ),
      );
    }

    return FutureBuilder<List<Player>>(
      future: _loadFavoritePlayers(favoriteIds),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(
              color: Theme.of(context).extension<AppColors>()!.posColor,
            ),
          );
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(
            child: Text(
              'No favorite players found',
              style: TextStyle(color: Colors.grey, fontSize: 16),
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: snapshot.data!.length,
          itemBuilder: (context, index) {
            final player = snapshot.data![index];
            return PlayerCard(
              playerData: player,
              onTap: () => Navigator.pop(context, player),
            );
          },
        );
      },
    );
  }

  Future<List<Player>> _loadFavoritePlayers(List<int> favoriteIds) async {
    final List<Player> players = [];
    for (final id in favoriteIds) {
      final player = await PlayersDatabase.instance.getPlayerDetails(id);
      if (player != null) {
        players.add(player);
      }
    }
    return players;
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }
}
