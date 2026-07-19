// ===========================================
// ZSOLT AI PRO 3
// Version: v0.1.1
// File: lib/screens/home/widgets/ai_tip_card.dart
// ===========================================

import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

class AiTipCard extends StatelessWidget {
  const AiTipCard({super.key});

  @override
  Widget build(BuildContext context) {
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

          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Mai AI Tipp",
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                  ),
                ),

                SizedBox(height: 6),

                Text(
                  "Liverpool győzelem",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),

                SizedBox(height: 8),

                Text(
                  "Premier League",
                  style: TextStyle(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),

          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
            decoration: BoxDecoration(
              color: AppColors.success,
              borderRadius: BorderRadius.circular(18),
            ),
            child: const Column(
              children: [
                Text(
                  "94%",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                  ),
                ),
                Text(
                  "AI",
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
