import 'dart:convert';

import 'package:arreglapp/src/models/user_profile.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class UserProfileServie {
  final baseUrl = "http://192.168.0.11:8080/user-profile";

  Future<UserProfile> findBy(BuildContext context, String username, String password) async {
    final response = await http.get('$baseUrl/$username');
    final decodedData = json.decode(response.body);

    return UserProfile.fromJson(decodedData);
  }
}
