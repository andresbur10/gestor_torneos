import 'models.dart';

// Calcula la tabla desde los eventos (sin guardar agregados)
List<StandingRow> computeStandings(Tournament t) {
  final rows = <String, StandingRow>{
    for (final team in t.teams) team.id: StandingRow(teamId: team.id),
  };

  for (final m in t.matches) {
    final home = m.homeTeamId, away = m.awayTeamId;

    final homeGf = _goalsFor(m, home);
    final awayGf = _goalsFor(m, away);

    int homePts = 0, awayPts = 0;
    if (homeGf > awayGf) { homePts = 3; }
    else if (homeGf < awayGf) { awayPts = 3; }
    else { homePts = 1; awayPts = 1; }

    rows[home] = rows[home]!.add(
      played: 1, gf: homeGf, ga: awayGf, points: homePts,
      won: homePts==3?1:0, draw: homePts==1?1:0, lost: homePts==0?1:0,
    );
    rows[away] = rows[away]!.add(
      played: 1, gf: awayGf, ga: homeGf, points: awayPts,
      won: awayPts==3?1:0, draw: awayPts==1?1:0, lost: awayPts==0?1:0,
    );
  }

  final list = rows.values.toList();
  list.sort((a, b) {
    final byPts = b.points.compareTo(a.points);
    if (byPts != 0) return byPts;
    final byGd = b.gd.compareTo(a.gd);
    if (byGd != 0) return byGd;
    final byGf = b.gf.compareTo(a.gf);
    if (byGf != 0) return byGf;
    return a.teamId.compareTo(b.teamId); // determinismo
  });
  return list;
}

int _goalsFor(Match m, String teamId) {
  int gf = 0;
  for (final e in m.events) {
    if (e.type == EventType.goal && e.teamId == teamId) gf++;
    if (e.type == EventType.ownGoal && e.teamId != teamId) gf++; // autogol favorece al rival
  }
  return gf;
}