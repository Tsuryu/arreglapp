import 'dart:async';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class PushNotificationsProvider with ChangeNotifier {
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  String _message;
  String _event;
  String _token;

  String get message => this._message;
  String get event => this._event;
  String get token => this._token;

  set message(String value) {
    this._message = value;
    notifyListeners();
  }

  set event(String value) {
    this._event = value;
  }

  set token(String value) {
    this._token = value;
  }

  initNotifications() async {
    _firebaseMessaging.requestNotificationPermissions();

    var token = await _firebaseMessaging.getToken();
    this.token = token;

    _firebaseMessaging.configure(
      onMessage: (info) {
        this.event = 'onMessage';
        if (Platform.isAndroid) {
          message = info['data']['job_request'] ?? 'no-data';
        }
      },
      onLaunch: (info) {
        print('onLaunch: $info');
      },
      onResume: (info) {
        this.event = 'onResume';
        if (Platform.isAndroid) {
          message = info['data']['job_request'] ?? 'no-data';
        }
      },
    );
  }
}
