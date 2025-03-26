import 'package:flutter/material.dart';
import 'favorites_manager.dart';
import 'notifications.dart';

class PokemonDetail extends StatefulWidget {
  final dynamic pokemon;

  const PokemonDetail({Key? key, required this.pokemon}) : super(key: key);

  @override
  _PokemonDetailState createState() => _PokemonDetailState();
}

class _PokemonDetailState extends State<PokemonDetail> {
  bool isFavorite = false;
  final FavoritesManager _favoritesManager = FavoritesManager();

  @override
  void initState() {
    super.initState();
    _checkIfFavorite();
  }

  Future<void> _checkIfFavorite() async {
    final favorites = await _favoritesManager.loadFavorites();
    setState(() {
      isFavorite = favorites.contains(widget.pokemon['name']);
    });
  }

  void toggleFavorite() async {
    if (isFavorite) {
      await _favoritesManager.removeFavorite(widget.pokemon['name']);
    } else {
      await _favoritesManager.addFavorite(widget.pokemon['name']);
    }

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

  TableRow _buildStatsRow(String label, dynamic value, bool isDarkMode) {
    return TableRow(
      children: [
        _buildStatCell(label, value, isDarkMode),
      ],
    );
  }

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

  Color _getPokemonTypeColor(String type) {
    final Map<String, Color> typeColors = {
      'water': Colors.blue,
      'fire': Colors.red,
      'grass': Colors.green,
      'electric': Colors.yellow.shade700,
      'bug': Colors.lightGreen,
      'ghost': Colors.deepPurple,
      'normal': Colors.grey,
      'psychic': Colors.pink,
      'dark': Colors.black,
      'fairy': Colors.purpleAccent,
      'dragon': Colors.deepOrange,
      'poison': Colors.purple,
      'steel': Colors.blueGrey,
      'fighting': Colors.brown,
      'ice': Colors.cyan,
    };
    return typeColors[type.toLowerCase()] ?? Colors.grey;
  }

  Widget _buildPokemonCard(dynamic pokemon, bool isDarkMode) {
    final types = pokemon['type'] as List;

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
            SizedBox(height: 10),
            Wrap(
              spacing: 8,
              children: types.map<Widget>((type) {
                final color = _getPokemonTypeColor(type);
                return Chip(
                  label: Text(type),
                  backgroundColor: color.withOpacity(0.9),
                  labelStyle: TextStyle(color: Colors.white),
                );
              }).toList(),
            ),
            SizedBox(height: 10),
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _buildPokemonCard(widget.pokemon, isDarkMode),
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
