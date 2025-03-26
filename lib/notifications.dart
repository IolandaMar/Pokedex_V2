import 'package:flutter/material.dart'; // Importa el paquet de Flutter per a la interfície d'usuari

// Funció per mostrar un diàleg de notificació
void showNotificationDialog(BuildContext context, String message) {
  showDialog(
    context: context,
    barrierDismissible: false, // Evita que l'usuari pugui tancar el diàleg tocant fora
    builder: (BuildContext dialogContext) {

      // Tanca automàticament el diàleg després de 15 segons
      Future.delayed(Duration(seconds: 15), () {
        if (Navigator.of(dialogContext).canPop()) { // Comprova si es pot tancar el diàleg
          Navigator.of(dialogContext).pop(); // Tanca el diàleg
        }
      });

      return AlertDialog(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween, // Separa el text i el botó de tancar
          children: [
            Text('Notificació'), // Títol del diàleg
            IconButton(
              icon: Icon(Icons.close), // Icona per tancar el diàleg manualment
              onPressed: () => Navigator.of(dialogContext).pop(), // Tanca el diàleg en prémer la icona
            ),
          ],
        ),
        content: Text(message), // Missatge de la notificació
        actions: [
          // No hi ha botons d'acció addicionals
        ],
      );
    },
  );

  print(message); // Mostra el missatge a la consola per depuració
}
