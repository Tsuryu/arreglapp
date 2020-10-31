import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:arreglapp/constants/constants.dart' as Constants;

class TransactionService {
  Future<bool> confirm(String otp, String traceId) async {
    try {
      final Map<String, dynamic> data = Map<String, dynamic>();
      data.putIfAbsent("status", () => "confirmed");
      final Map<String, dynamic> metaData = Map<String, dynamic>();
      metaData.putIfAbsent("step", () => "otp confirmation to reset password");
      data.putIfAbsent("metadata", () => metaData);
      var header = {'Content-Type': 'application/json', "Accept": "application/json", "security-code": otp};
      final encoding = Encoding.getByName('utf-8');
      final response = await http.post(Constants.BASE_URL_TRANSACTION + "/$traceId/detail", body: json.encode(data), headers: header, encoding: encoding);

      return response.statusCode == 201;
    } catch (e) {
      print(e);
      return false;
    }
  }
}
