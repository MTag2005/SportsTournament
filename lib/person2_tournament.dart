
// PERSON 2: Matches, tournament rounds, results, statistics and ranking

import 'person1_people_teams.dart';

abstract class Ranked {
  void displayRanking();
}

class Match {
  final int id;
  final Team team1;
  final Team team2;

  int? score1;
  int? score2;

  Match({
    required this.id,
    required this.team1,
    required this.team2,
  });

  bool get hasResult => score1 != null && score2 != null;

  void recordResult(int a, int b) {
    score1 = a;
    score2 = b;
  }

  Team? winner() {
    if (!hasResult || score1 == score2) {
      return null;
    }

    return score1! > score2! ? team1 : team2;
  }

  void display() {
    print(
      'Match $id: ${team1.name} vs ${team2.name} | '
      '${hasResult ? "$score1 - $score2" : "Not played"}',
    );
  }
}

class TournamentSystem implements Ranked {
  final TeamManager manager;

  TournamentSystem(this.manager);

  final List<Match> matches = [];

  final List<List<int>> tournamentRounds = [];

  final Map<String, Map<String, int>> teamStatistics = {};

  // Create statistics for a team the first time it is scheduled
  void _initStats(String name) {
    teamStatistics.putIfAbsent(
      name,
      () => {
        'points': 0,
        'wins': 0,
        'losses': 0,
        'draws': 0,
        'played': 0,
        'goalsFor': 0,
        'goalsAgainst': 0,
      },
    );
  }

  // Schedule a match
  bool scheduleMatch(
    int id,
    String name1,
    String name2,
    int round,
  ) {
    if (id <= 0 || round <= 0 || matches.any((m) => m.id == id)) {
      print('Invalid or duplicate match ID/round.');
      return false;
    }

    final t1 = manager.findTeam(name1);
    final t2 = manager.findTeam(name2);

    if (t1 == null || t2 == null || t1 == t2) {
      print('Both different teams must exist.');
      return false;
    }

    _initStats(t1.name);
    _initStats(t2.name);

    matches.add(
      Match(
        id: id,
        team1: t1,
        team2: t2,
      ),
    );

    while (tournamentRounds.length < round) {
      tournamentRounds.add(<int>[]);
    }

    tournamentRounds[round - 1].add(id);

    print('Match scheduled in round $round.');

    return true;
  }

  // Record match result
  bool recordResult(int id, int a, int b) {
    if (a < 0 || b < 0) {
      print('Scores cannot be negative.');
      return false;
    }

    Match? match;

    for (final m in matches) {
      if (m.id == id) {
        match = m;
        break;
      }
    }

    if (match == null) {
      print('Match not found.');
      return false;
    }

    if (match.hasResult) {
      print('Result already recorded.');
      return false;
    }

    match.recordResult(a, b);

    final s1 = teamStatistics[match.team1.name]!;
    final s2 = teamStatistics[match.team2.name]!;

    // Update played matches
    s1['played'] = s1['played']! + 1;
    s2['played'] = s2['played']! + 1;

    // Update goals
    s1['goalsFor'] = s1['goalsFor']! + a;
    s1['goalsAgainst'] = s1['goalsAgainst']! + b;

    s2['goalsFor'] = s2['goalsFor']! + b;
    s2['goalsAgainst'] = s2['goalsAgainst']! + a;

    // Update points and results
    if (a > b) {
      s1['wins'] = s1['wins']! + 1;
      s1['points'] = s1['points']! + 3;

      s2['losses'] = s2['losses']! + 1;
    } else if (b > a) {
      s2['wins'] = s2['wins']! + 1;
      s2['points'] = s2['points']! + 3;

      s1['losses'] = s1['losses']! + 1;
    } else {
      s1['draws'] = s1['draws']! + 1;
      s2['draws'] = s2['draws']! + 1;

      s1['points'] = s1['points']! + 1;
      s2['points'] = s2['points']! + 1;
    }

    if (match.winner() == null) {
      print('Draw recorded.');
    } else {
      print('Winner: ${match.winner()!.name}');
    }

    return true;
  }

  // Remove a deleted team's matches, round entries and statistics,
  // and undo its played results from the opponents' statistics.
  void removeTeamData(String teamName) {
    final key = teamName.trim().toLowerCase();
    final removed = matches
        .where((m) =>
            m.team1.name.toLowerCase() == key ||
            m.team2.name.toLowerCase() == key)
        .toList();

    for (final m in removed) {
      if (m.hasResult) {
        final deletedIsTeam1 = m.team1.name.toLowerCase() == key;
        final other = deletedIsTeam1 ? m.team2 : m.team1;
        final otherGoals = deletedIsTeam1 ? m.score2! : m.score1!;
        final deletedGoals = deletedIsTeam1 ? m.score1! : m.score2!;
        final s = teamStatistics[other.name];
        if (s != null) {
          s['played'] = s['played']! - 1;
          s['goalsFor'] = s['goalsFor']! - otherGoals;
          s['goalsAgainst'] = s['goalsAgainst']! - deletedGoals;
          if (otherGoals > deletedGoals) {
            s['wins'] = s['wins']! - 1;
            s['points'] = s['points']! - 3;
          } else if (otherGoals < deletedGoals) {
            s['losses'] = s['losses']! - 1;
          } else {
            s['draws'] = s['draws']! - 1;
            s['points'] = s['points']! - 1;
          }
        }
      }
      for (final r in tournamentRounds) {
        r.remove(m.id);
      }
      matches.remove(m);
    }

    teamStatistics.removeWhere((name, _) => name.toLowerCase() == key);
    if (removed.isNotEmpty) {
      print('Removed ${removed.length} match(es) of the deleted team from the tournament.');
    }
  }

