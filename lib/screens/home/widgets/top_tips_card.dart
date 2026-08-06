// ===========================================
// ZSOLT AI PRO 3
// Version: v0.2.0
// File: lib/screens/home/widgets/top_tips_card.dart
// ===========================================

import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../models/app_match.dart';

class TopTipsCard extends StatelessWidget {
  const TopTipsCard({super.key, this.matches = const []});

  final List<AppMatch> matches;

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
            '🔥 Top AI Tippek',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 18),
          if (matches.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 12),
              child: Text(
                'Még nincsenek AI tippek.',
                style: TextStyle(color: AppColors.textSecondary),
              ),
            )
          else
            ...List.generate(matches.length, (index) {
              final m = matches[index];
              final tip = m.prediction.isEmpty
                  ? '${m.homeTeam} tipp'
                  : m.prediction;
              return Column(
                children: [
                  if (index > 0) const Divider(),
                  _TipRow(
                    rank: index + 1,
                    match: '${m.homeTeam} - ${m.awayTeam}',
                    tip: tip,
                    ai: m.aiScore,
                  ),
                ],
              );
            }),
        ],
      ),
    );
  }
}

class _TipRow extends StatelessWidget {
  final int rank;
  final String match;
  final String tip;
  final int ai;

  const _TipRow({
    required this.rank,
    required this.match,
    required this.tip,
    required this.ai,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: AppColors.primary,
            child: Text(
              '$rank',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  match,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  tip,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 8,
            ),
            decoration: BoxDecoration(
              color: ai >= 90 ? AppColors.success : Colors.orange,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              '$ai%',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
