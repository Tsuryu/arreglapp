import 'dart:async';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class PushNotificationsProvider with ChangeNotifier {
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  String _message;

  String get message => this._message;

  set message(String value) {
    this._message = value;
    notifyListeners();
  }

  initNotifications() async {
    _firebaseMessaging.requestNotificationPermissions();

    var token = await _firebaseMessaging.getToken();
    print(token);

    _firebaseMessaging.configure(
      onMessage: (info) {
        print('onMessage: $info');
        if (Platform.isAndroid) {
          message = info['data']['jobRequest'] ?? 'no-data';
        }
      },
      onLaunch: (info) {
        print('onLaunch: $info');
      },
      onResume: (info) {
        print('onResume: $info');
        if (Platform.isAndroid) {
          message = info['data']['jobRequest'] ?? 'no-data';
        }
      },
    );
  }
}
