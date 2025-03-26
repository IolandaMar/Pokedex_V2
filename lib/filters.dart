import 'pokemon_model.dart'; // Importa el model de dades dels Pokémon

// Filtra una llista de Pokémon segons el seu tipus
List<Pokemon> filterByType(List<Pokemon> pokemonList, String type) {
  return pokemonList
      .where((pokemon) =>
  pokemon.type.toLowerCase() == type.toLowerCase()) // Compara el tipus ignorant majúscules i minúscules
      .toList(); // Converteix el resultat en una llista i el retorna
}
