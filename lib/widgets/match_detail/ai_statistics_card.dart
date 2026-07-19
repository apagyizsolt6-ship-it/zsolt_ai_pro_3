// ===========================================
// ZSOLT AI PRO 3
// Version: v0.5.6
// File: lib/widgets/match_detail/ai_statistics_card.dart
// ===========================================

import 'package:flutter/material.dart';

import '../../models/app_match.dart';

class AiStatisticsCard extends StatelessWidget {
  final AppMatch match;

  const AiStatisticsCard({
    super.key,
    required this.match,
  });

  @override
  Widget build(BuildContext context) {
    final homeChance = _homeChance();
    final drawChance = _drawChance();
    final awayChance = _awayChance();

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
                  Icons.analytics,
                  color: Color(0xFF1976D2),
                ),
                SizedBox(width: 8),
                Text(
                  "AI Statisztika",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            _buildBar(
              "Hazai győzelem",
              homeChance,
              Colors.green,
            ),

            const SizedBox(height: 14),

            _buildBar(
              "Döntetlen",
              drawChance,
              Colors.orange,
            ),

            const SizedBox(height: 14),

            _buildBar(
              "Vendég győzelem",
              awayChance,
              Colors.red,
            ),

            const Divider(height: 32),

            _infoRow(
              "AI pontszám",
              "${match.aiScore}%",
            ),

            _infoRow(
              "AI ajánlás",
              match.prediction,
            ),

            _infoRow(
              "Value Bet",
              match.valueBet ? "Igen" : "Nem",
            ),

            _infoRow(
              "Állapot",
              match.live ? "ÉLŐ" : "Mérkőzés előtt",
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBar(
    String title,
    int value,
    Color color,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(child: Text(title)),
            Text(
              "$value%",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: LinearProgressIndicator(
            minHeight: 10,
            value: value / 100,
            color: color,
            backgroundColor: Colors.grey.shade200,
          ),
        ),
      ],
    );
  }

  Widget _infoRow(
    String title,
    String value,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 6,
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                color: Colors.grey,
              ),
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  int _homeChance() {
    if (match.prediction.toLowerCase() == "hazai") {
      return match.aiScore;
    }

    return ((100 - match.aiScore) ~/ 2);
  }

  int _awayChance() {
    if (match.prediction.toLowerCase() == "vendég") {
      return match.aiScore;
    }

    return ((100 - match.aiScore) ~/ 2);
  }

  int _drawChance() {
    return 100 - _homeChance() - _awayChance();
  }
}
