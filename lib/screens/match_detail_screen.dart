// ===========================================
// ZSOLT AI PRO 3
// Version: v0.5.5
// File: lib/screens/match_detail_screen.dart
// ===========================================

import 'package:flutter/material.dart';

import '../models/app_match.dart';
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
        title: const Text(
          "Mérkőzés részletei",
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: const IconThemeData(
          color: Colors.black87,
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
                              radius: 28,
                              backgroundColor:
                                  Colors.blue.shade50,
                              child: const Icon(
                                Icons.shield,
                                size: 32,
                                color: Color(0xFF1976D2),
                              ),
                            ),

                            const SizedBox(height: 10),

                            Text(
                              match.homeTeam,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 12),
                        child: Text(
                          "VS",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                      Expanded(
                        child: Column(
                          children: [

                            CircleAvatar(
                              radius: 28,
                              backgroundColor:
                                  Colors.blue.shade50,
                              child: const Icon(
                                Icons.shield,
                                size: 32,
                                color: Color(0xFF1976D2),
                              ),
                            ),

                            const SizedBox(height: 10),

                            Text(
                              match.awayTeam,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
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
                      "${match.kickoff.year}  "
                      "${match.kickoff.hour.toString().padLeft(2, '0')}:"
                      "${match.kickoff.minute.toString().padLeft(2, '0')}",
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
              child: Column(
                children: [

                  const Text(
                    "AI Elemzés",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 18),

                  SizedBox(
                    width: 120,
                    height: 120,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [

                        CircularProgressIndicator(
                          value: match.aiScore / 100,
                          strokeWidth: 10,
                        ),

                        Center(
                          child: Text(
                            "${match.aiScore}%",
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 18),

                  Text(
                    "AI ajánlás: ${match.prediction}",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),                ],
              ),
            ),

            const SizedBox(height: 18),

            OddsCard(
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
                        Icons.info_outline,
                        color: Color(0xFF1976D2),
                      ),
                      SizedBox(width: 8),
                      Text(
                        "AI Információ",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  Text(
                    match.valueBet
                        ? "Ez a mérkőzés AI Value Bet lehetőségként lett megjelölve. A jelenlegi adatok alapján pozitív érték várható."
                        : "Az AI jelenleg nem jelölt kiemelt Value Bet lehetőséget erre a mérkőzésre.",
                    style: const TextStyle(
                      height: 1.5,
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
                    Icons.construction,
                    size: 42,
                    color: Color(0xFF1976D2),
                  ),
                  SizedBox(height: 12),
                  Text(
                    "Hamarosan érkezik",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "• Részletes statisztikák\n"
                    "• Csapatforma\n"
                    "• Egymás elleni mérkőzések (H2H)\n"
                    "• Sérülések\n"
                    "• Kezdőcsapatok\n"
                    "• AI Engine 3.0 elemzés\n"
                    "• Élő események",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      height: 1.6,
                      color: Colors.black87,
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
