import 'dart:convert';

import 'package:http/http.dart' as http;

class TransactionService {
  final String baseUrl = "http://192.168.0.27:8081/transaction";
  // final String baseUrl = "https://arreglapp-user-profile.herokuapp.com/login";

  Future<bool> confirm(String otp, String traceId) async {
    try {
      final Map<String, dynamic> data = Map<String, dynamic>();
      data.putIfAbsent("status", () => "confirm");
      final Map<String, dynamic> metaData = Map<String, dynamic>();
      metaData.putIfAbsent("message", () => "otp confirmation to reset password");
      data.putIfAbsent("metadata", () => metaData);
      var header = {'Content-Type': 'application/json', "Accept": "application/json", "security-code": otp};
      final encoding = Encoding.getByName('utf-8');
      final response = await http.post(baseUrl + "/$traceId/detail", body: json.encode(data), headers: header, encoding: encoding);

      return response.statusCode == 201;
    } catch (e) {
      print(e);
      return false;
    }
  }
}
