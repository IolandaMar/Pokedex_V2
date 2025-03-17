import 'dart:convert';
import 'package:http/http.dart' as http;

class PokemonAPI {
  // Método para obtener todos los pokémons
  static Future<List<dynamic>> fetchPokemon({int offset = 0, int limit = 20}) async {
    final response = await http.get(Uri.parse(
        'https://pokeapi.co/api/v2/pokemon?offset=$offset&limit=$limit'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      List<dynamic> pokemonList = data['results'];

      List<dynamic> detailedPokemonList = await Future.wait(
        pokemonList.map((pokemon) async {
          final pokemonDetail = await http.get(Uri.parse(pokemon['url']));
          if (pokemonDetail.statusCode == 200) {
            final detailData = json.decode(pokemonDetail.body);

            return {
              'name': pokemon['name'],
              'image': detailData['sprites']['front_default'] ?? '',
              'url': pokemon['url'],
              'type': detailData['types'][0]['type']['name'] ?? 'desconegut',
              'height': detailData['height'] / 10, // Convertir a metres
              'weight': detailData['weight'] / 10, // Convertir a kg
              'stats': {
                'hp': detailData['stats'][0]['base_stat'],
                'attack': detailData['stats'][1]['base_stat'],
                'defense': detailData['stats'][2]['base_stat'],
                'speed': detailData['stats'][5]['base_stat'],
              },
            };
          }
          return {
            'name': pokemon['name'],
            'image': '',
            'url': pokemon['url'],
            'type': 'desconegut',
            'height': 'desconegut',
            'weight': 'desconegut',
            'stats': {},
          };
        }),
      );

      return detailedPokemonList;
    } else {
      throw Exception('Error carregant Pokémon');
    }
  }

  // Mètode per obtenir la informació d'un Pokémon per nom
  static Future<Map<String, dynamic>> fetchPokemonByName(String pokemonName) async {
    final response = await http.get(Uri.parse('https://pokeapi.co/api/v2/pokemon/$pokemonName'));

    if (response.statusCode == 200) {
      final detailData = json.decode(response.body);
      return {
        'name': detailData['name'],
        'image': detailData['sprites']['front_default'] ?? '',
        'type': detailData['types'][0]['type']['name'] ?? 'desconegut',
        'height': detailData['height'] / 10, // Convertir a metres
        'weight': detailData['weight'] / 10, // Convertir a kg
        'stats': {
          'hp': detailData['stats'][0]['base_stat'],
          'attack': detailData['stats'][1]['base_stat'],
          'defense': detailData['stats'][2]['base_stat'],
          'speed': detailData['stats'][5]['base_stat'],
        },
      };
    } else {
      throw Exception('Error carregant Pokémon per nom');
    }
  }
}
