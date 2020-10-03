// To parse this JSON data, do
//
//     final userProfile = userProfileFromJson(jsonString);

import 'dart:convert';

UserProfile userProfileFromJson(String str) => UserProfile.fromJson(json.decode(str));

String userProfileToJson(UserProfile data) => json.encode(data.toJson());

class UserProfile {
  UserProfile({
    this.username,
    this.password,
    this.firstName,
    this.lastName,
    this.email,
    this.phone,
    this.city,
    this.address,
  });

  String username;
  String password;
  String firstName;
  String lastName;
  String email;
  String phone;
  String city;
  String address;

  factory UserProfile.fromJson(Map<String, dynamic> json) => UserProfile(
        username: json["username"],
        password: json["password"],
        firstName: json["first_name"],
        lastName: json["last_name"],
        email: json["email"],
        phone: json["phone"],
        city: json["city"],
        address: json["address"],
      );

  Map<String, dynamic> toJson() => {
        "username": username,
        "password": password,
        "first_name": firstName,
        "last_name": lastName,
        "email": email,
        "phone": phone,
        "city": city,
        "address": address,
      };
}
