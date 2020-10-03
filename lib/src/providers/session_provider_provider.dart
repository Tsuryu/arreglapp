import 'package:arreglapp/src/models/session.dart';
import 'package:arreglapp/src/models/user_profile.dart';
import 'package:flutter/material.dart';

class SessionProvider with ChangeNotifier {
  Session _session;
  UserProfile _userProfile = UserProfile();

  Session get session => this._session;
  UserProfile get userProfile => this._userProfile;

  set session(Session value) {
    this._session = value;
    notifyListeners();
  }

  set userProfile(UserProfile value) {
    this._userProfile = value;
  }
}
