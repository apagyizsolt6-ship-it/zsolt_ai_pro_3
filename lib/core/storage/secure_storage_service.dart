/*
===========================================
MeccsIQ AI
Build: #002
Version: v1.0.0
File: lib/core/storage/secure_storage_service.dart
===========================================
*/

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  SecureStorageService._();

  static final SecureStorageService instance =
      SecureStorageService._();

  static const FlutterSecureStorage _storage =
      FlutterSecureStorage();

  static const String _statPalKey = 'statpal_api_key';
  static const String _geminiKey = 'gemini_api_key';

  //==================================================
  // StatPal API
  //==================================================

  Future<void> saveStatPalKey(String apiKey) async {
    await _storage.write(
      key: _statPalKey,
      value: apiKey.trim(),
    );
  }

  Future<String?> getStatPalKey() async {
    return _storage.read(
      key: _statPalKey,
    );
  }

  Future<void> deleteStatPalKey() async {
    await _storage.delete(
      key: _statPalKey,
    );
  }

  Future<bool> hasStatPalKey() async {
    final key = await getStatPalKey();

    return key != null && key.trim().isNotEmpty;
  }

  //==================================================
  // Gemini API
  //==================================================

  Future<void> saveGeminiKey(String apiKey) async {
    await _storage.write(
      key: _geminiKey,
      value: apiKey.trim(),
    );
  }

  Future<String?> getGeminiKey() async {
    return _storage.read(
      key: _geminiKey,
    );
  }

  Future<void> deleteGeminiKey() async {
    await _storage.delete(
      key: _geminiKey,
    );
  }

  Future<bool> hasGeminiKey() async {
    final key = await getGeminiKey();

    return key != null && key.trim().isNotEmpty;
  }

  //==================================================
  // Egyéb
  //==================================================

  Future<void> clearAll() async {
    await _storage.deleteAll();
  }
}
