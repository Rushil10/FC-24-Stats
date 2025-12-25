import 'package:fc_stats_24/db/players22.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FavoritesNotifier extends StateNotifier<List<int>> {
  FavoritesNotifier() : super([]) {
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    final favorites = await PlayersDatabase.instance.getFavourites();
    state = favorites.map((p) => p.id!).toList();
  }

  Future<void> toggleFavorite(int playerId) async {
    await PlayersDatabase.instance.searchFavourites(playerId);

    // Update local state to reflect change immediately
    if (state.contains(playerId)) {
      state = state.where((id) => id != playerId).toList();
    } else {
      state = [...state, playerId];
    }
  }

  bool isFavorite(int playerId) {
    return state.contains(playerId);
  }
}

final favoritesProvider = StateNotifierProvider<FavoritesNotifier, List<int>>(
  (ref) => FavoritesNotifier(),
);
