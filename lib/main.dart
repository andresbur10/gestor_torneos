import 'package:flutter/material.dart';
import 'package:gestor_torneos/domain/stats.dart';
import 'domain/standings.dart';
import 'domain/models.dart';
import 'ui/create_tournament_page.dart';
import 'ui/create_players_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Builder(
        builder: (context) => Scaffold(
          appBar: AppBar(title: const Text('Gestor de Torneos')),
          body: Center(
            child: ElevatedButton(
              onPressed: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const CreateTournamentPage(),
                  ),
                );

                if (result != null) {
                  final players = await Navigator.push(
                    // ignore: use_build_context_synchronously
                    context,
                    MaterialPageRoute(
                      builder: (_) => CreatePlayersPage(teams: result['teams']),
                    ),
                  );

                  if (players != null) {
                    final tournament = Tournament(
                      id: 'T1',
                      name: result['name'],
                      teams: result['teams'],
                      players: players,
                      matches: [],
                    );

                    final standings = computeStandings(tournament);
                    final scorers = computeTopScorers(tournament);
                    final teamsById = {for (var t in tournament.teams) t.id: t};
                    final playersById = {
                      for (var p in tournament.players) p.id: p,
                    };

                    Navigator.push(
                      // ignore: use_build_context_synchronously
                      context,
                      MaterialPageRoute(
                        builder: (_) => Scaffold(
                          appBar: AppBar(
                            title: Text('Tabla de ${tournament.name}'),
                          ),
                          body: ListView(
                            padding: const EdgeInsets.all(16),
                            children: [
                              const Text(
                                'Tabla de posiciones',
                                style: TextStyle(fontSize: 20),
                              ),
                              for (final row in standings)
                                Text(
                                  '${teamsById[row.teamId]!.name}: ${row.points} pts',
                                ),

                              const SizedBox(height: 20),
                              const Text(
                                'Goleadores',
                                style: TextStyle(fontSize: 20),
                              ),
                              for (final s in scorers)
                                Text(
                                  '${playersById[s.playerId]!.name} - ${s.goals} goles',
                                ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }
                }
              },
              child: const Text('Crear torneo'),
            ),
          ),
        ),
      ),
    );
  }
}
