// To parse this JSON data, do
//
//     final userProfile = userProfileFromJson(jsonString);

import 'dart:convert';

UserProfile userProfileFromJson(String str) => UserProfile.fromJson(json.decode(str));

String userProfileToJson(UserProfile data) => json.encode(data.toJson());

class UserProfile {
  UserProfile({
    this.username,
    this.firstName,
    this.lastName,
  });

  String username;
  String firstName;
  String lastName;

  factory UserProfile.fromJson(Map<String, dynamic> json) => UserProfile(
        username: json["username"],
        firstName: json["first_name"],
        lastName: json["last_name"],
      );

  Map<String, dynamic> toJson() => {
        "username": username,
        "first_name": firstName,
        "last_name": lastName,
      };
}
