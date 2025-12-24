import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavoritesNotifier extends StateNotifier<List<int>> {
  FavoritesNotifier() : super([]) {
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final favorites = prefs.getStringList('favorite_players') ?? [];
    state = favorites.map((e) => int.parse(e)).toList();
  }

  Future<void> _saveFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
      'favorite_players',
      state.map((e) => e.toString()).toList(),
    );
  }

  void toggleFavorite(int playerId) {
    if (state.contains(playerId)) {
      state = state.where((id) => id != playerId).toList();
    } else {
      state = [...state, playerId];
    }
    _saveFavorites();
  }

  bool isFavorite(int playerId) {
    return state.contains(playerId);
  }
}

final favoritesProvider = StateNotifierProvider<FavoritesNotifier, List<int>>(
  (ref) => FavoritesNotifier(),
);
