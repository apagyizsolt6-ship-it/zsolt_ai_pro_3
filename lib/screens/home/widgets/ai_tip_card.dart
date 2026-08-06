// ===========================================
// ZSOLT AI PRO 3
// Version: v0.2.0
// File: lib/screens/home/widgets/ai_tip_card.dart
// ===========================================

import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../models/app_match.dart';

class AiTipCard extends StatelessWidget {
  const AiTipCard({super.key, this.match});

  final AppMatch? match;

  @override
  Widget build(BuildContext context) {
    final m = match;
    final tipText = m == null
        ? 'Nincs elérhető tipp'
        : '${m.homeTeam} – ${m.prediction.isEmpty ? "AI elemzés" : m.prediction}';
    final league = m?.leagueName ?? '';
    final score = m?.aiScore ?? 0;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
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
      child: Row(
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.primary.withOpacity(0.10),
            ),
            child: const Icon(
              Icons.auto_awesome,
              color: AppColors.primary,
              size: 36,
            ),
          ),
          const SizedBox(width: 18),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Mai AI Tipp',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  tipText,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                if (league.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text(
                    league,
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
            decoration: BoxDecoration(
              color: score >= 90
                  ? AppColors.success
                  : score >= 75
                      ? Colors.orange
                      : AppColors.primary,
              borderRadius: BorderRadius.circular(18),
            ),
            child: Column(
              children: [
                Text(
                  '$score%',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                  ),
                ),
                const Text(
                  'AI',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
