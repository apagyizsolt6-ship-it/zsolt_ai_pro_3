// ===========================================
// ZSOLT AI PRO 3
// Version: v0.3.0
// File: lib/screens/matches_screen.dart
// ===========================================

import 'package:flutter/material.dart';

class MatchesScreen extends StatelessWidget {
  const MatchesScreen({super.key});

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
        centerTitle: false,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          TextField(
            decoration: InputDecoration(
              hintText: "Csapat vagy bajnokság keresése...",
              prefixIcon: const Icon(Icons.search),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18),
                borderSide: BorderSide.none,
              ),
            ),
          ),

          const SizedBox(height: 20),

          SizedBox(
            height: 44,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: const [
                _DayChip("Ma", true),
                SizedBox(width: 10),
                _DayChip("Holnap", false),
                SizedBox(width: 10),
                _DayChip("Kedd", false),
                SizedBox(width: 10),
                _DayChip("Szerda", false),
                SizedBox(width: 10),
                _DayChip("Csüt.", false),
              ],
            ),
          ),

          const SizedBox(height: 24),

          const Text(
            "Premier League",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 12),

          const _MatchCard(
            home: "Liverpool",
            away: "Chelsea",
            time: "18:30",
            ai: "94%",
            value: true,
          ),

          const _MatchCard(
            home: "Arsenal",
            away: "Tottenham",
            time: "21:00",
            ai: "87%",
            value: false,
          ),

          const SizedBox(height: 24),

          const Text(
            "La Liga",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 12),

          const _MatchCard(
            home: "Barcelona",
            away: "Valencia",
            time: "20:45",
            ai: "89%",
            value: true,
          ),
        ],
      ),
    );
  }
}

class _DayChip extends StatelessWidget {
  final String text;
  final bool selected;

  const _DayChip(this.text, this.selected);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      decoration: BoxDecoration(
        color: selected ? Colors.blue : Colors.white,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Center(
        child: Text(
          text,
          style: TextStyle(
            color: selected ? Colors.white : Colors.black87,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

class _MatchCard extends StatelessWidget {
  final String home;
  final String away;
  final String time;
  final String ai;
  final bool value;

  const _MatchCard({
    required this.home,
    required this.away,
    required this.time,
    required this.ai,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 14),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Row(
          children: [
            const CircleAvatar(
              radius: 24,
              child: Icon(Icons.sports_soccer),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "$home  vs  $away",
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    time,
                    style: const TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),
            Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Text(
                    ai,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                if (value)
                  Container(
                    margin: const EdgeInsets.only(top: 8),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.green.shade50,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Text(
                      "VALUE",
                      style: TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                        fontSize: 11,
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
