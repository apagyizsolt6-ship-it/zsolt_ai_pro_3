// ===========================================
// ZSOLT AI PRO 3
// Version: v0.2.1
// File: lib/screens/home_screen.dart
// ===========================================

import 'package:flutter/material.dart';

import 'home/widgets/ai_score_card.dart';
import 'home/widgets/ai_tip_card.dart';
import 'home/widgets/news_card.dart';
import 'home/widgets/next_matches_card.dart';
import 'home/widgets/quick_actions_card.dart';
import 'home/widgets/top_tips_card.dart';
import 'home/widgets/value_bet_card.dart';
import 'home/widgets/welcome_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            await Future.delayed(
              const Duration(milliseconds: 800),
            );
          },
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(
              20,
              18,
              20,
              28,
            ),
            children: [
              const WelcomeCard(),

              const SizedBox(height: 18),

              const AiTipCard(),

              const SizedBox(height: 18),

              const AiScoreCard(),

              const SizedBox(height: 18),

              const QuickActionsCard(),

              const SizedBox(height: 18),

              const NextMatchesCard(),

              const SizedBox(height: 18),

              const TopTipsCard(),

              const SizedBox(height: 18),

              const ValueBetCard(),

              const SizedBox(height: 18),

              const NewsCard(),

              const SizedBox(height: 28),

              const Center(
                child: Text(
                  "ZSOLT AI PRO 3",
                  style: TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(height: 6),

              const Center(
                child: Text(
                  "Version 0.2.1",
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
