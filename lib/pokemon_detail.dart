import 'package:flutter/material.dart';

class PokemonDetail extends StatelessWidget {
  final dynamic pokemon;

  const PokemonDetail({Key? key, required this.pokemon}) : super(key: key);

  Widget _buildStatsRow(String label, int value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Text(
            value.toString(),
            style: TextStyle(fontSize: 18),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final stats = pokemon['stats'] ?? {};

    return Scaffold(
      appBar: AppBar(
        title: Text(pokemon['name']),
        backgroundColor: Colors.redAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.network(
              pokemon['image'],
              height: 150,
              width: 150,
              fit: BoxFit.cover,
            ),
            SizedBox(height: 20),
            Text(
              'Tipus: ${pokemon['type']}',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 10),
            Text(
              'Alçada: ${pokemon['height']} m',
              style: TextStyle(fontSize: 20),
            ),
            Text(
              'Pes: ${pokemon['weight']} kg',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 20),
            Text(
              'Estadístiques:',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            _buildStatsRow('HP', stats['hp']),
            _buildStatsRow('Atac', stats['attack']),
            _buildStatsRow('Defensa', stats['defense']),
            _buildStatsRow('Velocitat', stats['speed']),
          ],
        ),
      ),
    );
  }
}

