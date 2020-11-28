import 'dart:convert';

import 'package:arreglapp/src/models/session.dart';
import 'package:arreglapp/src/models/user_profile.dart';
import 'package:http/http.dart' as http;
import 'package:arreglapp/constants/constants.dart' as Constants;

class SessionService {
  Future<Session> login(String username, String password, String token) async {
    try {
      final Map<String, dynamic> data = Map<String, dynamic>();
      data.putIfAbsent("username", () => username);
      data.putIfAbsent("password", () => password);
      data.putIfAbsent("token", () => token);
      var header = {'Content-Type': 'application/json', "Accept": "application/json"};
      final encoding = Encoding.getByName('utf-8');
      final response = await http.post(Constants.BASE_URL_SESSION + "/login", body: json.encode(data), headers: header, encoding: encoding);

      if (response.statusCode == 200) {
        final decodedData = json.decode(response.body);

        final userProfile = UserProfile();
        userProfile.username = username;

        final session = Session();
        session.jwt = decodedData["jwt"];

        return session;
      }

      return null;
    } catch (e) {
      print(e);
      return null;
    }
  }
}
