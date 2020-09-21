import 'package:arreglapp/src/models/user_profile.dart';
import 'package:flutter/material.dart';

class UserProfileProvider with ChangeNotifier {
  UserProfile _userProfile;

  UserProfile get userProfile => this._userProfile;

  set userProfile(UserProfile value) {
    this._userProfile = value;
    notifyListeners();
  }
}
