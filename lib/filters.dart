import 'pokemon_model.dart';

List<Pokemon> filterByType(List<Pokemon> pokemonList, String type) {
  return pokemonList.where((pokemon) => pokemon.type.toLowerCase() == type.toLowerCase()).toList();
}
