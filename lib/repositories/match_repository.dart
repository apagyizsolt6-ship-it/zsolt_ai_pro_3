// ===========================================
// ZSOLT AI PRO 3
// Version: v0.3.2
// File: lib/repositories/match_repository.dart
// ===========================================

import '../core/cache/cache_service.dart';
import '../core/config/api_config.dart';
import '../core/network/api_client.dart';
import '../core/network/api_exception.dart';
import '../models/app_match.dart';
import '../services/api_key_service.dart';

class MatchRepository {
  MatchRepository({
    ApiClient? apiClient,
    CacheService? cache,
  })  : _apiClient = apiClient ?? ApiClient(),
        _cache = cache ?? CacheService.instance;

  final ApiClient _apiClient;
  final CacheService _cache;

  bool lastFetchWasMock = true;

  String _cacheKey(int dayOffset) => 'matches_offset_$dayOffset';

  /// [dayOffset]: 0 = ma, 1 = holnap, -1 = tegnap, stb. (-7..7)
  Future<List<AppMatch>> getMatches({
    bool forceRefresh = false,
    int dayOffset = 0,
  }) async {
    final key = _cacheKey(dayOffset);

    if (!forceRefresh) {
      final cached = _cache.get<List<AppMatch>>(key);
      if (cached != null) return cached;
    }

    final hasKey = await ApiKeyService.instance.hasStatPalKey();

    if (hasKey) {
      try {
        final matches = await _fetchFromApi(dayOffset);
        if (matches.isNotEmpty) {
          lastFetchWasMock = false;
          _cache.put(key, matches, ApiConfig.todayMatchesCache);
          return matches;
        }
      } on ApiException {
        // mock fallback
      } catch (_) {
        // mock fallback
      }
    }

    lastFetchWasMock = true;
    final mock = _getMockMatches();
    _cache.put(key, mock, const Duration(minutes: 5));
    return mock;
  }

  Future<AppMatch?> getMatch(int id) async {
    final matches = await getMatches();
    try {
      return matches.firstWhere((m) => m.id == id);
    } catch (_) {
      return null;
    }
  }

  Future<List<AppMatch>> _fetchFromApi(int dayOffset) async {
    // Ma: live endpoint; más nap: daily + offset
    // A daily offset a doksi szerint -7..-1 és 1..7 (0 nélkül)
    if (dayOffset == 0) {
      try {
        final live = await _apiClient.get('/soccer/matches/live');
        final parsed = _parseResponse(live);
        if (parsed.isNotEmpty) return parsed;
      } catch (_) {}

      // Ha a live üres, próbáljuk a daily-t offset=1 és -1 helyett
      // egyes fiókoknál a 0 is megy:
      try {
        final daily0 = await _apiClient.get(
          '/soccer/matches/daily',
          queryParameters: {'offset': 0},
        );
        final parsed = _parseResponse(daily0);
        if (parsed.isNotEmpty) return parsed;
      } catch (_) {}

      return [];
    }

    final json = await _apiClient.get(
      '/soccer/matches/daily',
      queryParameters: {'offset': dayOffset},
    );
    return _parseResponse(json);
  }

  /// Érti: live_matches | livescore | matches_DD_MM_YYYY
  List<AppMatch> _parseResponse(Map<String, dynamic> json) {
    final matches = <AppMatch>[];

    // Keressük a root objektumot, amiben van "league"
    final roots = <Map<String, dynamic>>[];

    void consider(dynamic v) {
      if (v is Map<String, dynamic> && v['league'] != null) {
        roots.add(v);
      }
    }

    consider(json['live_matches']);
    consider(json['livescore']);
    consider(json['matches']);

    // matches_15_12_2025 típusú kulcsok
    for (final entry in json.entries) {
      if (entry.key.startsWith('matches_')) {
        consider(entry.value);
      }
    }

    // Ha a gyökér maga tartalmaz league-et
    consider(json);

    for (final root in roots) {
      matches.addAll(_parseLeagues(root));
    }

    return matches;
  }

