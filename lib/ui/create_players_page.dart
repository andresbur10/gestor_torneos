import 'package:flutter/material.dart';
import '../domain/models.dart';

class CreatePlayersPage extends StatefulWidget {
  final List<Team> teams;

  const CreatePlayersPage({super.key, required this.teams});

  @override
  State<CreatePlayersPage> createState() => _CreatePlayersPageState();
}

class _CreatePlayersPageState extends State<CreatePlayersPage> {
  final _playerNameController = TextEditingController();
  String? _selectedTeamId;
  final List<Player> _players = [];

  void _addPlayer() {
    final name = _playerNameController.text.trim();
    if (name.isEmpty || _selectedTeamId == null) return;

    setState(() {
      _players.add(Player(
        id: 'P${_players.length + 1}',
        teamId: _selectedTeamId!,
        name: name,
      ));
      _playerNameController.clear();
    });
  }

  void _finish() {
    if (_players.isEmpty) return;
    Navigator.pop(context, _players);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Agregar jugadores')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(labelText: 'Equipo'),
              items: widget.teams
                  .map((t) => DropdownMenuItem(
                        value: t.id,
                        child: Text(t.name),
                      ))
                  .toList(),
              value: _selectedTeamId,
              onChanged: (value) {
                setState(() {
                  _selectedTeamId = value;
                });
              },
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _playerNameController,
              decoration: InputDecoration(
                labelText: 'Nombre del jugador',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: _addPlayer,
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text('Jugadores agregados:'),
            for (final p in _players)
              Text('- ${p.name} (${widget.teams.firstWhere((t) => t.id == p.teamId).name})'),
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