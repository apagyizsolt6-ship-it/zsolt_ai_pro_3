// ===========================================
// ZSOLT AI PRO 3
// Version: v0.3.6
// File: lib/screens/matches_screen.dart
// ===========================================

import 'package:flutter/material.dart';

import 'matches/widgets/search_bar.dart';
import 'matches/widgets/day_selector.dart';
import 'matches/widgets/filter_bar.dart';
import 'matches/widgets/league_header.dart';
import 'matches/widgets/match_card.dart';

class MatchesScreen extends StatefulWidget {
  const MatchesScreen({super.key});

  @override
  State<MatchesScreen> createState() => _MatchesScreenState();
}

class _MatchesScreenState extends State<MatchesScreen> {
  int selectedDay = 0;
  int selectedFilter = 0;
  String search = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text(
          "Mérkőzések",
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          MatchesSearchBar(
            onChanged: (value) {
              setState(() {
                search = value;
              });
            },
          ),

          const SizedBox(height: 16),

          DaySelector(
            selectedIndex: selectedDay,
            onSelected: (index) {
              setState(() {
                selectedDay = index;
              });
            },
          ),

          const SizedBox(height: 16),

          FilterBar(
            selectedIndex: selectedFilter,
            onSelected: (index) {
              setState(() {
                selectedFilter = index;
              });
            },
          ),

          const SizedBox(height: 24),

          const LeagueHeader(
            leagueName: "Premier League",
            country: "Anglia",
            matchCount: 2,
          ),

          MatchCard(
            homeTeam: "Liverpool",
            awayTeam: "Chelsea",
            matchTime: "18:30",
            aiScore: "94%",
            isValueBet: true,
            onTap: () {},
          ),

          MatchCard(
            homeTeam: "Arsenal",
            awayTeam: "Tottenham",
            matchTime: "21:00",
            aiScore: "88%",
            isValueBet: false,
            onTap: () {},
          ),

          const LeagueHeader(
            leagueName: "La Liga",
            country: "Spanyolország",
            matchCount: 1,
          ),

          MatchCard(
            homeTeam: "Barcelona",
            awayTeam: "Valencia",
            matchTime: "20:45",
            aiScore: "91%",
            isValueBet: true,
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
