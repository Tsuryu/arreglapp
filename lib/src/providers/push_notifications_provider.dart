import 'dart:io';
import 'dart:convert';

import 'package:arreglapp/src/models/push_notification.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class PushNotificationsProvider with ChangeNotifier {
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  String _event;
  String _token;
  PushNotification _pushNotification;

  String get event => this._event;
  String get token => this._token;
  PushNotification get pushNotification => this._pushNotification;

  set event(String value) {
    this._event = value;
  }

  set token(String value) {
    this._token = value;
  }

  set pushNotification(PushNotification value) {
    this._pushNotification = value;
    notifyListeners();
  }

  initNotifications() async {
    _firebaseMessaging.requestNotificationPermissions();

    var token = await _firebaseMessaging.getToken();
    this.token = token;

    _firebaseMessaging.configure(
      // ignore: missing_return
      onMessage: (info) {
        this.event = 'onMessage';
        if (Platform.isAndroid) {
          final pushNotification = pushNotificationFromJson(json.encode(info).replaceAll("\"{\\", "{").replaceAll("}\"}", "}}").replaceAll("\\", ""));
          this.pushNotification = pushNotification;
        }
      },
      // ignore: missing_return
      onLaunch: (info) {},
      // ignore: missing_return
      onResume: (info) {
        this.event = 'onResume';
        if (Platform.isAndroid) {
          final pushNotification = pushNotificationFromJson(json.encode(info).replaceAll("\"{\\", "{").replaceAll("}\"}", "}}").replaceAll("\\", ""));
          this.pushNotification = pushNotification;
        }
      },
    );
  }
}
