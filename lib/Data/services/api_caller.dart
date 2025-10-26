import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';
import 'package:logger/logger.dart';
import 'package:task_mngwithprovider/app.dart';
import 'package:task_mngwithprovider/ui/controller/auth_controller.dart';
import 'package:task_mngwithprovider/ui/screens/login_screen.dart';

class ApiCaller {
  static final Logger _logger = Logger();

  static Future<ApiResponse> getRequest({required String url}) async {
    try {
      Uri uri = Uri.parse(url);

      _logRequest(url);
      Response response = await get(
        uri,
        headers: {'token': AuthController.accessToken ?? ''},
      );
      _logResponse(url, response);

      final int statusCode = response.statusCode;

      if (statusCode == 200) {
        // SUCCESS
        final decodedData = jsonDecode(response.body);
        return ApiResponse(
          isSuccess: true,
          responseCode: statusCode,
          responseData: decodedData,
        );
      } else if (statusCode == 401) {
        await _moveToLogin();
        return ApiResponse(
          isSuccess: false,
          responseCode: statusCode,
          errorMessage: 'Un-authorize',
          responseData: null,
        );
      } else {
        // FAILED
        final decodedData = jsonDecode(response.body);
        return ApiResponse(
          isSuccess: false,
          responseCode: statusCode,
          responseData: decodedData,
          errorMessage: decodedData['data'],
        );
      }
    } on Exception catch (e) {
      return ApiResponse(
        isSuccess: false,
        responseCode: -1,
        responseData: null,
        errorMessage: e.toString(),
      );
    }
  }

  static Future<ApiResponse> postRequest({
    required String url,
    Map<String, dynamic>? body,
  }) async {
    try {
      final uri = Uri.parse(url);

      _logRequest(url, body: body);
      final response = await post(
        uri,
        headers: {
          'content-type': 'application/json',
          'accept': 'application/json',
          'token': AuthController.accessToken ?? '',
        },
        body: jsonEncode(body ?? {}),
      );
      _logResponse(url, response);

      final int statusCode = response.statusCode;
      final contentType = (response.headers['content-type'] ?? '')
          .toLowerCase();

      dynamic decoded;
      if (contentType.contains('application/json')) {
        try {
          decoded = jsonDecode(response.body.isEmpty ? '{}' : response.body);
        } catch (_) {
          decoded = null;
        }
      }

      // SUCCESS (must be JSON)
      if (statusCode == 200 || statusCode == 201) {
        if (decoded != null) {
          return ApiResponse(
            isSuccess: true,
            responseCode: statusCode,
            responseData: decoded,
          );
        } else {
          return ApiResponse(
            isSuccess: false,
            responseCode: statusCode,
            responseData: null,
            errorMessage:
                'Unexpected response format from server (expected JSON, got ${contentType.split(";").first}).',
          );
        }
      }

      // UNAUTHORIZED
      if (statusCode == 401) {
        await _moveToLogin();
        return ApiResponse(
          isSuccess: false,
          responseCode: statusCode,
          errorMessage: 'Un-authorize',
          responseData: null,
        );
      }

      // OTHER FAILURES
      if (decoded != null) {
        return ApiResponse(
          isSuccess: false,
          responseCode: statusCode,
          responseData: decoded,
          errorMessage: decoded is Map && decoded['data'] != null
              ? decoded['data'].toString()
              : 'Request failed with status $statusCode.',
        );
      } else {
        final preview = response.body.length > 160
            ? '${response.body.substring(0, 160)}…'
            : response.body;
        return ApiResponse(
          isSuccess: false,
          responseCode: statusCode,
          responseData: null,
          errorMessage:
              'Request failed with status $statusCode (non-JSON). Body: $preview',
        );
      }
    } on Exception catch (e) {
      return ApiResponse(
        isSuccess: false,
        responseCode: -1,
        responseData: null,
        errorMessage: e.toString(),
      );
    }
  }

  static void _logRequest(String url, {Map<String, dynamic>? body}) {
    _logger.i(
      'URL => $url\n'
      'Request Body: $body',
    );
  }

  static void _logResponse(String url, Response response) {
    _logger.i(
      'URL => $url\n'
      'Status Code: ${response.statusCode}\n'
      'Body: ${response.body}',
    );
  }

  static Future<void> _moveToLogin() async {
    await AuthController.clearUserData();
    Navigator.pushNamedAndRemoveUntil(
      TaskManagerApp.navigator.currentContext!,
      LoginScreen.name,
      (predicate) => false,
    );
  }
}

class ApiResponse {
  final bool isSuccess;
  final int responseCode;
  final dynamic responseData;
  final String? errorMessage;

  ApiResponse({
    required this.isSuccess,
    required this.responseCode,
    required this.responseData,
    this.errorMessage = 'Something went wrong',
  });
}
