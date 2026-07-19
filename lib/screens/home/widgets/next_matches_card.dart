// ===========================================
// ZSOLT AI PRO 3
// Version: v0.1.4
// File: lib/screens/home/widgets/next_matches_card.dart
// ===========================================

import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

class NextMatchesCard extends StatelessWidget {
  const NextMatchesCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 18,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Következő mérkőzések",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),

          const SizedBox(height: 18),

          const _MatchTile(
            league: "Premier League",
            home: "Liverpool",
            away: "Chelsea",
            time: "18:30",
            ai: 94,
            valueBet: true,
          ),

          const Divider(),

          const _MatchTile(
            league: "La Liga",
            home: "Barcelona",
            away: "Valencia",
            time: "21:00",
            ai: 89,
            valueBet: false,
          ),

          const Divider(),

          const _MatchTile(
            league: "Serie A",
            home: "Inter",
            away: "Juventus",
            time: "20:45",
            ai: 81,
            valueBet: true,
          ),
        ],
      ),
    );
  }
}

class _MatchTile extends StatelessWidget {
  final String league;
  final String home;
  final String away;
  final String time;
  final int ai;
  final bool valueBet;

  const _MatchTile({
    required this.league,
    required this.home,
    required this.away,
    required this.time,
    required this.ai,
    required this.valueBet,
  });

  Color get aiColor {
    if (ai >= 90) return AppColors.success;
    if (ai >= 80) return Colors.orange;
    return Colors.red;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          CircleAvatar(
            radius: 22,
            backgroundColor: AppColors.primary.withOpacity(0.10),
            child: const Icon(
              Icons.sports_soccer,
              color: AppColors.primary,
            ),
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  league,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 13,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  "$home  vs  $away",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  time,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),

          Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: aiColor,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  "$ai%",
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              if (valueBet) ...[
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.success.withOpacity(0.10),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    "VALUE",
                    style: TextStyle(
                      color: AppColors.success,
                      fontWeight: FontWeight.bold,
                      fontSize: 11,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
