import 'models.dart';

class TopScorer {
  final String playerId;
  final String teamId;
  final int goals;

  TopScorer({
    required this.playerId,
    required this.teamId,
    required this.goals,
  });
}

/// Calcula el ranking de goleadores de un torneo.
/// Solo cuenta eventos de tipo `goal` con playerId no nulo.
/// Ignora ownGoal porque es gol en contra.
List<TopScorer> computeTopScorers(Tournament t) {
  // Índice rápido para saber el teamId de cada jugador
  final playersById = { for (final p in t.players) p.id: p };

  // Contador de goles
  final tally = <String, int>{};

  for (final match in t.matches) {
    for (final event in match.events) {
      if (event.type == EventType.goal && event.playerId != null) {
        tally[event.playerId!] = (tally[event.playerId!] ?? 0) + 1;
      }
    }
  }

  // Convertir a lista de TopScorer
  final scorers = [
    for (final entry in tally.entries)
      TopScorer(
        playerId: entry.key,
        teamId: playersById[entry.key]!.teamId,
        goals: entry.value,
      )
  ];

  // Ordenar: primero más goles, luego nombre para desempatar
  scorers.sort((a, b) {
    if (b.goals != a.goals) return b.goals.compareTo(a.goals);
    final nameA = playersById[a.playerId]!.name;
    final nameB = playersById[b.playerId]!.name;
    return nameA.compareTo(nameB);
  });

  return scorers;
}