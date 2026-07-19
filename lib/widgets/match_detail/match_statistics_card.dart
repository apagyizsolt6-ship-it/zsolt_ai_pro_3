// ===========================================
// ZSOLT AI PRO 3
// Version: v0.5.9
// File: lib/widgets/match_detail/match_statistics_card.dart
// ===========================================

import 'package:flutter/material.dart';

import '../../models/app_match.dart';

class MatchStatisticsCard extends StatelessWidget {
  final AppMatch match;

  const MatchStatisticsCard({
    super.key,
    required this.match,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(
                  Icons.bar_chart,
                  color: Color(0xFF1976D2),
                ),
                SizedBox(width: 8),
                Text(
                  "Mérkőzés statisztikák",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            _statRow(
              "Labdabirtoklás",
              "58%",
              "42%",
              0.58,
            ),

            _statRow(
              "Kaput eltaláló lövések",
              "7",
              "4",
              0.64,
            ),

            _statRow(
              "Összes lövés",
              "16",
              "11",
              0.59,
            ),

            _statRow(
              "Szögletek",
              "8",
              "5",
              0.62,
            ),

            _statRow(
              "Várható gól (xG)",
              "2.10",
              "1.05",
              0.67,
            ),

            _statRow(
              "Sárga lap",
              "2",
              "3",
              0.40,
            ),

            _statRow(
              "Piros lap",
              "0",
              "0",
              0.50,
            ),

            const SizedBox(height: 18),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Text(
                "AI értékelés: ${match.homeTeam} statisztikai előnye alapján "
                "a mérkőzés esélyese jelenleg a hazai csapat.",
                style: const TextStyle(
                  height: 1.5,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _statRow(
    String title,
    String home,
    String away,
    double progress,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Column(
        children: [
          Row(
            children: [
              SizedBox(
                width: 45,
                child: Text(
                  home,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Expanded(
                child: Center(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 45,
                child: Text(
                  away,
                  textAlign: TextAlign.end,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 6),

          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              minHeight: 8,
              value: progress,
            ),
          ),
        ],
      ),
    );
  }
}
