import 'dart:convert';

import 'package:arreglapp/src/models/job_request.dart';
import 'package:http/http.dart' as http;
import 'package:arreglapp/constants/constants.dart' as Constants;

class BudgetService {
  Future<bool> create(String jwt, String traceID, Budget budget) async {
    try {
      final Map<String, dynamic> data = Map<String, dynamic>();
      data.putIfAbsent("amount", () => budget.amount);
      data.putIfAbsent("date", () => budget.date.toUtc().toIso8601String());
      var header = {'Content-Type': 'application/json', "Accept": "application/json", "Authorization": "Bearer $jwt", "trace-id": traceID};
      final encoding = Encoding.getByName('utf-8');
      final response =
          await http.post(Constants.BASE_URL_CORE_OPERATION + "/service-request/budget", body: json.encode(data), headers: header, encoding: encoding);

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
