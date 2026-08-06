// ===========================================
// ZSOLT AI PRO 3
// Version: v0.2.0
// File: lib/screens/home/widgets/ai_score_card.dart
// ===========================================

import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

class AiScoreCard extends StatelessWidget {
  const AiScoreCard({super.key, this.score = 0});

  final int score;

  Color get _color {
    if (score >= 90) return AppColors.success;
    if (score >= 80) return const Color(0xFF8BC34A);
    if (score >= 70) return Colors.orange;
    return AppColors.danger;
  }

  String get _label {
    if (score >= 90) return 'Kiváló ajánlás';
    if (score >= 80) return 'Jó ajánlás';
    if (score >= 70) return 'Közepes bizalom';
    if (score > 0) return 'Alacsony bizalom';
    return 'Nincs adat';
  }

  String get _description {
    if (score >= 90) {
      return 'Az AI jelenleg nagyon magas bizalommal ajánlja a mai fő tippet.';
    }
    if (score >= 80) {
      return 'Az AI jó bizalommal áll a mai ajánlás mögött.';
    }
    if (score >= 70) {
      return 'Az AI közepes bizalommal értékeli a mai tippet.';
    }
    if (score > 0) {
      return 'Az AI alacsonyabb bizalommal ad ajánlást – óvatosan.';
    }
    return 'Még nincs elég adat az AI értékeléshez.';
  }

  @override
  Widget build(BuildContext context) {
    final value = (score.clamp(0, 100)) / 100.0;

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
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 90,
                height: 90,
                child: CircularProgressIndicator(
                  value: value,
                  strokeWidth: 8,
                  backgroundColor: Colors.grey.shade300,
                  valueColor: AlwaysStoppedAnimation<Color>(_color),
                ),
              ),
              Text(
                '$score%',
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(width: 22),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'AI Megbízhatóság',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  _description,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Icon(
                      score >= 80 ? Icons.check_circle : Icons.info_outline,
                      color: _color,
                      size: 18,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      _label,
                      style: TextStyle(
                        color: _color,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
