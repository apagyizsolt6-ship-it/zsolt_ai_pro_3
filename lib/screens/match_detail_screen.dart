// ===========================================
// ZSOLT AI PRO 3
// Version: v0.6.0
// File: lib/screens/match_detail_screen.dart
// ===========================================

import 'package:flutter/material.dart';

import '../models/app_match.dart';

import '../widgets/match_detail/ai_statistics_card.dart';
import '../widgets/match_detail/form_card.dart';
import '../widgets/match_detail/h2h_card.dart';
import '../widgets/match_detail/match_statistics_card.dart';
import '../widgets/match_detail/odds_card.dart';

class MatchDetailScreen extends StatelessWidget {
  final AppMatch match;

  const MatchDetailScreen({
    super.key,
    required this.match,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(
          color: Colors.black87,
        ),
        title: const Text(
          "Mérkőzés részletei",
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(22),
              ),
              child: Column(
                children: [

                  Text(
                    match.leagueName,
                    style: TextStyle(
                      color: Colors.grey.shade700,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  const SizedBox(height: 20),

                  Row(
                    children: [

                      Expanded(
                        child: Column(
                          children: [

                            CircleAvatar(
                              radius: 30,
                              backgroundColor:
                                  Colors.blue.shade50,
                              child: const Icon(
                                Icons.shield,
                                size: 34,
                                color: Color(0xFF1976D2),
                              ),
                            ),

                            const SizedBox(height: 10),

                            Text(
                              match.homeTeam,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 14,
                        ),
                        child: Text(
                          "VS",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                      Expanded(
                        child: Column(
                          children: [

                            CircleAvatar(
                              radius: 30,
                              backgroundColor:
                                  Colors.blue.shade50,
                              child: const Icon(
                                Icons.shield,
                                size: 34,
                                color: Color(0xFF1976D2),
                              ),
                            ),

                            const SizedBox(height: 10),

                            Text(
                              match.awayTeam,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius:
                          BorderRadius.circular(14),
                    ),
                    child: Text(
                      "${match.kickoff.day.toString().padLeft(2, '0')}."
                      "${match.kickoff.month.toString().padLeft(2, '0')}."
                      "${match.kickoff.year} "
                      "${match.kickoff.hour.toString().padLeft(2, '0')}:"
                      "${match.kickoff.minute.toString().padLeft(2, '0')}",
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 18),

            AiStatisticsCard(
              match: match,
            ),

            OddsCard(
              match: match,
            ),

            FormCard(
              match: match,
            ),

            H2HCard(
              match: match,
            ),            MatchStatisticsCard(
              match: match,
            ),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(
                        Icons.psychology,
                        color: Color(0xFF1976D2),
                      ),
                      SizedBox(width: 8),
                      Text(
                        "AI Elemzés",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  Text(
                    "Az AI jelenlegi értékelése alapján "
                    "${match.homeTeam} nagyobb eséllyel érhet el kedvező eredményt. "
                    "Az ajánlás figyelembe veszi az AI pontszámot, "
                    "a szorzókat és a jelenlegi formaadatokat.",
                    style: const TextStyle(
                      height: 1.5,
                    ),
                  ),

                  const SizedBox(height: 16),

                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: match.valueBet
                          ? Colors.orange.shade100
                          : Colors.grey.shade100,
                      borderRadius:
                          BorderRadius.circular(14),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          match.valueBet
                              ? Icons.workspace_premium
                              : Icons.info_outline,
                          color: match.valueBet
                              ? Colors.orange
                              : Colors.blue,
                        ),

                        const SizedBox(width: 10),

                        Expanded(
                          child: Text(
                            match.valueBet
                                ? "AI Value Bet lehetőség azonosítva."
                                : "Jelenleg nincs kiemelt Value Bet ajánlás.",
                            style: const TextStyle(
                              fontWeight:
                                  FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 18),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Column(
                children: [
                  Icon(
                    Icons.rocket_launch,
                    size: 42,
                    color: Color(0xFF1976D2),
                  ),
                  SizedBox(height: 12),
                  Text(
                    "Hamarosan",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 12),
                  Text(
                    "• Sérülések és hiányzók\n"
                    "• Várható kezdőcsapatok\n"
                    "• Élő statisztikák\n"
                    "• AI Engine 2.0\n"
                    "• API alapú elemzés\n"
                    "• Élő eseménykövetés",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      height: 1.6,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
