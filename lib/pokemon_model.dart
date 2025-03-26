class Pokemon {
  final String name;
  final String image;
  final String type;

  // Constructor que inicialitza els valors de la classe Pokémon
  Pokemon({
    required this.name,
    required this.image,
    required this.type,
  });

  // Mètode factory que crea una instància de Pokémon a partir d'un objecte JSON
  factory Pokemon.fromJson(Map<String, dynamic> json) {
    return Pokemon(
      // Si no hi ha valor per 'name', es posa 'Desconegut' per defecte
      name: json['name'] ?? 'Desconegut',

      // Si no hi ha imatge disponible, es posa una imatge per defecte
      image: json['sprites']?['front_default'] ?? 'https://via.placeholder.com/100',

      // Si no es troba el tipus, es retorna 'desconegut'
      type: (json['types'] != null && json['types'].isNotEmpty)
          ? json['types'][0]['type']['name']
          : 'desconegut',
    );
  }
}
