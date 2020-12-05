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

  Future<List<JobRequest>> listBy(String username, String jwt) async {
    try {
      var header = {'Content-Type': 'application/json', "Accept": "application/json", "Authorization": "Bearer $jwt"};
      final response = await http.get(Constants.BASE_URL_CORE_OPERATION + "/service-request/list?username=" + username, headers: header);

      if (response.statusCode == 200) {
        return jobRequestFromJson(response.body);
      }

      return null;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<List<JobRequest>> searchRequests(String jwt) async {
    try {
      var header = {'Content-Type': 'application/json', "Accept": "application/json", "Authorization": "Bearer $jwt"};
      final response = await http.get(Constants.BASE_URL_CORE_OPERATION + "/service-request/search", headers: header);

      if (response.statusCode == 200) {
        return jobRequestFromJson(response.body);
      }

      return null;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<List<JobRequest>> searchOngoing(String jwt) async {
    try {
      var header = {'Content-Type': 'application/json', "Accept": "application/json", "Authorization": "Bearer $jwt"};
      final response = await http.get(Constants.BASE_URL_CORE_OPERATION + "/service-request/professional/list", headers: header);

      if (response.statusCode == 200) {
        return jobRequestFromJson(response.body);
      }

      return null;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<bool> initChat(String jwt, String traceID, String to) async {
    try {
      var header = {'Content-Type': 'application/json', "Accept": "application/json", "Authorization": "Bearer $jwt", "trace-id": traceID};
      final encoding = Encoding.getByName('utf-8');
      final Map<String, String> data = Map<String, String>();
      data.putIfAbsent("to", () => to);

      final response =
          await http.post(Constants.BASE_URL_CORE_OPERATION + "/service-request/init-chat", body: json.encode(data), headers: header, encoding: encoding);

      if (response.statusCode == 201) {
        return true;
      }

      return false;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> confirmProfessional(String jwt, String traceID, String professionalID) async {
    try {
      var header = {'Content-Type': 'application/json', "Accept": "application/json", "Authorization": "Bearer $jwt", "trace-id": traceID};
      final encoding = Encoding.getByName('utf-8');
      final response =
          await http.post(Constants.BASE_URL_CORE_OPERATION + "/service-request/professional/$professionalID/confirm", headers: header, encoding: encoding);

      if (response.statusCode == 201) {
        return true;
      }

      return false;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> confirmPayment(String jwt, String traceID) async {
    try {
      var header = {'Content-Type': 'application/json', "Accept": "application/json", "Authorization": "Bearer $jwt", "trace-id": traceID};
      final encoding = Encoding.getByName('utf-8');

      final response = await http.post(Constants.BASE_URL_CORE_OPERATION + "/service-request/pay", headers: header, encoding: encoding);

      if (response.statusCode == 201) {
        return true;
      }

      return false;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> transactionFeePay(String jwt, String traceID, String image) async {
    try {
      var header = {'Content-Type': 'application/json', "Accept": "application/json", "Authorization": "Bearer $jwt", "trace-id": traceID};
      final encoding = Encoding.getByName('utf-8');
      final Map<String, dynamic> data = Map<String, dynamic>();
      data.putIfAbsent("image", () => image);

      final response = await http.post(
        Constants.BASE_URL_CORE_OPERATION + "/service-request/pay-transaction-fee",
        body: json.encode(data),
        headers: header,
        encoding: encoding,
      );

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
