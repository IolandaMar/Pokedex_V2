import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  // Variable privada per controlar el mode de tema actual
  ThemeMode _themeMode = ThemeMode.light;

  // Getter per obtenir el mode de tema actual (clar o fosc)
  ThemeMode get themeMode => _themeMode;

  // Getter per obtenir el tema clar personalitzat
  ThemeData get lightTheme => ThemeData.light().copyWith(
    primaryColor: Colors.red, // Color principal del tema clar
  );

  // Getter per obtenir el tema fosc personalitzat
  ThemeData get darkTheme => ThemeData.dark().copyWith(
    primaryColor: Colors.black, // Color principal del tema fosc
  );

  // Funció per alternar entre tema clar i fosc
  void toggleTheme() {
    // Canvia el mode de tema
    _themeMode = (_themeMode == ThemeMode.light) ? ThemeMode.dark : ThemeMode.light;
    // Notifica als "listeners" que el tema ha canviat
    notifyListeners();
  }
}
