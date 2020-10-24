import 'package:arreglapp/src/models/operation_type.dart';
import 'package:http/http.dart' as http;
import 'package:arreglapp/constants/constants.dart' as Constants;

class OperationTypeService {
  Future<List<OperationType>> getAll(String jwt) async {
    try {
      var header = {'Content-Type': 'application/json', "Accept": "application/json", "Authorization": "Bearer $jwt"};
      final response = await http.get(Constants.BASE_URL_CORE_OPERATION + "/operation-type", headers: header);

      if (response.statusCode == 200) {
        return operationTypeFromJson(response.body);
      }

      return List<OperationType>();
    } catch (e) {
      print(e);
      return null;
    }
  }
}
