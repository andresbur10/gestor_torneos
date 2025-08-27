import '../domain/models.dart';

Tournament buildSampleTournament() {
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
      MatchEvent(id: 'E1', matchId: 'M1', teamId: 'A', playerId: 'P1', minute: 5, type: EventType.goal),
      MatchEvent(id: 'E2', matchId: 'M1', teamId: 'B', playerId: 'P2', minute: 25, type: EventType.goal),
      MatchEvent(id: 'E3', matchId: 'M1', teamId: 'A', playerId: 'P1', minute: 80, type: EventType.goal),
    ],
  );

  return Tournament(
    id: 'T1',
    name: 'Liga de Prueba',
    teams: [teamA, teamB],
    players: [playerA, playerB],
    matches: [match],
  );
}