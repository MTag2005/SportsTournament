
// PERSON 2: Matches, Rounds, Results and Ranking

import 'person1_people_teams.dart';

// Separate interface.
abstract interface class Ranked {
  void displayRanking();
}

// Match class.
class Match {
  int id;
  Team team1;
  Team team2;

  int? score1;
  int? score2;

  Match({
    required this.id,
    required this.team1,
    required this.team2,
  });

  bool get hasResult => score1 != null && score2 != null;

  // Record match result.
  void recordResult(int a, int b) {
    score1 = a;
    score2 = b;
  }

  // Calculate winner.
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

// Tournament system implements Ranked.
class TournamentSystem implements Ranked {
  // Two static members.
  static const int pointsForWin = 3;
  static const int pointsForDraw = 1;

  TeamManager manager;

  TournamentSystem(this.manager);

  List<Match> matches = [];

  // Required nested List.
  List<List<int>> tournamentRounds = [];

  // Required nested Map.
  Map<String, Map<String, int>> teamStatistics = {};

  // Create statistics for a team.
  void initializeStatistics(String teamName) {
    teamStatistics.putIfAbsent(teamName, () {
      return {
        'played': 0,
        'wins': 0,
        'losses': 0,
        'draws': 0,
        'points': 0,
        'goalsFor': 0,
        'goalsAgainst': 0,
      };
    });
  }

  // Schedule a match.
  bool scheduleMatch(
    int id,
    String team1Name,
    String team2Name,
    int round,
  ) {
    if (id <= 0 || round <= 0) {
      print('ID and round must be positive.');
      return false;
    }

    if (matches.any((m) => m.id == id)) {
      print('Match ID already exists.');
      return false;
    }

    Team? team1 = manager.findTeam(team1Name);
    Team? team2 = manager.findTeam(team2Name);

    if (team1 == null || team2 == null || team1 == team2) {
      print('Enter two different existing teams.');
      return false;
    }

    initializeStatistics(team1.name);
    initializeStatistics(team2.name);

    Match match = Match(
      id: id,
      team1: team1,
      team2: team2,
    );

    matches.add(match);

    while (tournamentRounds.length < round) {
      tournamentRounds.add([]);
    }

    tournamentRounds[round - 1].add(id);

    print('Match scheduled successfully.');
    return true;
  }

