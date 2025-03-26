import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'pokemon_api.dart';
import 'pokemon_detail.dart';
import 'favorites_manager.dart';
import 'theme_provider.dart';
import 'pokemon_comparator.dart';
import 'favorites_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math';

class PokedexScreen extends StatefulWidget {
  const PokedexScreen({Key? key}) : super(key: key);

  @override
  _PokedexScreenState createState() => _PokedexScreenState();
}

class _PokedexScreenState extends State<PokedexScreen> {
  List<dynamic> _pokemonList = [];
  List<dynamic> _filteredPokemonList = [];
  bool _isLoading = true;
  bool _isGridView = true;
  TextEditingController _searchController = TextEditingController();
  int _offset = 0;
  final int _limit = 20;

  // Pokémon seleccionats per comparar
  dynamic _selectedPokemon1;
  dynamic _selectedPokemon2;

  // Filtres
  String? _selectedType;
  final List<String> _types = [
    'All',
    'water',
    'fire',
    'grass',
    'electric',
    'bug',
    'ghost',
    'normal',
    'psychic',
    'dark',
    'fairy',
    'dragon',
    'poison',
    'steel',
    'fighting',
    'ice'
  ];

  @override
  void initState() {
    super.initState();
    _fetchPokemon();
  }

  Future<void> _fetchPokemon() async {
    List<dynamic> pokemonList =
    await PokemonAPI.fetchPokemon(offset: _offset, limit: _limit);
    setState(() {
      _pokemonList.addAll(pokemonList);
      _filteredPokemonList = _pokemonList;
      _isLoading = false;
    });
  }

  void _loadMorePokemon() {
    setState(() {
      _offset += _limit;
      _fetchPokemon();
    });
  }

  void _comparePokemons() {
    if (_selectedPokemon1 != null && _selectedPokemon2 != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              PokemonComparator(
                firstPokemon: _selectedPokemon1,
                secondPokemon: _selectedPokemon2,
              ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Selecciona dos Pokémon per comparar!")),
      );
    }
  }

  void _sortPokemonAlphabetically() {
    setState(() {
      _filteredPokemonList.sort((a, b) => a['name'].compareTo(b['name']));
    });
  }

  void _selectRandomPokemon() {
    Random random = Random();
    setState(() {
      _selectedPokemon1 =
      _filteredPokemonList[random.nextInt(_filteredPokemonList.length)];
    });
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PokemonDetail(pokemon: _selectedPokemon1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme
        .of(context)
        .brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pokédex'),
        backgroundColor: isDarkMode ? Colors.black87 : Colors.white,
        iconTheme:
        IconThemeData(color: isDarkMode ? Colors.white : Colors.black),
        actions: [
          IconButton(
            icon: Icon(_isGridView ? Icons.list : Icons.grid_view),
            onPressed: () {
              setState(() {
                _isGridView = !_isGridView;
              });
            },
          ),
          IconButton(
            icon: Icon(Icons.favorite, color: Colors.red),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => FavoritesScreen()),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.compare_arrows),
            onPressed: _comparePokemons,
          ),
          IconButton(
            icon: Icon(Icons.dark_mode),
            onPressed: () =>
                Provider.of<ThemeProvider>(context, listen: false)
                    .toggleTheme(),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    onChanged: (query) {
                      setState(() {
                        _filteredPokemonList = _pokemonList
                            .where((pokemon) =>
                            pokemon['name']
                                .toLowerCase()
                                .contains(query.toLowerCase()))
                            .toList();
                      });
                    },
                    decoration: InputDecoration(
                      hintText: "Busca un Pokémon...",
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                // Selector de tipus
                DropdownButton<String>(
                  value: _selectedType,
                  hint: Text("Selecciona tipus"),
                  items: _types.map((String type) {
                    return DropdownMenuItem<String>(
                      value: type,
                      child: Text(type),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedType = value;
                      if (_selectedType == 'All') {
                        _filteredPokemonList = _pokemonList;
                      } else {
                        _filteredPokemonList = _pokemonList
                            .where((pokemon) =>
                            pokemon['type'].contains(_selectedType))
                            .toList();
                      }
                    });
                  },
                ),
              ],
            ),
          ),
          Row(
            children: [
              IconButton(
                icon: Icon(Icons.sort_by_alpha),
                onPressed: _sortPokemonAlphabetically,
              ),
              IconButton(
                icon: Icon(Icons.casino),
                onPressed: _selectRandomPokemon,
              ),
            ],
          ),
          Expanded(
            child: _isLoading
                ? Center(child: CircularProgressIndicator())
                : _isGridView
                ? _buildGridView(isDarkMode)
                : _buildListView(isDarkMode),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: _loadMorePokemon,
              child: Text("Carregar més Pokémon"),
              style: ElevatedButton.styleFrom(
                backgroundColor: isDarkMode ? Colors.red.shade900 : Colors.red,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGridView(bool isDarkMode) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: _filteredPokemonList.length,
      itemBuilder: (context, index) {
        final pokemon = _filteredPokemonList[index];
        return _buildPokemonCard(pokemon, isDarkMode);
      },
    );
  }

