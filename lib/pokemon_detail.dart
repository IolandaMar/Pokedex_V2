import 'package:flutter/material.dart';
import 'favorites_manager.dart'; // Importa el teu gestor de favorits
import 'notifications.dart'; // Importem el popup de notificació

class PokemonDetail extends StatefulWidget {
  final dynamic pokemon;

  const PokemonDetail({Key? key, required this.pokemon}) : super(key: key);

  @override
  _PokemonDetailState createState() => _PokemonDetailState();
}

class _PokemonDetailState extends State<PokemonDetail> {
  bool isFavorite = false; // Estat per saber si el Pokémon està en favorits
  final FavoritesManager _favoritesManager = FavoritesManager();

  @override
  void initState() {
    super.initState();
    _checkIfFavorite();
  }

  // Comprova si el Pokémon ja està a favorits
  Future<void> _checkIfFavorite() async {
    final favorites = await _favoritesManager.loadFavorites();
    setState(() {
      isFavorite = favorites.contains(widget.pokemon['name']);
    });
  }

  // Toggle favorite: Afegir o eliminar de favorits
  void toggleFavorite() async {
    if (isFavorite) {
      await _favoritesManager.removeFavorite(widget.pokemon['name']);
    } else {
      await _favoritesManager.addFavorite(widget.pokemon['name']);
    }

    // Actualitza l'estat per mostrar si està afegit o eliminat
    setState(() {
      isFavorite = !isFavorite;
    });

    showNotificationDialog(
      context,
      isFavorite
          ? '${widget.pokemon['name']} afegit a favorits!'
          : '${widget.pokemon['name']} eliminat de favorits!',
    );
  }

  // Funció per crear una fila de la taula de les estadístiques
  TableRow _buildStatsRow(String label, dynamic value, bool isDarkMode) {
    return TableRow(
      children: [
        _buildStatCell(label, value, isDarkMode),
      ],
    );
  }

  // Funció per crear les cel·les de les estadístiques
  Widget _buildStatCell(String label, dynamic value, bool isDarkMode) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: isDarkMode ? Colors.white70 : Colors.black,
            ),
          ),
          SizedBox(height: 4),
          Text(
            value.toString(),
            style: TextStyle(
              fontSize: 16,
              color: isDarkMode ? Colors.white : Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  // Funció per crear la targeta del Pokémon
  Widget _buildPokemonCard(dynamic pokemon, bool isDarkMode) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 8,
      color: isDarkMode ? Colors.grey[900] : Colors.white,
      shadowColor: isDarkMode ? Colors.black54 : Colors.black26,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Image.network(
              pokemon['image'],
              height: 150,
              width: 150,
              fit: BoxFit.cover,
            ),
            SizedBox(height: 20),
            Text(
              pokemon['name'].toUpperCase(),
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: isDarkMode ? Colors.white : Colors.black,
              ),
            ),
            SizedBox(height: 6),
            Text(
              'Tipus: ${pokemon['type']}',
              style: TextStyle(
                fontSize: 16,
                color: isDarkMode ? Colors.white70 : Colors.black,
              ),
            ),
            Text(
              'Alçada: ${pokemon['height']} m',
              style: TextStyle(
                fontSize: 16,
                color: isDarkMode ? Colors.white70 : Colors.black,
              ),
            ),
            Text(
              'Pes: ${pokemon['weight']} kg',
              style: TextStyle(
                fontSize: 16,
                color: isDarkMode ? Colors.white70 : Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final stats = widget.pokemon['stats'] ?? {};

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.pokemon['name']),
        actions: [
          IconButton(
            icon: Icon(Icons.favorite, color: isFavorite ? Colors.red : Colors.white),
            onPressed: toggleFavorite,
          ),
        ],
      ),
      backgroundColor: isDarkMode ? Colors.black : Colors.white,
      body: SingleChildScrollView( // Solució overflow
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _buildPokemonCard(widget.pokemon, isDarkMode), // Targeta del Pokémon
            SizedBox(height: 20),
            Text(
              'Estadístiques:',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: isDarkMode ? Colors.white : Colors.black,
              ),
            ),
            SizedBox(height: 10),
            Table(
              border: TableBorder.all(
                width: 1,
                color: isDarkMode ? Colors.white38 : Colors.black26,
              ),
              children: [
                _buildStatsRow('HP', stats['hp'], isDarkMode),
                _buildStatsRow('Atac', stats['attack'], isDarkMode),
                _buildStatsRow('Defensa', stats['defense'], isDarkMode),
                _buildStatsRow('Velocitat', stats['speed'], isDarkMode),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
