import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:convert';

import 'web_notification_stub.dart' 
    if (dart.library.html) 'web_notification.dart'; // Conditional Import

class WebSocketService {
  final String _url =
      "wss://e0ovj92vd7.execute-api.ap-south-2.amazonaws.com/production/";
  WebSocketChannel? _channel;
  Function(String)? onMessageReceived;

  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  WebSocketService() {
    if (!kIsWeb) {
      _initializeNotifications();
    }
  }

  void connect() {
    try {
      _channel = WebSocketChannel.connect(Uri.parse(_url));

      _channel!.stream.listen(
        (message) {
          try {

            final data = json.decode(message);
            if (data is Map<String, dynamic> && data.containsKey("message")) {
              String extractedMessage = data["message"];
              print('WebSocket Message: $extractedMessage');
              if (onMessageReceived != null) {
                onMessageReceived!(extractedMessage);
              }
              _showNotification("New Message", extractedMessage);
            } else {
              print('Received unexpected WebSocket data format');
            }
          } catch (e) {
              print('Error parsing WebSocket message: $e');
          }
    },
    onError: (error) {
    print('WebSocket Error: $error');
    },
    onDone: () {
    print('WebSocket Disconnected');
    _reconnect();
    },
    );
    } catch (e) {
      print('WebSocket Connection Failed: $e');
    }
  }

  void sendMessage(String message) {
    if (_channel != null) {
      _channel!.sink.add(message);
    } else {
      print('WebSocket is not connected');
    }
  }

  void closeConnection() {
    _channel?.sink.close();
    _channel = null;
  }

  void _showNotification(String title, String body) {
    if (kIsWeb) {
      showWebNotification(title, body);
    } else {
      _showMobileNotification(title, body);
    }
  }

  void _initializeNotifications() {
    if (!kIsWeb) {
      final android = AndroidInitializationSettings('@mipmap/ic_launcher');
      final iOS = DarwinInitializationSettings();
      final settings = InitializationSettings(android: android, iOS: iOS);

      _notificationsPlugin.initialize(settings);
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

  void _reconnect() {
    Future.delayed(Duration(seconds: 5), () {
      print('Reconnecting WebSocket...');
      connect();
    });
  }
}