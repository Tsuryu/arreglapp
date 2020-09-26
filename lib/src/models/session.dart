// To parse this JSON data, do
//
//     final session = sessionFromJson(jsonString);

import 'dart:convert';

import 'package:arreglapp/src/models/user_profile.dart';

Session sessionFromJson(String str) => Session.fromJson(json.decode(str));

String sessionToJson(UserProfile data) => json.encode(data.toJson());

class Session {
  Session({
    this.userProfile,
    this.jwt,
  });

  UserProfile userProfile;
  String jwt;

  factory Session.fromJson(Map<String, dynamic> json) => Session(jwt: json["jwt"]);

  Map<String, dynamic> toJson() => {"jwt": jwt};
}
