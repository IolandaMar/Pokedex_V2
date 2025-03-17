class Pokemon {
  final String name;
  final String image;
  final String type;

  Pokemon({
    required this.name,
    required this.image,
    required this.type,
  });

  factory Pokemon.fromJson(Map<String, dynamic> json) {
    return Pokemon(
      name: json['name'] ?? 'Desconegut',
      image: json['sprites']?['front_default'] ?? 'https://via.placeholder.com/100', // Imatge per defecte
      type: (json['types'] != null && json['types'].isNotEmpty)
          ? json['types'][0]['type']['name']
          : 'desconegut',
    );
  }
}
