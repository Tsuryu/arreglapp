import 'dart:convert';

import 'package:arreglapp/src/models/session.dart';
import 'package:arreglapp/src/models/user_profile.dart';
import 'package:http/http.dart' as http;

class SessionService {
  // final String baseUrl = "http://192.168.0.11:8080/login";
  final String baseUrl = "https://arreglapp-user-profile.herokuapp.com/login";

  Future<Session> login(String username, String password) async {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data.putIfAbsent("username", () => username);
    data.putIfAbsent("password", () => password);
    var header = {'Content-Type': 'application/json', "Accept": "application/json"};
    final encoding = Encoding.getByName('utf-8');
    final response = await http.post(baseUrl, body: json.encode(data), headers: header, encoding: encoding);
    // final response = await http.post('$baseUrl/$username');

    if (response.statusCode == 200) {
      final decodedData = json.decode(response.body);

      final userProfile = UserProfile();
      userProfile.username = username;

      final session = Session();
      session.jwt = decodedData["jwt"];

      return session;
    } else {
      return null;
    }
  }
}
