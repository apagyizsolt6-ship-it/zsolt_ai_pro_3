// ===========================================
// ZSOLT AI PRO 3
// Version: v0.2.0
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

  /// Meccsek lekérése.
  /// Ha van StatPal kulcs → API (cache-elve).
  /// Ha nincs / hiba → mock adatok.
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
        _cache.put(
          _cacheKeyToday,
          matches,
          ApiConfig.todayMatchesCache,
        );
        return matches;
      } on ApiException {
        // API hiba esetén mock fallback
      } catch (_) {
        // Ismeretlen hiba esetén is mock
      }
    }

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
    // StatPal v2: /soccer/matches/live
    // A válasz struktúra liga → match lista.
    // Jelenleg a parsing minimal; később bővítjük odds + prematch endpointokkal.
    final json = await _apiClient.get('/soccer/matches/live');

    final matches = <AppMatch>[];
    final liveMatches = json['live_matches'];
    if (liveMatches is! Map<String, dynamic>) {
      return matches;
    }

    final leagues = liveMatches['league'];
    if (leagues is! List) {
      return matches;
    }

    for (final leagueRaw in leagues) {
      if (leagueRaw is! Map<String, dynamic>) continue;

      final leagueName = (leagueRaw['name'] ?? '').toString();
      final country = _extractCountry(leagueName);
      final leagueId = leagueRaw['id']?.toString() ?? '';

      final matchField = leagueRaw['match'];
      final matchList = <dynamic>[];
      if (matchField is List) {
        matchList.addAll(matchField);
      } else if (matchField is Map) {
        matchList.add(matchField);
      }

      for (final m in matchList) {
        if (m is! Map<String, dynamic>) continue;

        final home = m['home'];
        final away = m['away'];
        if (home is! Map || away is! Map) continue;

        final status = (m['status'] ?? 'NS').toString();
        final isLive = status != 'NS' &&
            status != 'FT' &&
            status != 'Postp.' &&
            status != 'Canc.';

        final idRaw = m['main_id'] ?? m['id'] ?? leagueId.hashCode;
        final id = int.tryParse(idRaw.toString()) ?? idRaw.hashCode;

        matches.add(
          AppMatch(
            id: id.abs() % 100000000,
            leagueName: leagueName,
            country: country,
            homeTeam: (home['name'] ?? '').toString(),
            awayTeam: (away['name'] ?? '').toString(),
            homeLogo: '',
            awayLogo: '',
            leagueLogo: '',
            kickoff: _parseKickoff(m['date']?.toString()),
            aiScore: 0,
            prediction: '',
            status: status,
            live: isLive,
          ),
        );
      }
    }

    return matches;
  }

  String _extractCountry(String leagueName) {
    if (leagueName.contains(':')) {
      return leagueName.split(':').first.trim();
    }
    return '';
  }

  DateTime _parseKickoff(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) {
      return DateTime.now();
    }
    // StatPal formátum pl. "23.12.2025"
    try {
      final parts = dateStr.split('.');
      if (parts.length == 3) {
        final day = int.parse(parts[0]);
        final month = int.parse(parts[1]);
        final year = int.parse(parts[2]);
        return DateTime(year, month, day);
      }
    } catch (_) {}
    return DateTime.tryParse(dateStr) ?? DateTime.now();
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
