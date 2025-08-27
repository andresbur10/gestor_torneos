import 'package:flutter_test/flutter_test.dart';
import 'package:gestor_torneos/domain/models.dart';
import 'package:gestor_torneos/domain/stats.dart';

void main() {
  test('cuenta goles correctamente y excluye autogoles', () {
    final teamA = Team(id: 'A', name: 'Alpha');
    final teamB = Team(id: 'B', name: 'Beta');

    final p1 = Player(id: 'P1', teamId: 'A', name: 'Andrés');
    final p2 = Player(id: 'P2', teamId: 'B', name: 'Bruno');

    final match = Match(
      id: 'M1',
      tournamentId: 'T1',
      homeTeamId: 'A',
      awayTeamId: 'B',
      events: [
        MatchEvent(id: 'E1', matchId: 'M1', teamId: 'A', playerId: 'P1', minute: 5, type: EventType.goal),
        MatchEvent(id: 'E2', matchId: 'M1', teamId: 'A', playerId: 'P1', minute: 35, type: EventType.goal),
        MatchEvent(id: 'E3', matchId: 'M1', teamId: 'B', playerId: 'P2', minute: 50, type: EventType.goal),
        MatchEvent(id: 'E4', matchId: 'M1', teamId: 'A', minute: 70, type: EventType.ownGoal),
      ],
    );

    final tournament = Tournament(
      id: 'T1',
      name: 'Liga de Prueba',
      teams: [teamA, teamB],
      players: [p1, p2],
      matches: [match],
    );

    final scorers = computeTopScorers(tournament);

    expect(scorers.first.playerId, 'P1');
    expect(scorers.first.goals, 2);

    expect(scorers[1].playerId, 'P2');
    expect(scorers[1].goals, 1);
  });
}