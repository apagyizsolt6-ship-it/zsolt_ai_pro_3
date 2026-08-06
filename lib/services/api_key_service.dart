/*
===========================================
MeccsIQ AI / Zsolt AI PRO 3
Version: v0.2.0
File: lib/services/api_key_service.dart
===========================================
*/

import '../core/config/api_config.dart';
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

  /// Először secure storage, ha üres → dart-define (ApiConfig).
  Future<String?> getStatPalKey() async {
    final stored = await _storage.getStatPalKey();
    if (stored != null && stored.trim().isNotEmpty) {
      return stored.trim();
    }

    if (ApiConfig.hasStatPalKey) {
      return ApiConfig.statPalApiKey;
    }

    return null;
  }

  Future<bool> hasStatPalKey() async {
    final key = await getStatPalKey();
    return key != null && key.trim().isNotEmpty;
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
    final stored = await _storage.getGeminiKey();
    if (stored != null && stored.trim().isNotEmpty) {
      return stored.trim();
    }

    if (ApiConfig.hasGeminiKey) {
      return ApiConfig.geminiApiKey;
    }

    return null;
  }

  Future<bool> hasGeminiKey() async {
    final key = await getGeminiKey();
    return key != null && key.trim().isNotEmpty;
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