  List<AppMatch> _parseLeagues(Map<String, dynamic> root) {
    final result = <AppMatch>[];
    final leaguesRaw = root['league'];
    final leagues = <dynamic>[];

    if (leaguesRaw is List) {
      leagues.addAll(leaguesRaw);
    } else if (leaguesRaw is Map) {
      leagues.add(leaguesRaw);
    }

    for (final leagueRaw in leagues) {
      if (leagueRaw is! Map) continue;
      final league = Map<String, dynamic>.from(leagueRaw);

      final leagueName = (league['name'] ?? '').toString();
      final country =
          (league['country'] ?? _extractCountry(leagueName)).toString();
      final leagueId = league['id']?.toString() ?? '';

      final matchField = league['match'];
      final matchList = <dynamic>[];
      if (matchField is List) {
        matchList.addAll(matchField);
      } else if (matchField is Map) {
        matchList.add(matchField);
      }

      for (final mRaw in matchList) {
        if (mRaw is! Map) continue;
        final m = Map<String, dynamic>.from(mRaw);

        final home = m['home'];
        final away = m['away'];
        if (home is! Map || away is! Map) continue;

        final homeMap = Map<String, dynamic>.from(home);
        final awayMap = Map<String, dynamic>.from(away);

        final homeName = (homeMap['name'] ?? '').toString();
        final awayName = (awayMap['name'] ?? '').toString();
        if (homeName.isEmpty && awayName.isEmpty) continue;

        final status = (m['status'] ?? 'NS').toString();
        final timeStr = (m['time'] ?? '').toString();
        final idRaw =
            m['main_id'] ?? m['id'] ?? m['fallback_id_1'] ?? leagueId;
        final id = int.tryParse(idRaw.toString()) ?? idRaw.hashCode;

        final aiScore = _simpleAiScore(homeName, awayName);

        result.add(
          AppMatch(
            id: id.abs() % 100000000,
            leagueName:
                leagueName.isEmpty ? 'Ismeretlen liga' : leagueName,
            country: country,
            homeTeam: homeName,
            awayTeam: awayName,
            homeLogo: '',
            awayLogo: '',
            leagueLogo: '',
            kickoff: _parseKickoff(m['date']?.toString(), timeStr),
            aiScore: aiScore,
            prediction: aiScore >= 70 ? 'Hazai' : '',
            status: status,
            live: _isLiveStatus(status),
            valueBet: aiScore >= 88,
          ),
        );
      }
    }

    return result;
  }

  bool _isLiveStatus(String status) {
    final s = status.trim().toUpperCase();
    if (s == 'NS' || s == 'FT' || s == 'AET' || s == 'PEN') return false;
    if (s.contains('POST') || s.contains('CANC')) return false;
    if (s == 'HT' || s == 'LIVE') return true;
    if (RegExp(r'^\d+$').hasMatch(s)) return true;
    if (RegExp(r'^\d+\+\d+$').hasMatch(s)) return true;
    return false;
  }

  int _simpleAiScore(String home, String away) {
    final h = home.toLowerCase().hashCode.abs();
    final a = away.toLowerCase().hashCode.abs();
    return (55 + ((h + a) % 40)).clamp(50, 99);
  }

  String _extractCountry(String leagueName) {
    if (leagueName.contains(':')) {
      return leagueName.split(':').first.trim();
    }
    return '';
  }

