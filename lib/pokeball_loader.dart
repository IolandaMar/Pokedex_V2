import 'package:flutter/material.dart';

class PokeballLoader extends StatefulWidget {
  const PokeballLoader({Key? key}) : super(key: key);

  @override
  _PokeballLoaderState createState() => _PokeballLoaderState();
}

class _PokeballLoaderState extends State<PokeballLoader> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    )..repeat();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: RotationTransition(
        turns: _controller,
        child: Image.asset(
          'assets/pokeball.png', // Assegura't d'afegir aquesta imatge al projecte.
          width: 60,
          height: 60,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
