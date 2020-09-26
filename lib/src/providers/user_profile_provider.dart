import 'package:arreglapp/src/models/session.dart';
import 'package:flutter/material.dart';

class SessionProvider with ChangeNotifier {
  Session _session;

  Session get session => this._session;

  set session(Session value) {
    this._session = value;
    notifyListeners();
  }
}
