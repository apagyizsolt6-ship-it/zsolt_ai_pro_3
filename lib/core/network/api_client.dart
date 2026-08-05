/*
===========================================
MeccsIQ AI
Build: #003
Version: v1.1.0
File: lib/core/network/api_client.dart
===========================================
*/

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../../services/api_key_service.dart';
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
    final apiKey =
        await ApiKeyService.instance.getStatPalKey();

    if (apiKey == null || apiKey.trim().isEmpty) {
      throw const ApiException(
        'Nincs beállítva StatPal API kulcs.',
      );
    }

    final query = <String, String>{
      'access_key': apiKey,
    };

    if (queryParameters != null) {
      query.addAll(
        queryParameters.map(
          (key, value) => MapEntry(
            key,
            value.toString(),
          ),
        ),
      );
    }

    final uri = Uri.parse(
      '${ApiConfig.baseUrl}$endpoint',
    ).replace(
      queryParameters: query,
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

      return _parseResponse(response);
    } on TimeoutException catch (e) {
      throw ApiException.timeout(e);
    } on SocketException catch (e) {
      throw ApiException.network(e);
    } catch (e) {
      throw ApiException.unknown(e);
    }
  }

  Map<String, dynamic> _parseResponse(
    http.Response response,
  ) {
    if (response.statusCode == 200) {
      if (response.body.isEmpty) {
        return {};
      }

      final json = jsonDecode(response.body);

      if (json is Map<String, dynamic>) {
        return json;
      }

      throw const ApiException(
        'Érvénytelen JSON válasz.',
      );
    }

    throw ApiException.fromStatusCode(
      response.statusCode,
      error: response.body,
    );
  }

  void dispose() {
    _client.close();
  }
}
