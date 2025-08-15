enum EventType { goal, ownGoal, yellow, red, penaltyMiss }

class Team {
  final String id;
  final String name;
  Team({required this.id, required this.name});
}

class Player {
  final String id;
  final String teamId;
  final String name;
  Player({required this.id, required this.teamId, required this.name});
}

class MatchEvent {
  final String id;
  final String matchId;
  final String teamId;   // equipo al que se asocia el evento
  final String? playerId;
  final int minute;      // 0–120
  final EventType type;
  MatchEvent({
    required this.id,
    required this.matchId,
    required this.teamId,
    this.playerId,
    required this.minute,
    required this.type,
  });
}

class Match {
  final String id;
  final String tournamentId;
  final String homeTeamId;
  final String awayTeamId;
  final DateTime? kickoff;
  final List<MatchEvent> events;
  Match({
    required this.id,
    required this.tournamentId,
    required this.homeTeamId,
    required this.awayTeamId,
    this.kickoff,
    this.events = const [],
  });

  Match copyWith({List<MatchEvent>? events}) => Match(
    id: id,
    tournamentId: tournamentId,
    homeTeamId: homeTeamId,
    awayTeamId: awayTeamId,
    kickoff: kickoff,
    events: events ?? this.events,
  );
}

class Tournament {
  final String id;
  final String name;
  final List<Team> teams;
  final List<Player> players;
  final List<Match> matches;
  Tournament({
    required this.id,
    required this.name,
    this.teams = const [],
    this.players = const [],
    this.matches = const [],
  });
}

class StandingRow {
  final String teamId;
  final int played, won, draw, lost, gf, ga, points;
  int get gd => gf - ga;
  StandingRow({
    required this.teamId,
    this.played = 0,
    this.won = 0,
    this.draw = 0,
    this.lost = 0,
    this.gf = 0,
    this.ga = 0,
    this.points = 0,
  });

  StandingRow add({
    int played = 0, int won = 0, int draw = 0, int lost = 0,
    int gf = 0, int ga = 0, int points = 0,
  }) => StandingRow(
    teamId: teamId,
    played: this.played + played,
    won: this.won + won,
    draw: this.draw + draw,
    lost: this.lost + lost,
    gf: this.gf + gf,
    ga: this.ga + ga,
    points: this.points + points,
  );
}