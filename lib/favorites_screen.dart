import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'pokemon_api.dart';
import 'favorites_manager.dart';
import 'pokemon_detail.dart';

// Pantalla que mostra la llista de Pokémon favorits
class FavoritesScreen extends StatefulWidget {
  @override
  _FavoritesScreenState createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  List<String> _favoritePokemons = []; // Llista dels noms dels Pokémon favorits
  final FavoritesManager _favoritesManager = FavoritesManager(); // Instància per gestionar favorits

  @override
  void initState() {
    super.initState();
    _loadFavorites(); // Carrega els Pokémon favorits quan es carrega la pantalla
  }

  // Carrega els Pokémon favorits des de SharedPreferences
  Future<void> _loadFavorites() async {
    final List<String> favorites = await _favoritesManager.loadFavorites();
    setState(() {
      _favoritePokemons = favorites; // Actualitza la llista de favorits a l'estat
    });
  }

  // Mostra una notificació quan un Pokémon és afegit als favorits després de 3 segons
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Pokémon Favorits"), // Títol de la pantalla
      ),
      body: _favoritePokemons.isEmpty
          ? Center(child: Text("Encara no has afegit cap Pokémon als favorits.")) // Missatge si no hi ha favorits
          : ListView.builder(
        itemCount: _favoritePokemons.length, // Nombre de Pokémon favorits
        itemBuilder: (context, index) {
          final pokemonName = _favoritePokemons[index]; // Nom del Pokémon actual

          // Obté la informació del Pokémon des de l'API
          return FutureBuilder<Map<String, dynamic>>(
            future: PokemonAPI.fetchPokemonByName(pokemonName),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator(); // Mostra un indicador de càrrega
              }
              if (!snapshot.hasData) {
                // Si no hi ha dades, només mostra el nom
                return ListTile(
                  title: Text(pokemonName),
                  trailing: Icon(Icons.favorite, color: Colors.red), // Icona de favorit
                );
              }

              final pokemon = snapshot.data!; // Obté les dades del Pokémon

              return ListTile(
                leading: Image.network(pokemon['image'] ?? ''), // Mostra la imatge del Pokémon
                title: Text(pokemonName), // Mostra el nom del Pokémon
                trailing: Icon(Icons.favorite, color: Colors.red), // Icona de favorit
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PokemonDetail(pokemon: pokemon),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
