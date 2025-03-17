import 'package:flutter/material.dart';

class PokemonComparator extends StatefulWidget {
  final dynamic firstPokemon;
  final dynamic secondPokemon;

  const PokemonComparator({
    Key? key,
    required this.firstPokemon,
    required this.secondPokemon,
  }) : super(key: key);

  @override
  _PokemonComparatorState createState() => _PokemonComparatorState();
}

class _PokemonComparatorState extends State<PokemonComparator> {
  TableRow _buildStatRow(
      String label, dynamic firstValue, dynamic secondValue, bool isDarkMode) {
    return TableRow(
      children: [
        _buildStatCell(label, firstValue, isDarkMode),
        _buildStatCell(label, secondValue, isDarkMode),
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
              height: 120,
              width: 120,
              fit: BoxFit.cover,
            ),
            SizedBox(height: 10),
            Text(
              pokemon['name'].toUpperCase(),
              style: TextStyle(
                fontSize: 20,
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
    final firstStats = widget.firstPokemon['stats'] ?? {};
    final secondStats = widget.secondPokemon['stats'] ?? {};

    return Scaffold(
      appBar: AppBar(
        title: Text('Comparació de Pokémon'),
        backgroundColor: isDarkMode ? Colors.black87 : Colors.redAccent,
      ),
      backgroundColor: isDarkMode ? Colors.black : Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Comparant ${widget.firstPokemon['name']} i ${widget.secondPokemon['name']}',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: isDarkMode ? Colors.white : Colors.black,
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(child: _buildPokemonCard(widget.firstPokemon, isDarkMode)),
                SizedBox(width: 10),
                Expanded(child: _buildPokemonCard(widget.secondPokemon, isDarkMode)),
              ],
            ),
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
                _buildStatRow('HP', firstStats['hp'], secondStats['hp'], isDarkMode),
                _buildStatRow('Atac', firstStats['attack'], secondStats['attack'], isDarkMode),
                _buildStatRow('Defensa', firstStats['defense'], secondStats['defense'], isDarkMode),
                _buildStatRow('Velocitat', firstStats['speed'], secondStats['speed'], isDarkMode),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
