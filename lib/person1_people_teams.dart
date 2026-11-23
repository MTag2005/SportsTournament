// PERSON 1: Registration and Teams
abstract class Participant {
  final int id;
  String name;
  Participant({required this.id, required this.name});
  void display() => print('ID: $id | Name: $name');
}

class Player extends Participant {
  String position;
  Player({required super.id, required super.name, required this.position});
  @override
  void display() => print('Player #$id | $name | $position');
}

class Coach extends Participant {
  int experienceYears;
  Coach({required super.id, required super.name, required this.experienceYears});
  @override
  void display() => print('Coach #$id | $name | $experienceYears years');
}

class Team {
  final String name;
  int? coachId;
  final Set<int> playerIds = <int>{};
  Team({required this.name});
}

class TeamManager {
  final Map<int, Player> players = {};
  final Map<int, Coach> coaches = {};
  final Map<String, Team> teams = {};

  // One inner Set represents the player IDs of one team.
  final Set<Set<int>> teamPlayers = {};

  bool registerPlayer(Player p) {
    if (p.id <= 0 || p.name.trim().isEmpty || p.position.trim().isEmpty) {
      print('Invalid player: ID must be positive; name and position cannot be empty.');
      return false;
    }
    if (players.containsKey(p.id)) {
      print('Player ID already exists.'); return false;
    }
    players[p.id] = p;
    print('Player registered.'); return true;
  }

  bool registerCoach(Coach c) {
    if (c.id <= 0 || c.name.trim().isEmpty || c.experienceYears < 0) {
      print('Invalid coach: ID must be positive, name cannot be empty, years cannot be negative.');
      return false;
    }
    if (coaches.containsKey(c.id)) {
      print('Coach ID already exists.'); return false;
    }
    coaches[c.id] = c;
    print('Coach registered.'); return true;
  }

  bool createTeam(String name) {
    final key = name.trim().toLowerCase();
    if (key.isEmpty || teams.containsKey(key)) {
      print('Invalid or duplicate team name.'); return false;
    }
    final team = Team(name: name.trim());
    teams[key] = team;
    teamPlayers.add(team.playerIds);
    print('Team created.'); return true;
  }

  Team? findTeam(String name) => teams[name.trim().toLowerCase()];

  Player? searchPlayer(int id) {
    final player = players[id];
    if (player == null) {
      print('Player not found.');
    } else {
      player.display();
    }
    return player;
  }

  Team? searchTeam(String name) {
    final team = findTeam(name);
    if (team == null) {
      print('Team not found.');
    } else {
      print('Team found: ${team.name}');
      print('Player IDs: ${team.playerIds}');
    }
    return team;
  }

  bool assignPlayer(int playerId, String teamName) {
    if (!players.containsKey(playerId)) {
      print('Player not found.'); return false;
    }
    final team = findTeam(teamName);
    if (team == null) {
      print('Team not found.'); return false;
    }
    if (teams.values.any((t) => t.playerIds.contains(playerId))) {
      print('Player is already assigned to a team.'); return false;
    }
    team.playerIds.add(playerId);
    print('Player assigned.'); return true;
  }

  bool removePlayerFromTeam(int playerId, String teamName) {
    final team = findTeam(teamName);
    if (team == null || !team.playerIds.remove(playerId)) {
      print('Team/player assignment not found.'); return false;
    }
    print('Player removed from team.'); return true;
  }

  bool assignCoach(int coachId, String teamName) {
    if (!coaches.containsKey(coachId)) {
      print('Coach not found.'); return false;
    }
    final team = findTeam(teamName);
    if (team == null) {
      print('Team not found.'); return false;
    }
    team.coachId = coachId;
    print('Coach assigned.'); return true;
  }

  bool updatePlayer(int id, {String? name, String? position}) {
    final p = players[id];
    if (p == null) { print('Player not found.'); return false; }
    if (name != null && name.trim().isNotEmpty) p.name = name.trim();
    if (position != null && position.trim().isNotEmpty) {
      p.position = position.trim();
    }
    print('Player updated.'); return true;
  }

  bool deletePlayer(int id) {
    final p = players.remove(id);
    if (p == null) { print('Player not found.'); return false; }
    for (final team in teams.values) { team.playerIds.remove(id); }
    print('Player ${p.name} deleted.'); return true;
  }

  bool deleteCoach(int id) {
    final c = coaches.remove(id);
    if (c == null) { print('Coach not found.'); return false; }
    for (final team in teams.values) {
      if (team.coachId == id) team.coachId = null;
    }
    print('Coach ${c.name} deleted.'); return true;
  }

  bool deleteTeam(String name) {
    final team = teams.remove(name.trim().toLowerCase());
    if (team == null) { print('Team not found.'); return false; }
    teamPlayers.remove(team.playerIds);
    print('Team ${team.name} deleted.'); return true;
  }

  void displayPlayers() {
    print('\n--- PLAYERS ---');
    if (players.isEmpty) print('No players.');
    for (final p in players.values) { p.display(); }
  }

  void displayCoaches() {
    print('\n--- COACHES ---');
    if (coaches.isEmpty) print('No coaches.');
    for (final c in coaches.values) { c.display(); }
  }

  void displayTeams() {
    print('\n--- TEAMS ---');
    if (teams.isEmpty) print('No teams.');
    for (final team in teams.values) {
      final coach = team.coachId == null ? null : coaches[team.coachId];
      print('\n${team.name} | Coach: ${coach?.name ?? "Not assigned"}');
      if (team.playerIds.isEmpty) print('No players assigned.');
      for (final id in team.playerIds) {
        final p = players[id];
        print(p == null ? 'Unknown player #$id' : '${p.name} (#${p.id}) - ${p.position}');
      }
    }
  }

  // Uses a snapshot of the real teamPlayers so the real data is never changed.
  void demonstrateTeamPlayersCopies() {
    print('\nteamPlayers copy test');
    final original = teamPlayers.map((s) => Set<int>.from(s)).toSet();
    final i = original.toList().indexWhere((s) => s.isNotEmpty);
    if (i == -1) {
      print('Create teams and assign players first.');
      return;
    }
    final shallow = Set<Set<int>>.from(original);
    final deep = original.map((s) => Set<int>.from(s)).toSet();

    final sInner = shallow.elementAt(i);
    sInner.remove(sInner.first);
    sInner.add(999);

    final dInner = deep.elementAt(i);
    dInner.remove(dInner.first);
    dInner.add(888);

    print('Shallow copy: removed first ID and added 999 in one team set.');
    print('Deep copy: removed first ID and added 888 in one team set.');
    print('Original: $original');
    print('Shallow:  $shallow');
    print('Deep:     $deep');
    print('Shallow inner-set edits affect Original; deep-copy edits do not.');
  }
}
