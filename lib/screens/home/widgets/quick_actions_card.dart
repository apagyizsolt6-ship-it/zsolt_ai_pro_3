// ===========================================
// ZSOLT AI PRO 3
// Version: v0.3.0
// File: lib/screens/home/widgets/quick_actions_card.dart
// ===========================================

import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

class QuickActionsCard extends StatelessWidget {
  const QuickActionsCard({super.key, this.onSwitchTab});

  /// 0=Kezdőlap, 1=Meccsek, 2=AI, 3=Szelvény, 4=Profil
  final void Function(int index)? onSwitchTab;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
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
            'Gyors műveletek',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _ActionButton(
                  icon: Icons.receipt_long,
                  title: 'Szelvény',
                  color: AppColors.primary,
                  onTap: () => onSwitchTab?.call(3),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: _ActionButton(
                  icon: Icons.sports_soccer,
                  title: 'Meccsek',
                  color: AppColors.success,
                  onTap: () => onSwitchTab?.call(1),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: _ActionButton(
                  icon: Icons.auto_awesome,
                  title: 'AI',
                  color: Colors.orange,
                  onTap: () => onSwitchTab?.call(2),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: _ActionButton(
                  icon: Icons.person,
                  title: 'Profil',
                  color: Colors.purple,
                  onTap: () => onSwitchTab?.call(4),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color color;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.title,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Ink(
          padding: const EdgeInsets.symmetric(
            vertical: 18,
            horizontal: 12,
          ),
          decoration: BoxDecoration(
            color: color.withOpacity(0.08),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            children: [
              CircleAvatar(
                radius: 28,
                backgroundColor: color,
                child: Icon(
                  icon,
                  color: Colors.white,
                  size: 28,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
