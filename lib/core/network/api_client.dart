import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:trio_farm/core/util/app_constant.dart';
import 'package:trio_farm/core/util/app_dialog.dart';

class ApiClient {
  Future<http.Response?> get(BuildContext context, String path) async {
    final url = Uri.parse('${AppConstant.baseUrl}$path');
    try {
      final response = await http.get(url);
      _handleResponse(context, response);
      return response;
    } catch (e) {
      AppDialog.showErrorDialog(
        context,
        'Failed to connect to the server:\n$e',
      );
      return null;
    }
  }

  Future<http.Response?> post(
    BuildContext context,
    String path, {
    required Map<String, dynamic> body,
  }) async {
    final url = Uri.parse('${AppConstant.baseUrl}$path');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: jsonEncode(body),
      );
      _handleResponse(context, response);
      return response;
    } catch (e) {
      AppDialog.showErrorDialog(
        context,
        'Failed to connect to the server:\n$e',
      );
      return null;
    }
  }

  void _handleResponse(BuildContext context, http.Response response) {
    if (response.statusCode < 200 || response.statusCode >= 300) {
      AppDialog.showErrorDialog(
        context,
        'API Error: ${response.statusCode}\n\n${response.body}',
      );
      throw Exception('API Error: ${response.statusCode}');
    }
  }
}
