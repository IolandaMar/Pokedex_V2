import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'pokemon_api.dart';
import 'favorites_manager.dart';

// Pantalla que mostra la llista de Pokémon favorits
class FavoritesScreen extends StatefulWidget {
  @override
  _FavoritesScreenState createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  List<String> _favoritePokemons = []; // Llista dels noms dels Pokémon favorits
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin; // Plugin per gestionar notificacions locals
  final FavoritesManager _favoritesManager = FavoritesManager(); // Instància per gestionar favorits

  @override
  void initState() {
    super.initState();
    _loadFavorites(); // Carrega els Pokémon favorits quan es carrega la pantalla
    _initializeNotifications(); // Inicialitza les notificacions locals
  }

  // Carrega els Pokémon favorits des de SharedPreferences
  Future<void> _loadFavorites() async {
    final List<String> favorites = await _favoritesManager.loadFavorites();
    setState(() {
      _favoritePokemons = favorites; // Actualitza la llista de favorits a l'estat
    });
  }

  // Inicialitza les notificacions locals
  void _initializeNotifications() {
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    var initializationSettingsAndroid =
    AndroidInitializationSettings('app_icon'); // Defineix la icona de notificació
    var initializationSettings =
    InitializationSettings(android: initializationSettingsAndroid);
    flutterLocalNotificationsPlugin.initialize(initializationSettings); // Inicialitza les notificacions
  }

  // Mostra una notificació quan un Pokémon és afegit als favorits després de 3 segons
  Future<void> _showFavoriteNotification(String pokemonName) async {
    await Future.delayed(Duration(seconds: 3)); // Retarda la notificació 3 segons

    var androidDetails = AndroidNotificationDetails(
      'favorite_channel', // ID del canal de notificació
      'Favorite Pokémon', // Nom del canal
      importance: Importance.high, // Prioritat alta perquè es mostri immediatament
      priority: Priority.high,
    );
    var generalNotificationDetails = NotificationDetails(android: androidDetails);

    flutterLocalNotificationsPlugin.show(
      0, // ID de la notificació
      '$pokemonName ara és el teu favorit!', // Títol de la notificació
      '', // Cos de la notificació (buit en aquest cas)
      generalNotificationDetails,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Pokémon Favorits"), // Títol de la pantalla
      ),
      body: _favoritePokemons.isEmpty
          ? Center(child: Text("Encara no has afegit cap Pokémon als favorits.")) // Missatge si no hi ha favorits
          : ListView.builder(
        itemCount: _favoritePokemons.length, // Nombre de Pokémon favorits
        itemBuilder: (context, index) {
          final pokemonName = _favoritePokemons[index]; // Nom del Pokémon actual

          // Obté la informació del Pokémon des de l'API
          return FutureBuilder<Map<String, dynamic>>(
            future: PokemonAPI.fetchPokemonByName(pokemonName),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator(); // Mostra un indicador de càrrega
              }
              if (!snapshot.hasData) {
                // Si no hi ha dades, només mostra el nom
                return ListTile(
                  title: Text(pokemonName),
                  trailing: Icon(Icons.favorite, color: Colors.red), // Icona de favorit
                );
              }

              final pokemon = snapshot.data!; // Obté les dades del Pokémon

              return ListTile(
                leading: Image.network(pokemon['image'] ?? ''), // Mostra la imatge del Pokémon
                title: Text(pokemonName), // Mostra el nom del Pokémon
                trailing: Icon(Icons.favorite, color: Colors.red), // Icona de favorit
                onTap: () {
                  _showFavoriteNotification(pokemonName); // Mostra la notificació en fer clic
                },
              );
            },
          );
        },
      ),
    );
  }
}
