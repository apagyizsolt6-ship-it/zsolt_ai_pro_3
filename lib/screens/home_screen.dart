// ===========================================
// ZSOLT AI PRO 3
// Version: v0.2.0
// File: lib/screens/home_screen.dart
// ===========================================

import 'package:flutter/material.dart';

import 'home/widgets/welcome_card.dart';
import 'home/widgets/ai_tip_card.dart';
import 'home/widgets/ai_score_card.dart';
import 'home/widgets/quick_actions_card.dart';
import 'home/widgets/next_matches_card.dart';
import 'home/widgets/top_tips_card.dart';
import 'home/widgets/value_bet_card.dart';
import 'home/widgets/new_card.dart';

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

            children: const [

              /// Welcome
              WelcomeCard(),

              SizedBox(height: 18),

              /// AI Tipp
              AiTipCard(),

              SizedBox(height: 18),

              /// AI Score
              AiScoreCard(),

              SizedBox(height: 18),

              /// Gyors műveletek
              QuickActionsCard(),

              SizedBox(height: 18),

              /// Következő meccsek
              NextMatchesCard(),

              SizedBox(height: 18),

              /// Top Tippek
              TopTipsCard(),

              SizedBox(height: 18),

              /// Value Bet
              ValueBetCard(),

              SizedBox(height: 18),

              /// Hírek
              NewsCard(),

              SizedBox(height: 28),

              Center(
                child: Text(
                  "ZSOLT AI PRO 3",
                  style: TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              SizedBox(height: 6),

              Center(
                child: Text(
                  "Version 0.2.0",
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),
              ),

              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
