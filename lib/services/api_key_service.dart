/*
===========================================
MeccsIQ AI
Build: #002
Version: v1.0.0
File: lib/services/api_key_service.dart
===========================================
*/

import '../core/storage/secure_storage_service.dart';

class ApiKeyService {
  ApiKeyService._();

  static final ApiKeyService instance = ApiKeyService._();

  final SecureStorageService _storage =
      SecureStorageService.instance;

  //==================================================
  // StatPal API
  //==================================================

  Future<void> saveStatPalKey(String apiKey) async {
    await _storage.saveStatPalKey(apiKey);
  }

  Future<String?> getStatPalKey() async {
    return await _storage.getStatPalKey();
  }

  Future<bool> hasStatPalKey() async {
    return await _storage.hasStatPalKey();
  }

  Future<void> deleteStatPalKey() async {
    await _storage.deleteStatPalKey();
  }

  //==================================================
  // Gemini API
  //==================================================

  Future<void> saveGeminiKey(String apiKey) async {
    await _storage.saveGeminiKey(apiKey);
  }

  Future<String?> getGeminiKey() async {
    return await _storage.getGeminiKey();
  }

  Future<bool> hasGeminiKey() async {
    return await _storage.hasGeminiKey();
  }

  Future<void> deleteGeminiKey() async {
    await _storage.deleteGeminiKey();
  }

  //==================================================
  // Segéd metódusok
  //==================================================

  Future<bool> isReady() async {
    return await hasStatPalKey();
  }

  Future<void> clearAll() async {
    await _storage.clearAll();
  }

  Future<Map<String, bool>> status() async {
    return {
      'statpal': await hasStatPalKey(),
      'gemini': await hasGeminiKey(),
    };
  }
}
