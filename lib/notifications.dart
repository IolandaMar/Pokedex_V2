import 'package:flutter/material.dart';

void showNotificationDialog(BuildContext context, String message) {
  showDialog(
    context: context,
    barrierDismissible: false, // Evita que es tanqui si es toca fora
    builder: (BuildContext dialogContext) {
      Future.delayed(Duration(seconds: 15), () {
        if (Navigator.of(dialogContext).canPop()) {
          Navigator.of(dialogContext).pop();
        }
      });

      return AlertDialog(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Notificació'),
            IconButton(
              icon: Icon(Icons.close),
              onPressed: () => Navigator.of(dialogContext).pop(),
            ),
          ],
        ),
        content: Text(message),
        actions: [
        ],
      );
    },
  );

  print(message); // Mostra el missatge a la consola
}
