import 'package:flutter/material.dart';

import 'domain/models.dart';
import 'domain/standings.dart';
import 'domain/stats.dart';

import 'ui/create_tournament_page.dart';
import 'ui/create_players_page.dart';
import 'ui/create_match_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Gestor de Torneos')),
      body: Center(
        child: ElevatedButton(
          onPressed: _startFlow,
          child: const Text('Crear torneo'),
        ),
      ),
    );
  }

  Future<void> _startFlow() async {
    // 1) Crear torneo y equipos
    final result = await Navigator.push<Map<String, dynamic>?>(
      context,
      MaterialPageRoute(builder: (_) => const CreateTournamentPage()),
    );
    if (!mounted || result == null) return;

    final List<Team> teams = List<Team>.from(result['teams'] as List<Team>);
    final String name = result['name'] as String;

    // 2) Crear jugadores
    final players = await Navigator.push<List<Player>?>(
      context,
      MaterialPageRoute(builder: (_) => CreatePlayersPage(teams: teams)),
    );
    if (!mounted || players == null) return;

    final tournament = Tournament(
      id: 'T1',
      name: name,
      teams: teams,
      players: players,
      matches: const [],
    );

    // 3) Registrar partido y eventos (opcional: el usuario puede cancelar)
    final match = await Navigator.push<Match?>(
      context,
      MaterialPageRoute(builder: (_) => CreateMatchPage(tournament: tournament)),
    );
    if (!mounted) return;

    final updatedTournament = (match != null)
        ? Tournament(
            id: tournament.id,
            name: tournament.name,
            teams: tournament.teams,
            players: tournament.players,
            matches: [match],
          )
        : tournament;

    // 4) Calcular y mostrar resultados
    final standings = computeStandings(updatedTournament);
    final scorers = computeTopScorers(updatedTournament);

    final teamsById = {for (final t in updatedTournament.teams) t.id: t};
    final playersById = {for (final p in updatedTournament.players) p.id: p};

    if (!mounted) return;
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ResultsPage(
          tournamentName: updatedTournament.name,
          standings: standings,
          scorers: scorers,
          teamsById: teamsById,
          playersById: playersById,
        ),
      ),
    );
  }
}

class ResultsPage extends StatelessWidget {
  final String tournamentName;
  final List<StandingRow> standings;
  final List<TopScorer> scorers;
  final Map<String, Team> teamsById;
  final Map<String, Player> playersById;

  const ResultsPage({
    super.key,
    required this.tournamentName,
    required this.standings,
    required this.scorers,
    required this.teamsById,
    required this.playersById,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Resultados $tournamentName')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Tabla de posiciones',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          for (final row in standings)
            Text(
              '${teamsById[row.teamId]!.name}: '
              '${row.points} pts (GF: ${row.gf}, GA: ${row.ga})',
            ),
          const SizedBox(height: 20),
          const Text(
            'Goleadores',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          if (scorers.isEmpty) const Text('(Sin goles registrados)'),
          for (final s in scorers)
            Text('${playersById[s.playerId]!.name} - ${s.goals} goles'),
        ],
      ),
    );
  }
}