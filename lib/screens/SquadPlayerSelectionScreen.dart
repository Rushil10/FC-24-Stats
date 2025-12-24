import 'dart:async';
import 'package:fc_stats_24/db/Player.dart';
import 'package:fc_stats_24/db/players22.dart';
import 'package:fc_stats_24/providers/favorites_provider.dart';
import 'package:fc_stats_24/theme.dart';
import 'package:fc_stats_24/components/playerCard.dart';
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
  bool _isLoadingSearch = false;
  bool _isLoadingBest = false;
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
    _tabController = TabController(length: 2, vsync: this);
    _loadBestPlayers();
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
              ],
            ),
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
