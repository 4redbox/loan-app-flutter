import 'package:flutter/material.dart';
import 'api_service.dart';
import 'websocket_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

import 'web_notification_stub.dart'
    if (dart.library.html) 'web_notification.dart'; // Conditional import

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ApiService _apiService = ApiService();
  final WebSocketService _webSocketService = WebSocketService();

  List<String> _items = [];
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    _fetchData();
    _initializeNotifications();
    _webSocketService.connect();

    _webSocketService.onMessageReceived = (newMessage) {
      setState(() {
        _items.add(newMessage);
      });
      _showNotification("New Message", newMessage);
    };
  }

  Future<void> _fetchData() async {
    try {
      List<String> fetchedItems = await _apiService.fetchData();
      setState(() {
        _items = fetchedItems;
      });
    } catch (e) {
      // Handle API fetch error (no debug prints)
    }
  }

  @override
  void dispose() {
    _webSocketService.closeConnection();
    super.dispose();
  }

  void _initializeNotifications() {
    if (!kIsWeb) {
      final android = AndroidInitializationSettings('@mipmap/ic_launcher');
      final iOS = DarwinInitializationSettings();
      final settings = InitializationSettings(android: android, iOS: iOS);
      _notificationsPlugin.initialize(settings);
    }
  }

  void _showNotification(String title, String body) {
    if (kIsWeb) {
      showWebNotification(title, body);
    } else {
      _showMobileNotification(title, body);
    }
  }

  void _showMobileNotification(String title, String body) async {
    if (!kIsWeb) {
      const androidDetails = AndroidNotificationDetails(
        'channel_id',
        'channel_name',
        importance: Importance.max,
        priority: Priority.high,
      );

      const iOSDetails = DarwinNotificationDetails();
      const generalNotificationDetails =
          NotificationDetails(android: androidDetails, iOS: iOSDetails);

      await _notificationsPlugin.show(0, title, body, generalNotificationDetails);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Latest Data")),
      body: _items.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _items.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_items[index]),
                );
              },
            ),
    );
  }
}