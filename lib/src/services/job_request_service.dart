import 'dart:convert';

import 'package:arreglapp/src/helpers/util.dart';
import 'package:arreglapp/src/models/job_request.dart';
import 'package:http/http.dart' as http;
import 'package:arreglapp/constants/constants.dart' as Constants;

class JobRequestService {
  Future<String> create(JobRequest jobRequest, String jwt) async {
    try {
      final Map<String, dynamic> data = jobRequest.toJson();
      removeNullAndEmptyParams(data);
      var header = {'Content-Type': 'application/json', "Accept": "application/json", "Authorization": "Bearer $jwt"};
      final encoding = Encoding.getByName('utf-8');
      final response = await http.post(Constants.BASE_URL_CORE_OPERATION + "/service-request", body: json.encode(data), headers: header, encoding: encoding);

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
}
