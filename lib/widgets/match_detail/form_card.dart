// ===========================================
// ZSOLT AI PRO 3
// Version: v0.5.7
// File: lib/widgets/match_detail/form_card.dart
// ===========================================

import 'package:flutter/material.dart';

import '../../models/app_match.dart';

class FormCard extends StatelessWidget {
  final AppMatch match;

  const FormCard({
    super.key,
    required this.match,
  });

  @override
  Widget build(BuildContext context) {
    const homeForm = ["W", "W", "D", "L", "W"];
    const awayForm = ["L", "D", "W", "L", "D"];

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
                  Icons.trending_up,
                  color: Color(0xFF1976D2),
                ),
                SizedBox(width: 8),
                Text(
                  "Csapatforma",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            _buildTeam(
              team: match.homeTeam,
              results: homeForm,
            ),

            const SizedBox(height: 20),

            _buildTeam(
              team: match.awayTeam,
              results: awayForm,
            ),

            const Divider(height: 30),

            Row(
              children: [
                const Icon(
                  Icons.psychology,
                  color: Color(0xFF1976D2),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    match.aiScore >= 85
                        ? "Az AI szerint a hazai csapat jobb formában van."
                        : "Az AI kiegyenlített formát érzékel.",
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
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

  Widget _buildTeam({
    required String team,
    required List<String> results,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          team,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),

        const SizedBox(height: 10),

        Row(
          children: results
              .map(
                (result) => Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: _resultCircle(result),
                ),
              )
              .toList(),
        ),
      ],
    );
  }

  Widget _resultCircle(String result) {
    Color color;

    switch (result) {
      case "W":
        color = Colors.green;
        break;
      case "D":
        color = Colors.orange;
        break;
      default:
        color = Colors.red;
    }

    return Container(
      width: 34,
      height: 34,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          result,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
