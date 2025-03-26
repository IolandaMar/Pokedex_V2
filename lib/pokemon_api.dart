import 'dart:convert';
import 'package:http/http.dart' as http;

class PokemonAPI {
  // Mètode per obtenir tots els Pokémon amb paginació (offset i limit)
  static Future<List<dynamic>> fetchPokemon({int offset = 0, int limit = 20}) async {
    // Realitza una petició HTTP per obtenir la llista de Pokémon
    final response = await http.get(Uri.parse(
        'https://pokeapi.co/api/v2/pokemon?offset=$offset&limit=$limit'));

    if (response.statusCode == 200) {
      // Si la petició és exitosa, decodeja la resposta JSON
      final data = json.decode(response.body);
      List<dynamic> pokemonList = data['results']; // Llista de Pokémon obtinguda

      // Obté la informació detallada de cada Pokémon de la llista
      List<dynamic> detailedPokemonList = await Future.wait(
        pokemonList.map((pokemon) async {
          final pokemonDetail = await http.get(Uri.parse(pokemon['url']));
          if (pokemonDetail.statusCode == 200) {
            final detailData = json.decode(pokemonDetail.body);

            // Retorna la informació detallada de cada Pokémon
            return {
              'name': pokemon['name'], // Nom del Pokémon
              'image': detailData['sprites']['front_default'] ?? '', // Imatge del Pokémon
              'url': pokemon['url'], // URL del Pokémon
              'type': (detailData['types'] as List)
                  .map((t) => t['type']['name'].toString())
                  .toList(),
              'height': detailData['height'] / 10, // Alçada del Pokémon (en metres)
              'weight': detailData['weight'] / 10, // Pes del Pokémon (en quilos)
              'stats': {
                'hp': detailData['stats'][0]['base_stat'], // Stats del Pokémon
                'attack': detailData['stats'][1]['base_stat'],
                'defense': detailData['stats'][2]['base_stat'],
                'speed': detailData['stats'][5]['base_stat'],
              },
            };
          }
          // Si la petició de detall falla, retorna valors per defecte
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

      // Retorna la llista de Pokémon detallats
      return detailedPokemonList;
    } else {
      // Si la petició falla, llança una excepció
      throw Exception('Error carregant Pokémon');
    }
  }

  // Mètode per obtenir la informació d'un Pokémon per nom
  static Future<Map<String, dynamic>> fetchPokemonByName(String pokemonName) async {
    // Realitza una petició HTTP per obtenir el detall d'un Pokémon per nom
    final response = await http.get(Uri.parse('https://pokeapi.co/api/v2/pokemon/$pokemonName'));

    if (response.statusCode == 200) {
      // Si la petició és exitosa, decodeja la resposta JSON
      final detailData = json.decode(response.body);
      // Retorna la informació detallada del Pokémon
      return {
        'name': detailData['name'], // Nom del Pokémon
        'image': detailData['sprites']['front_default'] ?? '', // Imatge del Pokémon
        'type': detailData['types'][0]['type']['name'] ?? 'desconegut', // Tipus del Pokémon
        'height': detailData['height'] / 10, // Alçada del Pokémon (en metres)
        'weight': detailData['weight'] / 10, // Pes del Pokémon (en quilos)
        'stats': {
          'hp': detailData['stats'][0]['base_stat'], // Stats del Pokémon
          'attack': detailData['stats'][1]['base_stat'],
          'defense': detailData['stats'][2]['base_stat'],
          'speed': detailData['stats'][5]['base_stat'],
        },
      };
    } else {
      // Si la petició falla, llança una excepció
      throw Exception('Error carregant Pokémon per nom');
    }
  }
}
