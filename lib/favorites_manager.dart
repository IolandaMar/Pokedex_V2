import 'package:shared_preferences/shared_preferences.dart';

class FavoritesManager {
  static const String _key = 'favorite_pokemons';

  Future<void> saveFavorites(List<String> favoritePokemons) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_key, favoritePokemons);
  }

  Future<List<String>> loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_key) ?? [];
  }

  Future<void> addFavorite(String pokemonName) async {
    final favorites = await loadFavorites();
    if (!favorites.contains(pokemonName)) {
      favorites.add(pokemonName);
      await saveFavorites(favorites);
    }
  }

  Future<void> removeFavorite(String pokemonName) async {
    final favorites = await loadFavorites();
    favorites.remove(pokemonName);
    await saveFavorites(favorites);
  }
}