  DateTime _parseKickoff(String? dateStr, String timeStr) {
    var base = DateTime.now();
    if (dateStr != null && dateStr.isNotEmpty) {
      try {
        final parts = dateStr.split('.');
        if (parts.length == 3) {
          base = DateTime(
            int.parse(parts[2]),
            int.parse(parts[1]),
            int.parse(parts[0]),
          );
        } else {
          base = DateTime.tryParse(dateStr) ?? base;
        }
      } catch (_) {}
    }

    final tm = RegExp(r'^(\d{1,2}):(\d{2})').firstMatch(timeStr.trim());
    if (tm != null) {
      return DateTime(
        base.year,
        base.month,
        base.day,
        int.parse(tm.group(1)!),
        int.parse(tm.group(2)!),
      );
    }
    return base;
  }

  List<AppMatch> _getMockMatches() {
    final now = DateTime.now();
    return [
      AppMatch(
        id: 1,
        leagueName: 'Premier League',
        country: 'Anglia',
        homeTeam: 'Liverpool',
        awayTeam: 'Chelsea',
        homeLogo: '',
        awayLogo: '',
        leagueLogo: '',
        kickoff: now.add(const Duration(hours: 3)),
        aiScore: 94,
        prediction: 'Hazai',
        status: 'NS',
        homeOdd: 1.72,
        drawOdd: 3.90,
        awayOdd: 4.60,
        valueBet: true,
      ),
      AppMatch(
        id: 2,
        leagueName: 'Premier League',
        country: 'Anglia',
        homeTeam: 'Arsenal',
        awayTeam: 'Tottenham',
        homeLogo: '',
        awayLogo: '',
        leagueLogo: '',
        kickoff: now.add(const Duration(hours: 5)),
        aiScore: 88,
        prediction: 'Hazai',
        status: 'NS',
        homeOdd: 1.95,
        drawOdd: 3.45,
        awayOdd: 3.80,
      ),
      AppMatch(
        id: 3,
        leagueName: 'La Liga',
        country: 'Spanyolország',
        homeTeam: 'Barcelona',
        awayTeam: 'Valencia',
        homeLogo: '',
        awayLogo: '',
        leagueLogo: '',
        kickoff: now.add(const Duration(hours: 7)),
        aiScore: 91,
        prediction: 'Hazai',
        status: 'NS',
        homeOdd: 1.48,
        drawOdd: 4.30,
        awayOdd: 6.80,
        valueBet: true,
      ),
      AppMatch(
        id: 4,
        leagueName: 'NB I',
        country: 'Magyarország',
        homeTeam: 'Ferencváros',
        awayTeam: 'Puskás Akadémia',
        homeLogo: '',
        awayLogo: '',
        leagueLogo: '',
        kickoff: now.add(const Duration(hours: 2)),
        aiScore: 79,
        prediction: 'Hazai',
        status: 'NS',
        homeOdd: 1.85,
        drawOdd: 3.40,
        awayOdd: 4.20,
      ),
    ];
  }

  List<AppMatch> toggleFavouriteLocally(
    List<AppMatch> matches,
    int matchId,
  ) {
    return matches.map((match) {
      if (match.id != matchId) return match;
      return match.copyWith(favourite: !match.favourite);
    }).toList();
  }

  List<AppMatch> favouritesOnly(List<AppMatch> matches) {
    return matches.where((m) => m.favourite).toList();
  }

  List<AppMatch> search(List<AppMatch> matches, String query) {
    if (query.trim().isEmpty) return matches;
    final q = query.toLowerCase();
    return matches.where((m) {
      return m.homeTeam.toLowerCase().contains(q) ||
          m.awayTeam.toLowerCase().contains(q) ||
          m.leagueName.toLowerCase().contains(q) ||
          m.country.toLowerCase().contains(q);
    }).toList();
  }

  List<AppMatch> valueBetsOnly(List<AppMatch> matches) {
    return matches.where((m) => m.valueBet).toList();
  }

  List<AppMatch> highConfidenceOnly(List<AppMatch> matches) {
    return matches.where((m) => m.isHighConfidence).toList();
  }

  void clearCache() {
    for (var i = -7; i <= 7; i++) {
      _cache.remove(_cacheKey(i));
    }
  }
}
