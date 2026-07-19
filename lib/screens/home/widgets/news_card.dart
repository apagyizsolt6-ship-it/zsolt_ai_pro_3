// ===========================================
// ZSOLT AI PRO 3
// Version: v0.1.7
// File: lib/screens/home/widgets/news_card.dart
// ===========================================

import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

class NewsCard extends StatelessWidget {
  const NewsCard({super.key});

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
        children: const [
          Row(
            children: [
              Icon(
                Icons.newspaper,
                color: AppColors.primary,
              ),
              SizedBox(width: 8),
              Text(
                "Sporthírek",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),

          SizedBox(height: 18),

          _NewsItem(
            title: "Liverpool új csatárt igazolhat",
            source: "Nemzetközi futball",
          ),

          Divider(),

          _NewsItem(
            title: "Barcelona kulcsembere visszatérhet",
            source: "La Liga",
          ),

          Divider(),

          _NewsItem(
            title: "Inter remek formában várja a rangadót",
            source: "Serie A",
          ),
        ],
      ),
    );
  }
}

class _NewsItem extends StatelessWidget {
  final String title;
  final String source;

  const _NewsItem({
    required this.title,
    required this.source,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.10),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(
              Icons.article_outlined,
              color: AppColors.primary,
            ),
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  source,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),

          const Icon(
            Icons.arrow_forward_ios,
            size: 16,
            color: AppColors.textSecondary,
          ),
        ],
      ),
    );
  }
}
