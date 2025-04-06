import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;

void requestNotificationPermission() async {
  NotificationSettings settings =
      await FirebaseMessaging.instance.requestPermission();
  if (settings.authorizationStatus == AuthorizationStatus.authorized) {
    print("User Authorized");
    String? token = await FirebaseMessaging.instance.getToken(
      vapidKey:
          "BPEHbwgVPpCJMGEpnmPyfJwx-QC3uZThNKJ48o3O3sqL7BBHWwF9tDCNYtJjfY_ZGYI1O1_F2CC_NBcpkYotw2M",
    );
    print("Token: $token");
    final res = await http.post(
      Uri.parse("http://127.0.0.1:5000/receive-token"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"token": token}),
    );
    if (res.statusCode == 200) {
      print("Token sent successfully");
    } else {
      print("Error: Token couldn't be sent for some reason");
    }
  } else {
    print("User Rejected the notifications");
  }
}
