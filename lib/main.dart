import 'package:flutter/material.dart';
import 'domain/models.dart';
import 'domain/standings.dart';
import 'domain/stats.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Datos de ejemplo
    final teamA = Team(id: 'A', name: 'Alpha');
    final teamB = Team(id: 'B', name: 'Beta');
    final playerA = Player(id: 'P1', teamId: 'A', name: 'Andrés');
    final playerB = Player(id: 'P2', teamId: 'B', name: 'Bruno');

    final match = Match(
      id: 'M1',
      tournamentId: 'T1',
      homeTeamId: 'A',
      awayTeamId: 'B',
      events: [
        MatchEvent(
          id: 'E1',
          matchId: 'M1',
          teamId: 'A',
          playerId: 'P1',
          minute: 5,
          type: EventType.goal,
        ),
        MatchEvent(
          id: 'E2',
          matchId: 'M1',
          teamId: 'B',
          playerId: 'P2',
          minute: 25,
          type: EventType.goal,
        ),
        MatchEvent(
          id: 'E3',
          matchId: 'M1',
          teamId: 'A',
          playerId: 'P1',
          minute: 80,
          type: EventType.goal,
        ),
      ],
    );

    final tournament = Tournament(
      id: 'T1',
      name: 'Liga de Prueba',
      teams: [teamA, teamB],
      players: [playerA, playerB],
      matches: [match],
    );

    final standings = computeStandings(tournament);
    final scorers = computeTopScorers(tournament);

    // Mapas para lookup rápido
    final teamsById = {for (var t in tournament.teams) t.id: t};
    final playersById = {for (var p in tournament.players) p.id: p};

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Gestor de Torneos')),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: ListView(
            children: [
              const Text(
                'Tabla de posiciones',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              // Standings
              for (final row in standings)
                Text(
                  '${teamsById[row.teamId]!.name}: '
                  '${row.points} pts (GF: ${row.gf}, GA: ${row.ga})',
                ),

              // Goleadores
              for (final s in scorers)
                Text('${playersById[s.playerId]!.name} - ${s.goals} goles'),
            ],
          ),
        ),
      ),
    );
  }
}
