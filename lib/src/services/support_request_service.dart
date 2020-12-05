import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:arreglapp/constants/constants.dart' as Constants;

class SupportRequestService {
  Future<bool> create(String description, String jwt) async {
    try {
      final Map<String, dynamic> data = Map<String, dynamic>();
      data.putIfAbsent("description", () => description);
      var header = {'Content-Type': 'application/json', "Accept": "application/json", "Authorization": "Bearer $jwt"};
      final encoding = Encoding.getByName('utf-8');
      final response = await http.post(Constants.BASE_URL_CORE_OPERATION + "/support-request", body: json.encode(data), headers: header, encoding: encoding);

      if (response.statusCode == 201) {
        return true;
      }

      return false;
    } catch (e) {
      print(e);
      return false;
    }
  }
}
