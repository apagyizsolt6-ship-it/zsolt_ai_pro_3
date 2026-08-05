/*
===========================================
MeccsIQ AI
Build: #001
Version: v1.0.0
File: lib/core/config/api_config.dart
===========================================
*/

class ApiConfig {
  ApiConfig._();

  /// StatPal API
  static const String baseUrl = 'https://statpal.io/api/v2';

  /// GitHub Actions vagy flutter --dart-define
  static const String statPalApiKey = String.fromEnvironment(
    'STATPAL_API_KEY',
    defaultValue: '',
  );

  /// Gemini AI
  static const String geminiApiKey = String.fromEnvironment(
    'GEMINI_API_KEY',
    defaultValue: '',
  );

  /// Timeoutok
  static const Duration connectTimeout = Duration(seconds: 20);
  static const Duration receiveTimeout = Duration(seconds: 30);

  /// Cache

  /// Mai meccsek
  static const Duration todayMatchesCache = Duration(minutes: 1);

  /// Élő odds
  static const Duration liveOddsCache = Duration(seconds: 10);

  /// Prematch odds
  static const Duration prematchOddsCache = Duration(minutes: 30);

  /// Tabella
  static const Duration standingsCache = Duration(hours: 1);

  /// Liga statisztikák
  static const Duration leagueStatsCache = Duration(hours: 4);

  /// Sérülések
  static const Duration injuriesCache = Duration(hours: 1);

  /// Ligák
  static const Duration leaguesCache = Duration(hours: 12);

  /// Szezonok
  static const Duration seasonsCache = Duration(hours: 12);

  static bool get hasStatPalKey => statPalApiKey.trim().isNotEmpty;

  static bool get hasGeminiKey => geminiApiKey.trim().isNotEmpty;

  static Uri uri(
    String endpoint, {
    Map<String, dynamic>? queryParameters,
  }) {
    final query = <String, String>{
      'access_key': statPalApiKey,
    };

    if (queryParameters != null) {
      query.addAll(
        queryParameters.map(
          (key, value) => MapEntry(key, value.toString()),
        ),
      );
    }

    return Uri.parse(
      '$baseUrl$endpoint',
    ).replace(
      queryParameters: query,
    );
  }
}
