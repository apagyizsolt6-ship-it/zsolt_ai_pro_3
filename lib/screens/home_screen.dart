// ===========================================
// ZSOLT AI PRO 3
// Version: v0.3.0
// File: lib/screens/home_screen.dart
// ===========================================

import 'package:flutter/material.dart';

import '../models/app_match.dart';
import '../repositories/match_repository.dart';
import 'home/widgets/ai_score_card.dart';
import 'home/widgets/ai_tip_card.dart';
import 'home/widgets/news_card.dart';
import 'home/widgets/next_matches_card.dart';
import 'home/widgets/quick_actions_card.dart';
import 'home/widgets/top_tips_card.dart';
import 'home/widgets/value_bet_card.dart';
import 'home/widgets/welcome_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, this.onSwitchTab});

  /// 0=Kezdőlap, 1=Meccsek, 2=AI, 3=Szelvény, 4=Profil
  final void Function(int index)? onSwitchTab;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final MatchRepository _repository = MatchRepository();

  List<AppMatch> _matches = [];
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load({bool forceRefresh = false}) async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final matches = await _repository.getMatches(
        forceRefresh: forceRefresh,
      );
      if (!mounted) return;
      setState(() {
        _matches = matches;
        _loading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _error = 'Nem sikerült betölteni a meccseket.';
      });
    }
  }

  AppMatch? get _topTip {
    if (_matches.isEmpty) return null;
    final sorted = List<AppMatch>.from(_matches)
      ..sort((a, b) => b.aiScore.compareTo(a.aiScore));
    return sorted.first;
  }

  List<AppMatch> get _nextMatches {
    final sorted = List<AppMatch>.from(_matches)
      ..sort((a, b) => a.kickoff.compareTo(b.kickoff));
    return sorted.take(4).toList();
  }

  List<AppMatch> get _topTips {
    final withScore = _matches.where((m) => m.aiScore > 0).toList()
      ..sort((a, b) => b.aiScore.compareTo(a.aiScore));
    return withScore.take(3).toList();
  }

  AppMatch? get _bestValueBet {
    final values = _repository.valueBetsOnly(_matches);
    if (values.isEmpty) return null;
    values.sort((a, b) => b.aiScore.compareTo(a.aiScore));
    return values.first;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () => _load(forceRefresh: true),
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 28),
            children: [
              const WelcomeCard(),
              const SizedBox(height: 18),
              if (_loading && _matches.isEmpty)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 48),
                  child: Center(child: CircularProgressIndicator()),
                )
              else if (_error != null && _matches.isEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 32),
                  child: Column(
                    children: [
                      Text(
                        _error!,
                        style: const TextStyle(color: Colors.red),
                      ),
                      const SizedBox(height: 12),
                      TextButton(
                        onPressed: () => _load(forceRefresh: true),
                        child: const Text('Újrapróbálás'),
                      ),
                    ],
                  ),
                )
              else ...[
                AiTipCard(match: _topTip),
                const SizedBox(height: 18),
                AiScoreCard(score: _topTip?.aiScore ?? 0),
                const SizedBox(height: 18),
                QuickActionsCard(onSwitchTab: widget.onSwitchTab),
                const SizedBox(height: 18),
                NextMatchesCard(matches: _nextMatches),
                const SizedBox(height: 18),
                TopTipsCard(matches: _topTips),
                const SizedBox(height: 18),
                ValueBetCard(match: _bestValueBet),
                const SizedBox(height: 18),
                const NewsCard(),
              ],
              const SizedBox(height: 28),
              const Center(
                child: Text(
                  'ZSOLT AI PRO 3',
                  style: TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 6),
              const Center(
                child: Text(
                  'Version 0.3.0',
                  style: TextStyle(color: Colors.grey),
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
