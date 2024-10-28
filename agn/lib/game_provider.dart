// lib/game_provider.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Game {
  final String name;
  final String url;
  final IconData icon;

  Game({
    required this.name,
    required this.url,
    required this.icon,
  });
}

// Provider for the list of games
final gameProvider = Provider<List<Game>>((ref) {
  return [
    Game(
      name: 'Candy Crush',
      url: 'https://poki.com/en/g/sweet-world#fullscreen',
      icon: Icons.bolt,
    ),
    Game(
      name: 'Subway Surfer',
      url: 'https://poki.com/en/g/subway-surfers',
      icon: Icons.train,
    ),
    Game(
      name: 'Temple Run',
      url: 'https://poki.com/en/g/temple-run-2',
      icon: Icons.run_circle,
    ),
  ];
});