  // Record result and update statistics.
  bool recordResult(int id, int score1, int score2) {
    if (score1 < 0 || score2 < 0) {
      print('Scores cannot be negative.');
      return false;
    }

    Match? match;

    for (Match m in matches) {
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

    match.recordResult(score1, score2);

    Map<String, int> s1 = teamStatistics[match.team1.name]!;
    Map<String, int> s2 = teamStatistics[match.team2.name]!;

    s1['played'] = s1['played']! + 1;
    s2['played'] = s2['played']! + 1;

    s1['goalsFor'] = s1['goalsFor']! + score1;
    s1['goalsAgainst'] = s1['goalsAgainst']! + score2;

    s2['goalsFor'] = s2['goalsFor']! + score2;
    s2['goalsAgainst'] = s2['goalsAgainst']! + score1;

    if (score1 > score2) {
      s1['wins'] = s1['wins']! + 1;
      s1['points'] = s1['points']! + pointsForWin;
      s2['losses'] = s2['losses']! + 1;

      print('Winner: ${match.team1.name}');
    } else if (score2 > score1) {
      s2['wins'] = s2['wins']! + 1;
      s2['points'] = s2['points']! + pointsForWin;
      s1['losses'] = s1['losses']! + 1;

      print('Winner: ${match.team2.name}');
    } else {
      s1['draws'] = s1['draws']! + 1;
      s2['draws'] = s2['draws']! + 1;

      s1['points'] = s1['points']! + pointsForDraw;
      s2['points'] = s2['points']! + pointsForDraw;

      print('Match is a draw.');
    }

    return true;
  }

  // Search match by ID.
  Match? searchMatch(int id) {
    for (Match m in matches) {
      if (m.id == id) {
        m.display();
        return m;
      }
    }

    print('Match not found.');
    return null;
  }

  // Search matches by team.
  void searchMatchesByTeam(String teamName) {
    bool found = false;

    for (Match m in matches) {
      if (m.team1.name.toLowerCase() == teamName.trim().toLowerCase() ||
          m.team2.name.toLowerCase() == teamName.trim().toLowerCase()) {
        m.display();
        found = true;
      }
    }

    if (!found) {
      print('No matches found.');
    }
  }

  // Delete matches of a team and update opponent statistics.
  void removeTeamData(String teamName) {
    String key = teamName.trim().toLowerCase();

    List<Match> removed = matches.where((m) {
      return m.team1.name.toLowerCase() == key ||
          m.team2.name.toLowerCase() == key;
    }).toList();

    for (Match m in removed) {
      if (m.hasResult) {
        bool firstTeamDeleted =
            m.team1.name.toLowerCase() == key;

        Team otherTeam =
            firstTeamDeleted ? m.team2 : m.team1;

        int otherScore =
            firstTeamDeleted ? m.score2! : m.score1!;

        int deletedScore =
            firstTeamDeleted ? m.score1! : m.score2!;

        Map<String, int>? stats =
            teamStatistics[otherTeam.name];

        if (stats != null) {
          stats['played'] = stats['played']! - 1;
          stats['goalsFor'] = stats['goalsFor']! - otherScore;
          stats['goalsAgainst'] = stats['goalsAgainst']! - deletedScore;

          if (otherScore > deletedScore) {
            stats['wins'] = stats['wins']! - 1;
            stats['points'] = stats['points']! - pointsForWin;
          } else if (otherScore < deletedScore) {
            stats['losses'] = stats['losses']! - 1;
          } else {
            stats['draws'] = stats['draws']! - 1;
            stats['points'] = stats['points']! - pointsForDraw;
          }
        }
      }

      for (List<int> round in tournamentRounds) {
        round.remove(m.id);
      }

      matches.remove(m);
    }

    teamStatistics.removeWhere(
      (name, value) => name.toLowerCase() == key,
    );

    print('Team matches and statistics removed.');
  }

  // Display all matches.
  void displayMatches() {
    print('\\n--- MATCHES ---');

    if (matches.isEmpty) {
      print('No matches found.');
    }

    for (Match m in matches) {
      m.display();
    }
  }

  // Display rounds.
  void displayRounds() {
    print('\\n--- TOURNAMENT ROUNDS ---');

    if (tournamentRounds.isEmpty) {
      print('No rounds found.');
    }

    for (int i = 0; i < tournamentRounds.length; i++) {
      print('Round ${i + 1}: ${tournamentRounds[i]}');
    }
  }

  // Display statistics.
  void displayStatistics() {
    print('\\n--- TEAM STATISTICS ---');

    if (teamStatistics.isEmpty) {
      print('No statistics available.');
    }

    teamStatistics.forEach((team, stats) {
      print('\\nTeam: $team');

      stats.forEach((key, value) {
        print('$key: $value');
      });
    });
  }

  // Calculate and display ranking.
  @override
  void displayRanking() {
    List<MapEntry<String, Map<String, int>>> ranking =
        teamStatistics.entries.toList();

    ranking.sort((a, b) {
      return b.value['points']!.compareTo(a.value['points']!);
    });

    print('\\n--- TOURNAMENT RANKING ---');

    if (ranking.isEmpty) {
      print('No ranking available.');
      return;
    }

    for (int i = 0; i < ranking.length; i++) {
      print(
        '${i + 1}. ${ranking[i].key} '
        '| Points: ${ranking[i].value['points']} '
        '| Wins: ${ranking[i].value['wins']}',
      );
    }
  }

  // Tournament report.
  void displayReport() {
    print('\\n===== TOURNAMENT REPORT =====');

    print('Number of matches: ${matches.length}');

    int completed = matches.where((m) => m.hasResult).length;

    print('Completed matches: $completed');
    print('Number of rounds: ${tournamentRounds.length}');

    displayRanking();
    displayStatistics();
  }

  // Nested List shallow and deep copy demonstration.
  void demonstrateRoundsCopies() {
    print('\\n===== TOURNAMENT ROUNDS COPY TEST =====');

    // Separate original example.
    List<List<int>> original =
        tournamentRounds.map((r) => List<int>.from(r)).toList();

    if (original.isEmpty || original.every((r) => r.isEmpty)) {
      print('Schedule a match first.');
      return;
    }

    // Shallow copy.
    List<List<int>> shallow = List<List<int>>.from(original);

    // Deep copy.
    List<List<int>> deep =
        original.map((r) => List<int>.from(r)).toList();

    print('Original before changes: $original');

    // Change an inner List in each copy.
    int index = original.indexWhere((r) => r.isNotEmpty);

    shallow[index].add(999);
    deep[index].add(888);

    print('Original after shallow change: $original');
    print('Shallow copy: $shallow');
    print('Deep copy: $deep');

    print('Shallow change affects original because inner Lists are shared.');
    print('Deep change does not affect original because inner Lists are copied.');
  }

  // Nested Map shallow and deep copy demonstration.
  void demonstrateStatisticsCopies() {
    print('\\n===== TEAM STATISTICS COPY TEST =====');

    if (teamStatistics.isEmpty) {
      print('Record a match first.');
      return;
    }

    // Separate original example.
    Map<String, Map<String, int>> original = teamStatistics.map(
      (key, value) => MapEntry(
        key,
        Map<String, int>.from(value),
      ),
    );

    // Shallow copy.
    Map<String, Map<String, int>> shallow =
        Map<String, Map<String, int>>.from(original);

    // Deep copy.
    Map<String, Map<String, int>> deep = original.map(
      (key, value) => MapEntry(
        key,
        Map<String, int>.from(value),
      ),
    );

    String team = original.keys.first;

    print('Original before changes: $original');

    // Change inner Maps.
    shallow[team]!['points'] = shallow[team]!['points']! + 10;
    deep[team]!['points'] = deep[team]!['points']! + 20;

    print('Original after shallow change: $original');
    print('Shallow copy: $shallow');
    print('Deep copy: $deep');

    print('Shallow change affects original because inner Maps are shared.');
    print('Deep change does not affect original because inner Maps are copied.');
  }
}
