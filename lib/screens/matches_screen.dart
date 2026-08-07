// ===========================================
// ZSOLT AI PRO 3
// Version: v0.3.3
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
  final MatchRepository _repository = MatchRepository();

  List<AppMatch> _matches = [];
  bool _loading = true;
  bool _onlyFavourites = false;
  bool _isMock = true;
  String? _statusMessage;

  int selectedDay = 0;
  int selectedFilter = 0;
  String search = '';

  int get _dayOffset => selectedDay;

  @override
  void initState() {
    super.initState();
    _loadMatches(forceRefresh: true);
  }

  Future<void> _loadMatches({bool forceRefresh = false}) async {
    setState(() {
      _loading = true;
      _statusMessage = null;
    });

    try {
      if (forceRefresh) {
        _repository.clearCache();
      }

      final matches = await _repository.getMatches(
        forceRefresh: forceRefresh,
        dayOffset: _dayOffset,
      );

      if (!mounted) return;
      setState(() {
        _matches = matches;
        _isMock = _repository.lastFetchWasMock;
        _loading = false;
        if (_isMock) {
          _statusMessage =
              'Demo: ${_repository.lastError ?? "API üres vagy hiba"}';
        } else {
          _statusMessage = 'Élő StatPal adatok (${matches.length} meccs)';
        }
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _isMock = true;
        _statusMessage = 'Hiba: $e';
      });
    }
  }

  void _toggleFavourite(AppMatch match) {
    setState(() {
      _matches = _matches.map((m) {
        if (m.id != match.id) return m;
        return m.copyWith(favourite: !m.favourite);
      }).toList();
    });
  }

  List<AppMatch> get _filteredMatches {
    var result = List<AppMatch>.from(_matches);

    if (search.trim().isNotEmpty) {
      result = _repository.search(result, search);
    }

    if (_onlyFavourites || selectedFilter == 3) {
      result = _repository.favouritesOnly(result);
    } else if (selectedFilter == 1) {
      result = result.where((m) => m.aiScore >= 80).toList();
    } else if (selectedFilter == 2) {
      result = _repository.valueBetsOnly(result);
    } else if (selectedFilter == 4) {
      result = result.where((m) => m.live).toList();
    }

    return result;
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filteredMatches;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text(
          'Mérkőzések',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.black87),
            onPressed: _loading
                ? null
                : () => _loadMatches(forceRefresh: true),
          ),
        ],
      ),
      body: Column(
        children: [
          if (_statusMessage != null)
            Container(
              width: double.infinity,
              color: _isMock
                  ? Colors.orange.shade100
                  : Colors.green.shade100,
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
              child: Text(
                _statusMessage!,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: _isMock
                      ? Colors.orange.shade900
                      : Colors.green.shade900,
                ),
              ),
            ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            child: Column(
              children: [
                MatchesSearchBar(
                  onChanged: (value) {
                    setState(() => search = value);
                  },
                ),
                const SizedBox(height: 16),
                DaySelector(
                  selectedIndex: selectedDay,
                  onSelected: (index) {
                    setState(() => selectedDay = index);
                    _loadMatches(forceRefresh: true);
                  },
                ),
                const SizedBox(height: 16),
                FilterBar(
                  selectedIndex: selectedFilter,
                  onSelected: (index) {
                    setState(() {
                      selectedFilter = index;
                      _onlyFavourites = index == 3;
                    });
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: _loading
                ? const Center(child: CircularProgressIndicator())
                : RefreshIndicator(
                    onRefresh: () => _loadMatches(forceRefresh: true),
                    child: filtered.isEmpty
                        ? ListView(
                            physics:
                                const AlwaysScrollableScrollPhysics(),
                            children: const [
                              SizedBox(height: 120),
                              Center(child: Text('Nincs találat.')),
                            ],
                          )
                        : _buildMatchList(filtered),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildMatchList(List<AppMatch> matches) {
    String? currentLeague;

    return ListView.builder(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: matches.length,
      itemBuilder: (context, index) {
        final match = matches[index];
        final showLeague = currentLeague != match.leagueName;

        if (showLeague) {
          currentLeague = match.leagueName;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              LeagueHeader(
                leagueName: match.leagueName,
                country: match.country,
                matchCount: matches
                    .where((m) => m.leagueName == match.leagueName)
                    .length,
              ),
              MatchCard(
                match: match,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          MatchDetailScreen(match: match),
                    ),
                  );
                },
                onFavouriteTap: () => _toggleFavourite(match),
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
                builder: (_) => MatchDetailScreen(match: match),
              ),
            );
          },
          onFavouriteTap: () => _toggleFavourite(match),
        );
      },
    );
  }
}
