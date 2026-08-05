/*
===========================================
MeccsIQ AI
Build: #001
Version: v1.0.0
File: lib/core/network/api_exception.dart
===========================================
*/

class ApiException implements Exception {
  final String message;
  final int? statusCode;
  final Object? error;

  const ApiException(
    this.message, {
    this.statusCode,
    this.error,
  });

  @override
  String toString() {
    if (statusCode != null) {
      return 'ApiException($statusCode): $message';
    }
    return 'ApiException: $message';
  }

  factory ApiException.badRequest([Object? error]) {
    return ApiException(
      'Hibás kérés.',
      statusCode: 400,
      error: error,
    );
  }

  factory ApiException.unauthorized([Object? error]) {
    return ApiException(
      'Érvénytelen vagy hiányzó API kulcs.',
      statusCode: 401,
      error: error,
    );
  }

  factory ApiException.notFound([Object? error]) {
    return ApiException(
      'A kért adat nem található.',
      statusCode: 404,
      error: error,
    );
  }

  factory ApiException.tooManyRequests([Object? error]) {
    return ApiException(
      'Túl sok API kérés történt. Próbáld újra később.',
      statusCode: 429,
      error: error,
    );
  }

  factory ApiException.serverError([Object? error]) {
    return ApiException(
      'A StatPal szerver jelenleg nem elérhető.',
      statusCode: 500,
      error: error,
    );
  }

  factory ApiException.timeout([Object? error]) {
    return ApiException(
      'Az API válaszideje lejárt.',
      error: error,
    );
  }

  factory ApiException.network([Object? error]) {
    return ApiException(
      'Nincs internetkapcsolat vagy hálózati hiba történt.',
      error: error,
    );
  }

  factory ApiException.unknown([Object? error]) {
    return ApiException(
      'Ismeretlen hiba történt.',
      error: error,
    );
  }

  static ApiException fromStatusCode(
    int statusCode, {
    Object? error,
  }) {
    switch (statusCode) {
      case 400:
        return ApiException.badRequest(error);

      case 401:
        return ApiException.unauthorized(error);

      case 404:
        return ApiException.notFound(error);

      case 429:
        return ApiException.tooManyRequests(error);

      case 500:
        return ApiException.serverError(error);

      default:
        return ApiException(
          'HTTP hiba: $statusCode',
          statusCode: statusCode,
          error: error,
        );
    }
  }
}
