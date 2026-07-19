// ===========================================
// ZSOLT AI PRO 3
// Version: v0.4.3
// File: lib/screens/matches_screen.dart
// ===========================================

import 'package:flutter/material.dart';

import '../models/app_match.dart';
import '../repositories/match_repository.dart';

import 'matches/widgets/day_selector.dart';
import 'matches/widgets/filter_bar.dart';
import 'matches/widgets/league_header.dart';
import 'matches/widgets/match_card.dart';
import 'matches/widgets/search_bar.dart';

class MatchesScreen extends StatefulWidget {
  const MatchesScreen({super.key});

  @override
  State<MatchesScreen> createState() => _MatchesScreenState();
}

class _MatchesScreenState extends State<MatchesScreen> {
  final MatchRepository _repository = const MatchRepository();

  late Future<List<AppMatch>> _matchesFuture;

  int selectedDay = 0;
  int selectedFilter = 0;
  String search = "";

  @override
  void initState() {
    super.initState();
    _matchesFuture = _repository.getMatches();
  }

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
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            child: Column(
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
              ],
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: FutureBuilder<List<AppMatch>>(
              future: _matchesFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      "Hiba történt:\n${snapshot.error}",
                      textAlign: TextAlign.center,
                    ),
                  );
                }

                final matches = snapshot.data ?? [];

                if (matches.isEmpty) {
                  return const Center(
                    child: Text("Nincs elérhető mérkőzés."),
                  );
                }

                final filtered = matches.where((match) {
                  if (search.isEmpty) return true;

                  final text = search.toLowerCase();

                  return match.homeTeam.toLowerCase().contains(text) ||
                      match.awayTeam.toLowerCase().contains(text) ||
                      match.leagueName.toLowerCase().contains(text);
                }).toList();

                String? currentLeague;

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: filtered.length,
                  itemBuilder: (context, index) {
                    final match = filtered[index];

                    final showLeague =
                        currentLeague != match.leagueName;

                    if (showLeague) {
                      currentLeague = match.leagueName;

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          LeagueHeader(
                            leagueName: match.leagueName,
                            country: match.country,
                            matchCount: filtered
                                .where((m) =>
                                    m.leagueName ==
                                    match.leagueName)
                                .length,
                          ),
                          MatchCard(
                            match: match,
                            onTap: () {},
                          ),
                        ],
                      );
                    }

                    return MatchCard(
                      match: match,
                      onTap: () {},
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
