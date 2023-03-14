import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:wup/app/modules/chatGPT/api_exception.dart';

List<int> successStatusCodes = [200, 201, 204];

Map<String, String> _getCommonHeaders() {
  Map<String, String> headers = {
    'Content-Type': 'application/json; charset=UTF-8',
    'Authorization':
        'Bearer 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'
  };
  return headers;
}

class Network {
  static Future<Map<String, dynamic>> fetchRequest(
      String url, Map<String, String> headers) async {
    var allHeaders = {..._getCommonHeaders(), ...headers};
    var response = await http.get(Uri.parse(url), headers: allHeaders);
    if (successStatusCodes.contains(response.statusCode)) {
      return response.body == '' ? {} : jsonDecode(response.body);
    } else {
      throw ApiException(
          message: 'Request failed with status code ${response.statusCode}',
          response: response,
          error: getParsedResponseError(response.body));
    }
  }

  static Future<Map<String, dynamic>> postRequest(String url,
      Map<String, String> headers, Map<String, dynamic> body) async {
    var allHeaders = {..._getCommonHeaders(), ...headers};

    var response = await http.post(Uri.parse(url),
        headers: allHeaders, body: jsonEncode(body));

    if (successStatusCodes.contains(response.statusCode)) {
      return response.body == '' ? {} : jsonDecode(response.body);
    } else {
      throw ApiException(
          message: 'Request failed with status code ${response.statusCode}',
          response: response,
          error: getParsedResponseError(response.body));
    }
  }
}
