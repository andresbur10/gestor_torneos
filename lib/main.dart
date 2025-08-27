import 'package:flutter/material.dart';
import 'domain/standings.dart';
import 'domain/stats.dart';
import 'sample_data/sample_tournament.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final tournament = buildSampleTournament();
    final standings = computeStandings(tournament);
    final scorers = computeTopScorers(tournament);

    final teamsById = { for (var t in tournament.teams) t.id: t };
    final playersById = { for (var p in tournament.players) p.id: p };

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Gestor de Torneos')),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: ListView(
            children: [
              const Text('Tabla de posiciones', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              for (final row in standings)
                Text('${teamsById[row.teamId]!.name}: ${row.points} pts (GF: ${row.gf}, GA: ${row.ga})'),

              const SizedBox(height: 20),
              const Text('Goleadores', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              for (final s in scorers)
                Text('${playersById[s.playerId]!.name} - ${s.goals} goles'),
            ],
          ),
        ),
      ),
    );
  }
}