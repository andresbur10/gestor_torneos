import 'package:flutter/material.dart';
import '../domain/models.dart';

class CreateMatchPage extends StatefulWidget {
  final Tournament tournament;

  const CreateMatchPage({super.key, required this.tournament});

  @override
  State<CreateMatchPage> createState() => _CreateMatchPageState();
}

class _CreateMatchPageState extends State<CreateMatchPage> {
  String? _homeTeamId;
  String? _awayTeamId;
  final List<MatchEvent> _events = [];
  int _eventCounter = 0;

  void _addEvent(EventType type, String teamId, String? playerId, int minute) {
    setState(() {
      _eventCounter++;
      _events.add(
        MatchEvent(
          id: 'E$_eventCounter',
          matchId: 'M1', // en el futuro podrías hacerlo dinámico
          teamId: teamId,
          playerId: playerId,
          minute: minute,
          type: type,
        ),
      );
    });
  }

  void _finish() {
    if (_homeTeamId == null || _awayTeamId == null) return;
    final match = Match(
      id: 'M1',
      tournamentId: widget.tournament.id,
      homeTeamId: _homeTeamId!,
      awayTeamId: _awayTeamId!,
      events: _events,
    );
    Navigator.pop(context, match);
  }

  @override
  Widget build(BuildContext context) {
    final teams = widget.tournament.teams;
    final players = widget.tournament.players;

    return Scaffold(
      appBar: AppBar(title: const Text('Registrar Partido')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(labelText: 'Equipo Local'),
              items: teams
                  .map((t) => DropdownMenuItem(value: t.id, child: Text(t.name)))
                  .toList(),
              value: _homeTeamId,
              onChanged: (v) => setState(() => _homeTeamId = v),
            ),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(labelText: 'Equipo Visitante'),
              items: teams
                  .map((t) => DropdownMenuItem(value: t.id, child: Text(t.name)))
                  .toList(),
              value: _awayTeamId,
              onChanged: (v) => setState(() => _awayTeamId = v),
            ),
            const SizedBox(height: 16),
            const Text('Eventos:'),
            for (final e in _events)
              Text(
                '${e.minute}\' ${e.type} - ${e.playerId != null ? players.firstWhere((p) => p.id == e.playerId).name : ''}',
              ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                _showAddEventDialog(context, teams, players);
              },
              child: const Text('Agregar evento'),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _finish,
              child: const Text('Guardar Partido'),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddEventDialog(BuildContext ctx, List<Team> teams, List<Player> players) {
    String? selectedTeamId;
    String? selectedPlayerId;
    EventType selectedType = EventType.goal;
    int minute = 0;

    showDialog(
      context: ctx,
      builder: (_) => AlertDialog(
        title: const Text('Nuevo evento'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(labelText: 'Equipo'),
              items: teams
                  .map((t) => DropdownMenuItem(value: t.id, child: Text(t.name)))
                  .toList(),
              onChanged: (v) => selectedTeamId = v,
            ),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(labelText: 'Jugador (opcional)'),
              items: players
                  .map((p) => DropdownMenuItem(value: p.id, child: Text(p.name)))
                  .toList(),
              onChanged: (v) => selectedPlayerId = v,
            ),
            DropdownButtonFormField<EventType>(
              decoration: const InputDecoration(labelText: 'Tipo de evento'),
              items: EventType.values
                  .map((et) => DropdownMenuItem(value: et, child: Text(et.name)))
                  .toList(),
              onChanged: (v) => selectedType = v!,
              value: selectedType,
            ),
            TextField(
              decoration: const InputDecoration(labelText: 'Minuto'),
              keyboardType: TextInputType.number,
              onChanged: (v) => minute = int.tryParse(v) ?? 0,
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancelar')),
          ElevatedButton(
            onPressed: () {
              if (selectedTeamId != null) {
                _addEvent(selectedType, selectedTeamId!, selectedPlayerId, minute);
              }
              Navigator.pop(ctx);
            },
            child: const Text('Agregar'),
          ),
        ],
      ),
    );
  }
}