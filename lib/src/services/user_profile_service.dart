import 'dart:convert';

import 'package:arreglapp/src/helpers/util.dart';
import 'package:arreglapp/src/models/user_profile.dart';
import 'package:http/http.dart' as http;
import 'package:arreglapp/constants/constants.dart' as Constants;

class UserProfileService {
  Future<String> create(UserProfile userProfile) async {
    try {
      final Map<String, dynamic> data = userProfile.toJson();
      removeNullAndEmptyParams(data);
      var header = {'Content-Type': 'application/json', "Accept": "application/json"};
      final encoding = Encoding.getByName('utf-8');
      final response = await http.post(Constants.BASE_URL_USER_PROFILE, body: json.encode(data), headers: header, encoding: encoding);

      if (response.statusCode == 201) {
        final decodedData = json.decode(response.body);
        return decodedData["trace_id"];
      }

      return null;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<bool> activate(String traceId, String otp, UserProfile userProfile) async {
    try {
      var header = {
        'Content-Type': 'application/json',
        "Accept": "application/json",
        "trace-id": traceId,
        "security-code": otp,
      };
      final encoding = Encoding.getByName('utf-8');
      final response = await http.put("${Constants.BASE_URL_USER_PROFILE}/${userProfile.username}/activate", headers: header, encoding: encoding);

      if (response.statusCode != 200) {
        return false;
      }

      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<String> resetPassword(String email) async {
    try {
      final Map<String, dynamic> data = Map<String, String>();
      data.putIfAbsent("email", () => email);
      var header = {'Content-Type': 'application/json', "Accept": "application/json"};
      final encoding = Encoding.getByName('utf-8');
      final response = await http.post("${Constants.BASE_URL_USER_PROFILE}/1/reset-password", body: json.encode(data), headers: header, encoding: encoding);

      if (response.statusCode == 201) {
        final decodedData = json.decode(response.body);
        return decodedData["trace_id"];
      }

      return null;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<bool> updatePassword(String traceId, String otp, String password, String email) async {
    try {
      final Map<String, dynamic> data = Map<String, String>();
      data.putIfAbsent("password", () => password);
      data.putIfAbsent("email", () => email);
      var header = {
        'Content-Type': 'application/json',
        "Accept": "application/json",
        "trace-id": traceId,
        "security-code": otp,
      };
      final encoding = Encoding.getByName('utf-8');
      final response = await http.put("${Constants.BASE_URL_USER_PROFILE}/1/password", body: json.encode(data), headers: header, encoding: encoding);

      if (response.statusCode != 200) {
        return false;
      }

      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }
}
