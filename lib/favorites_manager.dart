import 'package:shared_preferences/shared_preferences.dart';

// Clase para gestionar la lista de Pokémon favoritos utilizando almacenamiento local
class FavoritesManager {
  static const String _key = 'favorite_pokemons';

  // Guarda la lista de Pokémon favoritos en el almacenamiento local
  Future<void> saveFavorites(List<String> favoritePokemons) async {
    final prefs = await SharedPreferences.getInstance(); // Obtiene la instancia de SharedPreferences
    await prefs.setStringList(_key, favoritePokemons); // Guarda la lista de strings con la clave definida
  }

  // Carga la lista de Pokémon favoritos desde el almacenamiento local
  Future<List<String>> loadFavorites() async {
    final prefs = await SharedPreferences.getInstance(); // Obtiene la instancia de SharedPreferences
    return prefs.getStringList(_key) ?? []; // Devuelve la lista almacenada o una lista vacía si no hay datos
  }

  // Agrega un Pokémon a la lista de favoritos si no está ya en la lista
  Future<void> addFavorite(String pokemonName) async {
    final favorites = await loadFavorites(); // Carga la lista actual de favoritos
    if (!favorites.contains(pokemonName)) { // Verifica si el Pokémon ya está en la lista
      favorites.add(pokemonName); // Lo agrega a la lista
      await saveFavorites(favorites); // Guarda la lista actualizada
    }
  }

  // Elimina un Pokémon de la lista de favoritos
  Future<void> removeFavorite(String pokemonName) async {
    final favorites = await loadFavorites(); // Carga la lista actual de favoritos
    favorites.remove(pokemonName); // Elimina el Pokémon de la lista
    await saveFavorites(favorites); // Guarda la lista actualizada
  }
}
