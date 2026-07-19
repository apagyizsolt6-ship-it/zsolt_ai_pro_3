// ===========================================
// ZSOLT AI PRO 3
// Version: v0.5.4
// File: lib/screens/matches_screen.dart
// ===========================================

import 'package:flutter/material.dart';

import '../models/app_match.dart';
import '../repositories/match_repository.dart';
import 'match_detail_screen.dart';

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

  List<AppMatch> _matches = [];

  bool _loading = true;
  bool _onlyFavourites = false;

  int selectedDay = 0;
  int selectedFilter = 0;

  String search = "";

  @override
  void initState() {
    super.initState();
    _loadMatches();
  }

  Future<void> _loadMatches() async {
    try {
      final matches = await _repository.getMatches();

      setState(() {
        _matches = matches;
        _loading = false;
      });
    } catch (_) {
      setState(() {
        _loading = false;
      });
    }
  }

  void _toggleFavourite(AppMatch match) {
    setState(() {
      _matches = _matches.map((m) {
        if (m.id != match.id) return m;

        return m.copyWith(
          favourite: !m.favourite,
        );
      }).toList();
    });
  }

  List<AppMatch> get _filteredMatches {
    List<AppMatch> result = List.from(_matches);

    if (search.trim().isNotEmpty) {
      result = _repository.search(
        result,
        search,
      );
    }

    if (_onlyFavourites) {
      result = _repository.favouritesOnly(
        result,
      );
    }

    return result;
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    final filtered = _filteredMatches;

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
            padding: const EdgeInsets.fromLTRB(
              16,
              16,
              16,
              0,
            ),
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
                      _onlyFavourites = index == 1;
                    });
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          Expanded(
            child: filtered.isEmpty
                ? const Center(
                    child: Text(
                      "Nincs találat.",
                    ),
                  )
                : _buildMatchList(filtered),
          ),
        ],
      ),
    );
  }

  Widget _buildMatchList(
    List<AppMatch> matches,
  ) {
    String? currentLeague;

    return ListView.builder(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
      ),
      itemCount: matches.length,
      itemBuilder: (context, index) {
        final match = matches[index];

        final showLeague =
            currentLeague != match.leagueName;

        if (showLeague) {
          currentLeague = match.leagueName;          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              LeagueHeader(
                leagueName: match.leagueName,
                country: match.country,
                matchCount: matches
                    .where(
                      (m) =>
                          m.leagueName ==
                          match.leagueName,
                    )
                    .length,
              ),
              MatchCard(
                match: match,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => MatchDetailScreen(
                        match: match,
                      ),
                    ),
                  );
                },
                onFavouriteTap: () {
                  _toggleFavourite(match);
                },
              ),
            ],
          );
        }

        return MatchCard(
          match: match,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => MatchDetailScreen(
                  match: match,
                ),
              ),
            );
          },
          onFavouriteTap: () {
            _toggleFavourite(match);
          },
        );
      },
    );
  }
}
