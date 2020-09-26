import 'dart:convert';

import 'package:arreglapp/src/helpers/util.dart';
import 'package:arreglapp/src/models/user_profile.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class UserProfileServie {
  final String baseUrl = "http://192.168.0.11:8080/user-profile";

  Future<bool> create(BuildContext context, UserProfile userProfile) async {
    try {
      final Map<String, dynamic> data = userProfile.toJson();
      removeNullAndEmptyParams(data);
      var header = {'Content-Type': 'application/json', "Accept": "application/json"};
      final encoding = Encoding.getByName('utf-8');
      final response = await http.post(baseUrl, body: json.encode(data), headers: header, encoding: encoding);

      if (response.statusCode != 201) {
        return false;
      }

      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }
}
