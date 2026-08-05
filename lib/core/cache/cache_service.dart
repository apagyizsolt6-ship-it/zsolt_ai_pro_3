/*
===========================================
MeccsIQ AI
Build: #001
Version: v1.0.0
File: lib/core/cache/cache_service.dart
===========================================
*/

class CacheItem<T> {
  final T data;
  final DateTime expiresAt;

  const CacheItem({
    required this.data,
    required this.expiresAt,
  });

  bool get isExpired => DateTime.now().isAfter(expiresAt);
}

class CacheService {
  CacheService._();

  static final CacheService instance = CacheService._();

  final Map<String, CacheItem<dynamic>> _cache = {};

  bool contains(String key) {
    final item = _cache[key];

    if (item == null) {
      return false;
    }

    if (item.isExpired) {
      _cache.remove(key);
      return false;
    }

    return true;
  }

  T? get<T>(String key) {
    final item = _cache[key];

    if (item == null) {
      return null;
    }

    if (item.isExpired) {
      _cache.remove(key);
      return null;
    }

    return item.data as T;
  }

  void put<T>(
    String key,
    T value,
    Duration duration,
  ) {
    _cache[key] = CacheItem<T>(
      data: value,
      expiresAt: DateTime.now().add(duration),
    );
  }

  void remove(String key) {
    _cache.remove(key);
  }

  void clear() {
    _cache.clear();
  }

  void clearExpired() {
    final expiredKeys = <String>[];

    for (final entry in _cache.entries) {
      if (entry.value.isExpired) {
        expiredKeys.add(entry.key);
      }
    }

    for (final key in expiredKeys) {
      _cache.remove(key);
    }
  }

  int get size => _cache.length;
}
