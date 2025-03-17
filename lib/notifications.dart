import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
  FlutterLocalNotificationsPlugin();

  void initNotifications() {
    final settings = InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
    );
    _notificationsPlugin.initialize(settings);
  }

  void showNotification(String pokemonName) {
    _notificationsPlugin.show(
      0,
      "Pokédex",
      "$pokemonName ara és el teu favorit!",
      NotificationDetails(
        android: AndroidNotificationDetails(
          'channel_id',
          'Pokédex Notificacions',
          importance: Importance.high,
        ),
      ),
    );
  }
}