  Widget _buildListView(bool isDarkMode) {
    return ListView.separated(
      itemCount: _filteredPokemonList.length,
      separatorBuilder: (context, index) => SizedBox(height: 16),
      itemBuilder: (context, index) {
        final pokemon = _filteredPokemonList[index];
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: _buildPokemonCard(pokemon, isDarkMode),
        );
      },
    );
  }

  Widget _buildPokemonCard(dynamic pokemon, bool isDarkMode) {
    bool isSelected = pokemon == _selectedPokemon1 || pokemon == _selectedPokemon2;

    // Llista de tipus
    List<String> types = [];
    if (pokemon['type'] is List) {
      types = List<String>.from(pokemon['type']);
    } else if (pokemon['type'] is String) {
      types = [pokemon['type']];
    }

    List<Color> borderColors = types.map((type) => _getPokemonTypeBorderColor(type)).toList();
    if (borderColors.length == 1) borderColors.add(borderColors.first);

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PokemonDetail(pokemon: pokemon),
          ),
        );
      },
      onLongPress: () {
        setState(() {
          if (_selectedPokemon1 == null) {
            _selectedPokemon1 = pokemon;
          } else if (_selectedPokemon2 == null && _selectedPokemon1 != pokemon) {
            _selectedPokemon2 = pokemon;
          } else {
            _selectedPokemon1 = pokemon;
            _selectedPokemon2 = null;
          }
        });
      },
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: borderColors),
          borderRadius: BorderRadius.circular(20),
        ),
        padding: EdgeInsets.all(4),
        child: Container(
          decoration: BoxDecoration(
            color: isSelected
                ? Colors.amber.withOpacity(0.25) // 🔁 color per OnLongPress (seleccionat)
                : (isDarkMode ? Colors.grey[900] : Colors.grey[100]),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: isDarkMode ? Colors.black54 : Colors.grey.withOpacity(0.3),
                blurRadius: 6,
                offset: Offset(2, 4),
              ),
            ],
          ),
          padding: EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.network(pokemon['image'], height: 100, width: 100),
              SizedBox(height: 10),
              Text(
                pokemon['name'],
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: isDarkMode ? Colors.white : Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getPokemonTypeBorderColor(String type) {
    Map<String, Color> typeBorderColors = {
      'water': Colors.blue,
      'fire': Colors.red,
      'grass': Colors.green,
      'electric': Colors.yellow,
      'bug': Colors.lightGreen,
      'ghost': Colors.deepPurple,
      'normal': Colors.grey,
      'psychic': Colors.pink,
      'dark': Colors.black,
      'fairy': Colors.purple,
      'dragon': Colors.deepOrange,
      'poison': Colors.purpleAccent,
      'steel': Colors.blueGrey,
      'fighting': Colors.brown,
      'ice': Colors.cyan,
    };

    return typeBorderColors[type.toLowerCase()] ?? Colors.grey;
  }
}
