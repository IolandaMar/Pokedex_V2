import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'pokemon_api.dart';
import 'favorites_manager.dart';

class FavoritesScreen extends StatefulWidget {
  @override
  _FavoritesScreenState createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  List<String> _favoritePokemons = [];
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  final FavoritesManager _favoritesManager = FavoritesManager();

  @override
  void initState() {
    super.initState();
    _loadFavorites();
    _initializeNotifications();
  }

  // Cargar los Pokémon favoritos desde SharedPreferences
  Future<void> _loadFavorites() async {
    final List<String> favorites = await _favoritesManager.loadFavorites();
    setState(() {
      _favoritePokemons = favorites;
    });
  }

  // Inicialització de les notificacions locals
  void _initializeNotifications() {
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    var initializationSettingsAndroid =
    AndroidInitializationSettings('app_icon');
    var initializationSettings =
    InitializationSettings(android: initializationSettingsAndroid);
    flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  // Funció per mostrar la notificació després de 3 segons
  Future<void> _showFavoriteNotification(String pokemonName) async {
    await Future.delayed(Duration(seconds: 3));

    var androidDetails = AndroidNotificationDetails(
      'favorite_channel',
      'Favorite Pokémon',
      importance: Importance.high,
      priority: Priority.high,
    );
    var generalNotificationDetails = NotificationDetails(android: androidDetails);

    flutterLocalNotificationsPlugin.show(
      0,
      '$pokemonName ara és el teu favorit!',
      '',
      generalNotificationDetails,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Pokémon Favorits"),
      ),
      body: _favoritePokemons.isEmpty
          ? Center(child: Text("Encara no has afegit cap Pokémon als favorits."))
          : ListView.builder(
        itemCount: _favoritePokemons.length,
        itemBuilder: (context, index) {
          final pokemonName = _favoritePokemons[index];
          return FutureBuilder<Map<String, dynamic>>(
            future: PokemonAPI.fetchPokemonByName(pokemonName),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              }
              if (!snapshot.hasData) {
                return ListTile(
                  title: Text(pokemonName),
                  trailing: Icon(Icons.favorite, color: Colors.red),
                );
              }
              final pokemon = snapshot.data!;
              return ListTile(
                leading: Image.network(pokemon['image'] ?? ''),
                title: Text(pokemonName),
                trailing: Icon(Icons.favorite, color: Colors.red),
                onTap: () {
                  _showFavoriteNotification(pokemonName);
                },
              );
            },
          );
        },
      ),
    );
  }
}

