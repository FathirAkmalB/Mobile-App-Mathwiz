import 'dart:convert';

import 'package:http/http.dart' as http;

String stagingUrl = 'https://staging.impstudio.id/math_be';
String ngrok = 'https://75a2-182-253-54-244.ngrok-free.app';

class ApiURL{
  static String apiUrl = stagingUrl;
}

class API {
  postRequest({
    required String route,
    required Map<String, dynamic> data,
  }) async {
    String apiUrl = '$stagingUrl/api';
    String url = apiUrl + route;

    return await http.post(
      Uri.parse(url),
      body: jsonEncode(data),
      headers: _header(),
    );
  }

  getRequest({
    required String route,
  }) async {
    String apiUrl = '$stagingUrl/api';

    String url = apiUrl + route;

    return await http.get(
      Uri.parse(url),
      headers: _header(),
    );
  }

  _header() =>
      {'Content-type': 'application/json', 'Accept': 'application/json'};
}
