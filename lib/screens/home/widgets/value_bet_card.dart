// ===========================================
// ZSOLT AI PRO 3
// Version: v0.2.0
// File: lib/screens/home/widgets/value_bet_card.dart
// ===========================================

import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../models/app_match.dart';

class ValueBetCard extends StatelessWidget {
  const ValueBetCard({super.key, this.match});

  final AppMatch? match;

  @override
  Widget build(BuildContext context) {
    final m = match;

    if (m == null) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          color: Colors.grey.shade200,
        ),
        child: const Text(
          'Ma nincs kiemelt value bet.',
          style: TextStyle(
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w600,
          ),
        ),
      );
    }

    final odd = m.homeOdd ?? m.drawOdd ?? m.awayOdd;
    final oddText = odd != null ? odd.toStringAsFixed(2) : '–';
    final tipLabel = m.prediction.isEmpty
        ? '${m.homeTeam} győzelem'
        : '${m.prediction}';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: const LinearGradient(
          colors: [
            Color(0xFF00C853),
            Color(0xFF43A047),
          ],
        ),
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
          const Row(
            children: [
              Icon(Icons.diamond, color: Colors.white, size: 28),
              SizedBox(width: 10),
              Text(
                'Mai Value Bet',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            '${m.homeTeam} - ${m.awayTeam}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Tipp: $tipLabel',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              Expanded(
                child: _InfoBox(title: 'Odds', value: oddText),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _InfoBox(title: 'AI', value: '${m.aiScore}%'),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: _InfoBox(title: 'Érték', value: 'VALUE'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _InfoBox extends StatelessWidget {
  final String title;
  final String value;

  const _InfoBox({
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.18),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
