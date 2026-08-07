// ===========================================
// ZSOLT AI PRO 3
// Version: v0.3.1
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

  static const String _cacheKeyToday = 'matches_today';

  /// true = utoljára mock jött; false = API
  bool lastFetchWasMock = true;

  Future<List<AppMatch>> getMatches({bool forceRefresh = false}) async {
    if (!forceRefresh) {
      final cached = _cache.get<List<AppMatch>>(_cacheKeyToday);
      if (cached != null) {
        return cached;
      }
    }

    final hasKey = await ApiKeyService.instance.hasStatPalKey();

    if (hasKey) {
      try {
        final matches = await _fetchFromApi();
        // Üres lista = nincs élő meccs / rossz parse → ne cache-eljük üresen
        if (matches.isNotEmpty) {
          lastFetchWasMock = false;
          _cache.put(
            _cacheKeyToday,
            matches,
            ApiConfig.todayMatchesCache,
          );
          return matches;
        }
      } on ApiException {
        // esik mockra
      } catch (_) {
        // esik mockra
      }
    }

    lastFetchWasMock = true;
    final mock = _getMockMatches();
    _cache.put(
      _cacheKeyToday,
      mock,
      const Duration(minutes: 5),
    );
    return mock;
  }

  Future<AppMatch?> getMatch(int id) async {
    final matches = await getMatches();
    try {
      return matches.firstWhere((match) => match.id == id);
    } catch (_) {
      return null;
    }
  }

  Future<List<AppMatch>> _fetchFromApi() async {
    // StatPal v2 live
    final json = await _apiClient.get('/soccer/matches/live');
    return _parseStatPalResponse(json);
  }

  List<AppMatch> _parseStatPalResponse(Map<String, dynamic> json) {
    final matches = <AppMatch>[];

    // v2: live_matches.league  |  v1-szerű: livescore.league
    Map<String, dynamic>? root;
    if (json['live_matches'] is Map<String, dynamic>) {
      root = json['live_matches'] as Map<String, dynamic>;
    } else if (json['livescore'] is Map<String, dynamic>) {
      root = json['livescore'] as Map<String, dynamic>;
    } else {
      root = json;
    }

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
      final country = (league['country'] ?? _extractCountry(leagueName))
          .toString();
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

        final status = (m['status'] ?? m['time'] ?? 'NS').toString();
        final isLive = _isLiveStatus(status);

        final idRaw = m['main_id'] ?? m['id'] ?? m['static_id'] ?? leagueId;
        final id = int.tryParse(idRaw.toString()) ?? idRaw.hashCode;

        final homeName = (homeMap['name'] ?? '').toString();
        final awayName = (awayMap['name'] ?? '').toString();
        if (homeName.isEmpty && awayName.isEmpty) continue;

        final timeStr = (m['time'] ?? '').toString();
        final kickoff = _parseKickoff(
          m['date']?.toString(),
          timeStr,
        );

        // Egyszerű placeholder AI score (Gemini később)
        final aiScore = _simpleAiScore(homeName, awayName, status);

        matches.add(
          AppMatch(
            id: id.abs() % 100000000,
            leagueName: leagueName.isEmpty ? 'Ismeretlen liga' : leagueName,
            country: country,
            homeTeam: homeName,
            awayTeam: awayName,
            homeLogo: '',
            awayLogo: '',
            leagueLogo: '',
            kickoff: kickoff,
            aiScore: aiScore,
            prediction: aiScore >= 70 ? 'Hazai' : '',
            status: status,
            live: isLive,
            valueBet: aiScore >= 88,
          ),
        );
      }
    }

    return matches;
  }

  bool _isLiveStatus(String status) {
    final s = status.trim().toUpperCase();
    if (s.isEmpty || s == 'NS' || s == 'FT' || s == 'AET' || s == 'PEN') {
      return false;
    }
    if (s.contains('POST') || s.contains('CANC') || s.contains('ABAND')) {
      return false;
    }
    // perc / HT / élő jelzések
    if (s == 'HT' || s == 'LIVE') return true;
    if (RegExp(r'^\d+$').hasMatch(s)) return true;
    if (RegExp(r'^\d+\+\d+$').hasMatch(s)) return true;
    if (RegExp(r'^\d{1,2}:\d{2}$').hasMatch(s)) return false; // kickoff time
    return s.length <= 3;
  }

  int _simpleAiScore(String home, String away, String status) {
    final h = home.toLowerCase().hashCode.abs();
    final a = away.toLowerCase().hashCode.abs();
    final base = 55 + ((h + a) % 40); // 55–94
    if (status.toUpperCase() == 'FT') return base.clamp(50, 99);
    return base.clamp(50, 99);
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

    // time pl. "20:45" vagy "20:45:00"
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
        leagueName: 'Serie A',
        country: 'Olaszország',
        homeTeam: 'Inter',
        awayTeam: 'Milan',
        homeLogo: '',
        awayLogo: '',
        leagueLogo: '',
        kickoff: now.add(const Duration(hours: 4)),
        aiScore: 86,
        prediction: 'Hazai',
        status: 'NS',
        homeOdd: 2.10,
        drawOdd: 3.20,
        awayOdd: 3.50,
      ),
      AppMatch(
        id: 5,
        leagueName: 'Bundesliga',
        country: 'Németország',
        homeTeam: 'Bayern München',
        awayTeam: 'Dortmund',
        homeLogo: '',
        awayLogo: '',
        leagueLogo: '',
        kickoff: now.add(const Duration(hours: 6)),
        aiScore: 82,
        prediction: 'Hazai',
        status: 'NS',
        homeOdd: 1.65,
        drawOdd: 4.10,
        awayOdd: 4.80,
        valueBet: true,
      ),
      AppMatch(
        id: 6,
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
      AppMatch(
        id: 7,
        leagueName: 'Ligue 1',
        country: 'Franciaország',
        homeTeam: 'PSG',
        awayTeam: 'Marseille',
        homeLogo: '',
        awayLogo: '',
        leagueLogo: '',
        kickoff: now.add(const Duration(hours: 8)),
        aiScore: 90,
        prediction: 'Hazai',
        status: 'NS',
        homeOdd: 1.40,
        drawOdd: 4.50,
        awayOdd: 7.50,
        valueBet: true,
      ),
      AppMatch(
        id: 8,
        leagueName: 'Premier League',
        country: 'Anglia',
        homeTeam: 'Manchester City',
        awayTeam: 'Newcastle',
        homeLogo: '',
        awayLogo: '',
        leagueLogo: '',
        kickoff: now.add(const Duration(hours: 1, minutes: 30)),
        aiScore: 85,
        prediction: 'Hazai',
        status: 'NS',
        homeOdd: 1.55,
        drawOdd: 4.00,
        awayOdd: 5.50,
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
    return matches.where((match) => match.favourite).toList();
  }

  List<AppMatch> search(List<AppMatch> matches, String query) {
    if (query.trim().isEmpty) return matches;
    final q = query.toLowerCase();
    return matches.where((match) {
      return match.homeTeam.toLowerCase().contains(q) ||
          match.awayTeam.toLowerCase().contains(q) ||
          match.leagueName.toLowerCase().contains(q) ||
          match.country.toLowerCase().contains(q);
    }).toList();
  }

  List<AppMatch> valueBetsOnly(List<AppMatch> matches) {
    return matches.where((m) => m.valueBet).toList();
  }

  List<AppMatch> highConfidenceOnly(List<AppMatch> matches) {
    return matches.where((m) => m.isHighConfidence).toList();
  }

  void clearCache() {
    _cache.remove(_cacheKeyToday);
  }
}
