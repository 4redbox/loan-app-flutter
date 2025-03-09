// web_notification_stub.dart

void showWebNotification(String title, String body) {
  // No-op for non-web platforms
}

Future<bool> requestWebNotificationPermission() async {
  return false; // No notifications on non-web platforms
}