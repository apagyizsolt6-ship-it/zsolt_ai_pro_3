// ===========================================
// ZSOLT AI PRO 3
// Version: v0.4.1
// File: lib/repositories/match_repository.dart
// ===========================================

import '../models/app_match.dart';

class MatchRepository {
  const MatchRepository();

  /// Ide kerül majd a valódi API-hívás.
  ///
  /// Jelenleg mintaadatokat ad vissza, hogy a UI
  /// már AppMatch objektumokkal működjön.
  Future<List<AppMatch>> getMatches() async {
    await Future.delayed(const Duration(milliseconds: 500));

    return [
      AppMatch(
        id: 1,
        leagueName: "Premier League",
        country: "Anglia",
        homeTeam: "Liverpool",
        awayTeam: "Chelsea",
        homeLogo: "",
        awayLogo: "",
        leagueLogo: "",
        kickoff: DateTime.now().add(
          const Duration(hours: 3),
        ),
        aiScore: 94,
        prediction: "Hazai",
        status: "NS",
        homeOdd: 1.72,
        drawOdd: 3.90,
        awayOdd: 4.60,
        valueBet: true,
      ),
      AppMatch(
        id: 2,
        leagueName: "Premier League",
        country: "Anglia",
        homeTeam: "Arsenal",
        awayTeam: "Tottenham",
        homeLogo: "",
        awayLogo: "",
        leagueLogo: "",
        kickoff: DateTime.now().add(
          const Duration(hours: 5),
        ),
        aiScore: 88,
        prediction: "Hazai",
        status: "NS",
        homeOdd: 1.95,
        drawOdd: 3.45,
        awayOdd: 3.80,
      ),
      AppMatch(
        id: 3,
        leagueName: "La Liga",
        country: "Spanyolország",
        homeTeam: "Barcelona",
        awayTeam: "Valencia",
        homeLogo: "",
        awayLogo: "",
        leagueLogo: "",
        kickoff: DateTime.now().add(
          const Duration(hours: 7),
        ),
        aiScore: 91,
        prediction: "Hazai",
        status: "NS",
        homeOdd: 1.48,
        drawOdd: 4.30,
        awayOdd: 6.80,
        valueBet: true,
      ),
    ];
  }

  Future<AppMatch?> getMatch(int id) async {
    final matches = await getMatches();

    try {
      return matches.firstWhere(
        (match) => match.id == id,
      );
    } catch (_) {
      return null;
    }
  }
}
