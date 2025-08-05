import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:trio_farm_app/core/util/app_constant.dart';

class ApiClient {
  Future<http.Response> get(String path) async {
    final url = Uri.parse('${AppConstant.baseUrl}$path');
    final response = await http.get(url);
    _handleResponse(response);
    return response;
  }

  Future<http.Response> post(
    String path, {
    required Map<String, dynamic> body,
  }) async {
    final url = Uri.parse('${AppConstant.baseUrl}$path');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
      body: jsonEncode(body),
    );
    _handleResponse(response);
    return response;
  }

  Future<http.Response> patch(
    String path, {
    required Map<String, dynamic> body,
  }) async {
    final url = Uri.parse('${AppConstant.baseUrl}$path');
    final response = await http.patch(
      url,
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
      body: jsonEncode(body),
    );
    _handleResponse(response);
    return response;
  }

  Future<http.Response> delete(String path) async {
    final url = Uri.parse('${AppConstant.baseUrl}$path');
    final response = await http.delete(
      url,
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
    );

    _handleResponse(response);
    return response;
  }

  void _handleResponse(http.Response response) {
    if (response.statusCode < 200 || response.statusCode >= 300) {
      final decoded = _decodeResponseBody(response);
      throw Exception('API Error: ${response.statusCode}\n\n$decoded');
    }
  }

  String _decodeResponseBody(http.Response response) {
    try {
      return utf8.decode(response.bodyBytes);
    } catch (e) {
      return latin1.decode(response.bodyBytes);
    }
  }
}
