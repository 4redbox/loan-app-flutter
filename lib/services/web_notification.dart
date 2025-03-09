import 'dart:html';

void showWebNotification(String title, String body) {
  if (Notification.permission == "granted") {
    Notification(title, body: body);
  } else {
    Notification.requestPermission().then((permission) {
      if (permission == "granted") {
        Notification(title, body: body);
      }
    });
  }
}