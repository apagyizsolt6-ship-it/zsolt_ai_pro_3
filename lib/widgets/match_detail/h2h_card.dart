// ===========================================
// ZSOLT AI PRO 3
// Version: v0.5.8
// File: lib/widgets/match_detail/h2h_card.dart
// ===========================================

import 'package:flutter/material.dart';

import '../../models/app_match.dart';

class H2HCard extends StatelessWidget {
  final AppMatch match;

  const H2HCard({
    super.key,
    required this.match,
  });

  @override
  Widget build(BuildContext context) {
    const matches = [
      {"date": "2026-03-18", "score": "2-1", "winner": "home"},
      {"date": "2025-11-04", "score": "1-1", "winner": "draw"},
      {"date": "2025-07-22", "score": "0-2", "winner": "away"},
      {"date": "2025-02-15", "score": "3-1", "winner": "home"},
      {"date": "2024-09-08", "score": "2-2", "winner": "draw"},
    ];

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
                  Icons.compare_arrows,
                  color: Color(0xFF1976D2),
                ),
                SizedBox(width: 8),
                Text(
                  "Egymás elleni mérkőzések",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            ...matches.map(
              (item) => _matchRow(
                date: item["date"] as String,
                score: item["score"] as String,
                winner: item["winner"] as String,
              ),
            ),

            const Divider(height: 30),

            Row(
              children: [
                const Icon(
                  Icons.analytics,
                  color: Color(0xFF1976D2),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    "${match.homeTeam} előnyben az utóbbi egymás elleni mérkőzések alapján.",
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _matchRow({
    required String date,
    required String score,
    required String winner,
  }) {
    Color color;

    switch (winner) {
      case "home":
        color = Colors.green;
        break;
      case "away":
        color = Colors.red;
        break;
      default:
        color = Colors.orange;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(
            Icons.circle,
            size: 12,
            color: color,
          ),
          const SizedBox(width: 10),
          SizedBox(
            width: 90,
            child: Text(date),
          ),
          Expanded(
            child: Text(
              score,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
