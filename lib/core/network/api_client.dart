/*
===========================================
MeccsIQ AI
Build: #001
Version: v1.0.0
File: lib/core/network/api_client.dart
===========================================
*/

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../config/api_config.dart';
import 'api_exception.dart';

class ApiClient {
  ApiClient({
    http.Client? client,
  }) : _client = client ?? http.Client();

  final http.Client _client;

  Future<Map<String, dynamic>> get(
    String endpoint, {
    Map<String, dynamic>? queryParameters,
  }) async {
    if (!ApiConfig.hasStatPalKey) {
      throw const ApiException(
        'Hiányzik a STATPAL_API_KEY.',
      );
    }

    final uri = ApiConfig.uri(
      endpoint,
      queryParameters: queryParameters,
    );

    try {
      final response = await _client
          .get(
            uri,
            headers: const {
              'Accept': 'application/json',
            },
          )
          .timeout(ApiConfig.connectTimeout);

      return _handleResponse(response);
    } on TimeoutException catch (e) {
      throw ApiException.timeout(e);
    } on SocketException catch (e) {
      throw ApiException.network(e);
    } on HttpException catch (e) {
      throw ApiException.network(e);
    } catch (e) {
      throw ApiException.unknown(e);
    }
  }

  Map<String, dynamic> _handleResponse(
    http.Response response,
  ) {
    switch (response.statusCode) {
      case 200:
        if (response.body.isEmpty) {
          return {};
        }

        final decoded = jsonDecode(response.body);

        if (decoded is Map<String, dynamic>) {
          return decoded;
        }

        throw const ApiException(
          'Érvénytelen JSON válasz.',
        );

      case 400:
      case 401:
      case 404:
      case 429:
      case 500:
        throw ApiException.fromStatusCode(
          response.statusCode,
          error: response.body,
        );

      default:
        throw ApiException(
          'Ismeretlen HTTP hiba.',
          statusCode: response.statusCode,
          error: response.body,
        );
    }
  }

  void dispose() {
    _client.close();
  }
}
