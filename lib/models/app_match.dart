// ===========================================
// ZSOLT AI PRO 3
// Version: v0.4.0
// File: lib/models/app_match.dart
// ===========================================

class AppMatch {
  final int id;

  final String leagueName;
  final String country;

  final String homeTeam;
  final String awayTeam;

  final String homeLogo;
  final String awayLogo;
  final String leagueLogo;

  final DateTime kickoff;

  final double? homeOdd;
  final double? drawOdd;
  final double? awayOdd;

  final int aiScore;

  final bool valueBet;
  final bool live;
  final bool favourite;

  final String prediction;
  final String status;

  const AppMatch({
    required this.id,
    required this.leagueName,
    required this.country,
    required this.homeTeam,
    required this.awayTeam,
    required this.homeLogo,
    required this.awayLogo,
    required this.leagueLogo,
    required this.kickoff,
    required this.aiScore,
    required this.prediction,
    required this.status,
    this.homeOdd,
    this.drawOdd,
    this.awayOdd,
    this.valueBet = false,
    this.live = false,
    this.favourite = false,
  });

  bool get hasOdds =>
      homeOdd != null &&
      drawOdd != null &&
      awayOdd != null;

  bool get isHighConfidence => aiScore >= 90;

  bool get isMediumConfidence =>
      aiScore >= 75 && aiScore < 90;

  AppMatch copyWith({
    int? id,
    String? leagueName,
    String? country,
    String? homeTeam,
    String? awayTeam,
    String? homeLogo,
    String? awayLogo,
    String? leagueLogo,
    DateTime? kickoff,
    double? homeOdd,
    double? drawOdd,
    double? awayOdd,
    int? aiScore,
    bool? valueBet,
    bool? live,
    bool? favourite,
    String? prediction,
    String? status,
  }) {
    return AppMatch(
      id: id ?? this.id,
      leagueName: leagueName ?? this.leagueName,
      country: country ?? this.country,
      homeTeam: homeTeam ?? this.homeTeam,
      awayTeam: awayTeam ?? this.awayTeam,
      homeLogo: homeLogo ?? this.homeLogo,
      awayLogo: awayLogo ?? this.awayLogo,
      leagueLogo: leagueLogo ?? this.leagueLogo,
      kickoff: kickoff ?? this.kickoff,
      homeOdd: homeOdd ?? this.homeOdd,
      drawOdd: drawOdd ?? this.drawOdd,
      awayOdd: awayOdd ?? this.awayOdd,
      aiScore: aiScore ?? this.aiScore,
      valueBet: valueBet ?? this.valueBet,
      live: live ?? this.live,
      favourite: favourite ?? this.favourite,
      prediction: prediction ?? this.prediction,
      status: status ?? this.status,
    );
  }

  factory AppMatch.fromJson(Map<String, dynamic> json) {
    return AppMatch(
      id: json["id"] ?? 0,
      leagueName: json["leagueName"] ?? "",
      country: json["country"] ?? "",
      homeTeam: json["homeTeam"] ?? "",
      awayTeam: json["awayTeam"] ?? "",
      homeLogo: json["homeLogo"] ?? "",
      awayLogo: json["awayLogo"] ?? "",
      leagueLogo: json["leagueLogo"] ?? "",
      kickoff: DateTime.tryParse(json["kickoff"] ?? "") ??
          DateTime.now(),
      aiScore: json["aiScore"] ?? 0,
      prediction: json["prediction"] ?? "",
      status: json["status"] ?? "NS",
      homeOdd: (json["homeOdd"] as num?)?.toDouble(),
      drawOdd: (json["drawOdd"] as num?)?.toDouble(),
      awayOdd: (json["awayOdd"] as num?)?.toDouble(),
      valueBet: json["valueBet"] ?? false,
      live: json["live"] ?? false,
      favourite: json["favourite"] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "leagueName": leagueName,
      "country": country,
      "homeTeam": homeTeam,
      "awayTeam": awayTeam,
      "homeLogo": homeLogo,
      "awayLogo": awayLogo,
      "leagueLogo": leagueLogo,
      "kickoff": kickoff.toIso8601String(),
      "homeOdd": homeOdd,
      "drawOdd": drawOdd,
      "awayOdd": awayOdd,
      "aiScore": aiScore,
      "prediction": prediction,
      "status": status,
      "valueBet": valueBet,
      "live": live,
      "favourite": favourite,
    };
  }
}
