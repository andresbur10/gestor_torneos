import 'package:flutter/material.dart';
import '../domain/models.dart';

class CreateTournamentPage extends StatefulWidget {
  const CreateTournamentPage({super.key});

  @override
  State<CreateTournamentPage> createState() => _CreateTournamentPageState();
}

class _CreateTournamentPageState extends State<CreateTournamentPage> {
  final _tournamentNameController = TextEditingController();
  final _teamNameController = TextEditingController();
  final List<Team> _teams = [];

  void _addTeam() {
    final name = _teamNameController.text.trim();
    if (name.isEmpty) return;

    setState(() {
      _teams.add(Team(id: 'T${_teams.length + 1}', name: name));
      _teamNameController.clear();
    });
  }

  void _finish() {
    final tournamentName = _tournamentNameController.text.trim();
    if (tournamentName.isEmpty || _teams.isEmpty) return;

    // Aquí luego navegamos a la pantalla de partidos o standings
    Navigator.pop(context, {
      'name': tournamentName,
      'teams': _teams,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Crear Torneo')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            TextField(
              controller: _tournamentNameController,
              decoration: const InputDecoration(labelText: 'Nombre del torneo'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _teamNameController,
              decoration: InputDecoration(
                labelText: 'Nombre del equipo',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: _addTeam,
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text('Equipos agregados:'),
            for (final t in _teams) Text('- ${t.name}'),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _finish,
              child: const Text('Continuar'),
            ),
          ],
        ),
      ),
    );
  }
}