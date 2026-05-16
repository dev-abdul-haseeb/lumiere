import 'package:firebase_messaging/firebase_messaging.dart';

class NotificationServices {
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  void listenToTokenRefresh(Function(String token) onToken) {
    messaging.onTokenRefresh.listen((newToken) {
      onToken(newToken);
    });
  }

  Future<String> getDeviceToken() async {
    String? token = await messaging.getToken();
    return token!;
  }
}