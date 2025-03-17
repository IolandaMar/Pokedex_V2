import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'pokedex.dart';
import 'theme_provider.dart';
import 'notifications.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  NotificationService().initNotifications(); // Inicialitzem notificacions
  runApp(const PokedexApp());
}

class PokedexApp extends StatelessWidget {
  const PokedexApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: themeProvider.lightTheme,
            darkTheme: themeProvider.darkTheme,
            themeMode: themeProvider.themeMode,
            home: const PokedexScreen(),
          );
        },
      ),
    );
  }
}
