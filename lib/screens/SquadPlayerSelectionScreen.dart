import 'dart:async';
import 'package:fc_stats_24/db/Player.dart';
import 'package:fc_stats_24/db/players22.dart';
import 'package:fc_stats_24/providers/favorites_provider.dart';
import 'package:fc_stats_24/theme.dart';
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
      );

      if (mounted) {
        setState(() {
          _searchResults = results;
          _isLoadingSearch = false;
        });
      }
    });
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
        return _buildPlayerCard(_searchResults[index]);
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
        return _buildPlayerCard(_bestPlayers[index]);
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
            return _buildPlayerCard(snapshot.data![index]);
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

  Widget _buildPlayerCard(Player player) {
    final appColors = Theme.of(context).extension<AppColors>()!;
    final surfaceColor = Theme.of(context).colorScheme.surface;

    return Card(
      color: surfaceColor,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () => Navigator.pop(context, player),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              // Player Image
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: appColors.posColor.withOpacity(0.2),
                ),
                child: ClipOval(
                  child: Image.network(
                    player.playerFaceUrl ?? '',
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Center(
                        child: Text(
                          player.shortName?.substring(0, 1).toUpperCase() ??
                              '?',
                          style: TextStyle(
                            color: appColors.posColor,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(width: 16),
              // Player Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      player.shortName ?? 'Unknown',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      player.clubName ?? 'Free Agent',
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 13,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: appColors.ovrColor,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            '${player.overall}',
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          player.formattedPositions,
                          style: TextStyle(
                            color: appColors.posColor,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Select Icon
              Icon(
                Icons.add_circle_outline,
                color: appColors.posColor,
                size: 28,
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }
}
