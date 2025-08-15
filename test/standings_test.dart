import 'package:flutter_test/flutter_test.dart';
import 'package:gestor_torneos/domain/models.dart';
import 'package:gestor_torneos/domain/standings.dart';

void main() {
  test('victoria simple 2-1 otorga 3 puntos al ganador', () {
    final a = Team(id: 'A', name: 'Alpha');
    final b = Team(id: 'B', name: 'Beta');

    final m = Match(
      id: 'M1',
      tournamentId: 'T1',
      homeTeamId: 'A',
      awayTeamId: 'B',
      events: [
        MatchEvent(id: 'e1', matchId: 'M1', teamId: 'A', minute: 10, type: EventType.goal),
        MatchEvent(id: 'e2', matchId: 'M1', teamId: 'B', minute: 30, type: EventType.goal),
        MatchEvent(id: 'e3', matchId: 'M1', teamId: 'A', minute: 75, type: EventType.goal),
      ],
    );

    final t = Tournament(id: 'T1', name: 'Liga', teams: [a, b], matches: [m]);
    final table = computeStandings(t);

    // El primero debe ser A con 3 puntos y gf=2, ga=1
    final leader = table.firstWhere((r) => r.teamId == 'A');
    expect(leader.points, 3);
    expect(leader.gf, 2);
    expect(leader.ga, 1);

    final second = table.firstWhere((r) => r.teamId == 'B');
    expect(second.points, 0);
    expect(second.gf, 1);
    expect(second.ga, 2);
  });

  test('autogol favorece al rival', () {
    final a = Team(id: 'A', name: 'Alpha');
    final b = Team(id: 'B', name: 'Beta');

    final m = Match(
      id: 'M2',
      tournamentId: 'T1',
      homeTeamId: 'A',
      awayTeamId: 'B',
      events: [
        MatchEvent(id: 'e1', matchId: 'M2', teamId: 'A', minute: 40, type: EventType.ownGoal),
      ],
    );

    final t = Tournament(id: 'T1', name: 'Liga', teams: [a, b], matches: [m]);
    final table = computeStandings(t);

    final bRow = table.firstWhere((r) => r.teamId == 'B');
    expect(bRow.points, 3);
    expect(bRow.gf, 1);
    expect(bRow.ga, 0);
  });
}