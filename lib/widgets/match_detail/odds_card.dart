// ===========================================
// ZSOLT AI PRO 3
// Version: v0.5.4
// File: lib/widgets/match_detail/odds_card.dart
// ===========================================

import 'package:flutter/material.dart';

import '../../models/app_match.dart';

class OddsCard extends StatelessWidget {
  final AppMatch match;

  const OddsCard({
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
                  Icons.query_stats,
                  color: Color(0xFF1976D2),
                ),
                SizedBox(width: 8),
                Text(
                  "Szorzók",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 18),

            Row(
              children: [
                Expanded(
                  child: _oddBox(
                    title: "1",
                    value: match.homeOdd,
                    selected:
                        match.prediction.toLowerCase() ==
                        "hazai",
                  ),
                ),

                const SizedBox(width: 10),

                Expanded(
                  child: _oddBox(
                    title: "X",
                    value: match.drawOdd,
                    selected:
                        match.prediction.toLowerCase() ==
                        "döntetlen",
                  ),
                ),

                const SizedBox(width: 10),

                Expanded(
                  child: _oddBox(
                    title: "2",
                    value: match.awayOdd,
                    selected:
                        match.prediction.toLowerCase() ==
                        "vendég",
                  ),
                ),
              ],
            ),

            const SizedBox(height: 18),

            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.psychology,
                    color: Color(0xFF1976D2),
                  ),

                  const SizedBox(width: 10),

                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "AI Ajánlás",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(match.prediction),
                      ],
                    ),
                  ),

                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: match.aiScore >= 90
                          ? Colors.green
                          : Colors.orange,
                      borderRadius:
                          BorderRadius.circular(12),
                    ),
                    child: Text(
                      "${match.aiScore}%",
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            if (match.valueBet) ...[
              const SizedBox(height: 16),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.orange.shade100,
                  borderRadius:
                      BorderRadius.circular(14),
                ),
                child: const Row(
                  children: [
                    Icon(
                      Icons.workspace_premium,
                      color: Colors.orange,
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        "AI Value Bet találat",
                        style: TextStyle(
                          color: Colors.orange,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _oddBox({
    required String title,
    required double? value,
    required bool selected,
  }) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      padding: const EdgeInsets.symmetric(
        vertical: 16,
      ),
      decoration: BoxDecoration(
        color: selected
            ? const Color(0xFF1976D2)
            : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: selected
                  ? Colors.white
                  : Colors.black87,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            value == null
                ? "-"
                : value.toStringAsFixed(2),
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: selected
                  ? Colors.white
                  : Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}
