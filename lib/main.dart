import 'package:flutter/material.dart';
import 'domain/standings.dart';
import 'domain/models.dart';
import 'ui/create_tournament_page.dart';

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
                  final tournament = Tournament(
                    id: 'T1',
                    name: result['name'],
                    teams: result['teams'],
                    players: [], // por ahora vacío
                    matches: [],
                  );

                  final standings = computeStandings(tournament);
                  final teamsById = {for (var t in tournament.teams) t.id: t};

                  Navigator.push(
                    // ignore: use_build_context_synchronously
                    context,
                    MaterialPageRoute(
                      builder: (_) => Scaffold(
                        appBar: AppBar(title: Text('Tabla de ${tournament.name}')),
                        body: ListView(
                          padding: const EdgeInsets.all(16),
                          children: [
                            const Text('Tabla de posiciones', style: TextStyle(fontSize: 20)),
                            for (final row in standings)
                              Text('${teamsById[row.teamId]!.name}: ${row.points} pts'),
                          ],
                        ),
                      ),
                    ),
                  );
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