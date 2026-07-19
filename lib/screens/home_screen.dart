// ===========================================
// ZSOLT AI PRO 3
// Version: v0.0.6
// File: lib/screens/home_screen.dart
// ===========================================

import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';
import '../widgets/app_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text("ZSOLT AI PRO 3"),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.notifications_none),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              gradient: const LinearGradient(
                colors: [
                  AppColors.gradientStart,
                  AppColors.gradientEnd,
                ],
              ),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Üdv újra! 👋",
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  "Készen állsz a mai meccsekre?",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          const AppCard(
            child: Column(
              children: [
                Icon(
                  Icons.auto_awesome,
                  color: AppColors.success,
                  size: 52,
                ),
                SizedBox(height: 12),
                Text(
                  "Mai AI Tipp",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  "Liverpool győzelem",
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
                SizedBox(height: 12),
                Text(
                  "AI Bizalom: 94%",
                  style: TextStyle(
                    color: AppColors.success,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 18),

          Row(
            children: [
              Expanded(
                child: AppCard(
                  child: Column(
                    children: const [
                      Icon(
                        Icons.sports_soccer,
                        color: AppColors.primary,
                        size: 36,
                      ),
                      SizedBox(height: 10),
                      Text(
                        "24",
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text("Mai meccs"),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: AppCard(
                  child: Column(
                    children: const [
                      Icon(
                        Icons.star,
                        color: Colors.orange,
                        size: 36,
                      ),
                      SizedBox(height: 10),
                      Text(
                        "5",
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text("Top Tipp"),
                    ],
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          const Text(
            "Következő mérkőzések",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 12),

          const AppCard(
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: AppColors.primary,
                child: Icon(
                  Icons.sports_soccer,
                  color: Colors.white,
                ),
              ),
              title: Text("Liverpool - Chelsea"),
              subtitle: Text("Premier League"),
              trailing: Text(
                "18:30",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          const SizedBox(height: 12),

          const AppCard(
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: AppColors.success,
                child: Icon(
                  Icons.sports_soccer,
                  color: Colors.white,
                ),
              ),
              title: Text("Barcelona - Valencia"),
              subtitle: Text("La Liga"),
              trailing: Text(
                "21:00",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          const SizedBox(height: 30),
        ],
      ),
    );
  }
}