  // Display all matches
  void displayMatches() {
    print('\n--- MATCHES ---');

    if (matches.isEmpty) {
      print('No matches.');
    }

    for (final m in matches) {
      m.display();
    }
  }

  // Display tournament rounds
  void displayRounds() {
    print('\n--- ROUNDS ---');

    for (var i = 0; i < tournamentRounds.length; i++) {
      print('Round ${i + 1}: ${tournamentRounds[i]}');
    }

    if (tournamentRounds.isEmpty) {
      print('No rounds.');
    }
  }

  // Display team statistics
  // IMPORTANT: This is the method name used in main.dart
  void displayStatistics() {
    print('\n===== TEAM STATISTICS =====');

    if (teamStatistics.isEmpty) {
      print('No statistics available.');
      return;
    }

    teamStatistics.forEach((teamName, stats) {
      print('\nTeam: $teamName');

      stats.forEach((key, value) {
        print('$key: $value');
      });
    });
  }

  // Search matches by team name
  void searchMatches(String teamName) {
    final found = matches.where((m) =>
        m.team1.name.toLowerCase() == teamName.toLowerCase() ||
        m.team2.name.toLowerCase() == teamName.toLowerCase()).toList();

    if (found.isEmpty) {
      print('No matches found for $teamName.');
    }

    for (final m in found) {
      m.display();
    }
  }

  // Display ranking
  @override
  void displayRanking() {
    final rows = teamStatistics.entries.toList();

    rows.sort((x, y) {
      final byPoints =
          y.value['points']!.compareTo(x.value['points']!);

      if (byPoints != 0) {
        return byPoints;
      }

      final dx =
          x.value['goalsFor']! - x.value['goalsAgainst']!;

      final dy =
          y.value['goalsFor']! - y.value['goalsAgainst']!;

      return dy.compareTo(dx);
    });

    print('\n--- STANDINGS ---');
    print('Team | Played | Wins | Draws | Losses | Points');

    for (var i = 0; i < rows.length; i++) {
      final s = rows[i].value;

      print(
        '${i + 1}. ${rows[i].key} | '
        '${s["played"]} | '
        '${s["wins"]} | '
        '${s["draws"]} | '
        '${s["losses"]} | '
        '${s["points"]}',
      );
    }
  }

  // Display complete tournament report
  void displayTournamentReport() {
    print('\n===== TOURNAMENT REPORT =====');

    print('Registered tournament teams: ${teamStatistics.length}');

    print('Scheduled matches: ${matches.length}');

    print(
      'Completed matches: '
      '${matches.where((m) => m.hasResult).length}',
    );

    print('Rounds: ${tournamentRounds.length}');

    displayRanking();

    displayStatistics();
  }

  // PERSON 2: List<List<int>> copy experiment (snapshot of real tournamentRounds)
  void demonstrateRoundsCopies() {
    print('\ntournamentRounds copy test');
    final original =
        tournamentRounds.map((r) => List<int>.from(r)).toList();
    final i = original.indexWhere((r) => r.isNotEmpty);
    if (i == -1) {
      print('Schedule matches first.');
      return;
    }

    // Shallow copy
    final shallow = List<List<int>>.from(original);

    // Deep copy
    final deep = original.map((r) => List<int>.from(r)).toList();

    shallow[i].removeAt(0);
    shallow[i].add(999);

    deep[i].removeAt(0);
    deep[i].add(888);

    print('Shallow copy: removed first match ID and added 999 in round ${i + 1}.');
    print('Deep copy: removed first match ID and added 888 in round ${i + 1}.');
    print('Original: $original');
    print('Shallow:  $shallow');
    print('Deep:     $deep');
    print(
      'Shallow inner-list edits affect Original; '
      'deep-copy edits do not.',
    );
  }

  // PERSON 2: Map<String, Map<String, int>> copy experiment (snapshot of real teamStatistics)
  void demonstrateStatisticsCopies() {
    print('\nteamStatistics copy test');
    if (teamStatistics.isEmpty) {
      print('Schedule matches first.');
      return;
    }
    final original = teamStatistics.map(
      (key, value) => MapEntry(key, Map<String, int>.from(value)),
    );
    final team = original.keys.first;

    // Shallow copy
    final shallow = Map<String, Map<String, int>>.from(original);

    // Deep copy
    final deep = original.map(
      (key, value) => MapEntry(key, Map<String, int>.from(value)),
    );

    shallow[team]!['points'] = shallow[team]!['points']! + 50;
    deep[team]!['points'] = deep[team]!['points']! + 100;

    print('Shallow copy: added 50 to "$team" points.');
    print('Deep copy: added 100 to "$team" points.');
    print('Original: $original');
    print('Shallow:  $shallow');
    print('Deep:     $deep');
    print(
      'Shallow inner-map edits affect Original; '
      'deep-copy edits do not.',
    );
  }
}
