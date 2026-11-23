
// PERSON 1: Participants, Players, Coaches and Teams

// Abstract parent class with exactly TWO abstract methods.
abstract class Participant {
  int id;
  String nameValue;

  Participant({required this.id, required String name})
      : nameValue = '' {
    if (id <= 0) {
      throw ArgumentError('ID must be positive.');
    }
    this.name = name;
  }

  // Public getter and setter with validation.
  String get name => nameValue;

  set name(String value) {
    if (value.trim().isEmpty) {
      throw ArgumentError('Name cannot be empty.');
    }
    nameValue = value.trim();
  }

  // Exactly two abstract methods.
  void display();
  String getRole();
}

// First child class.
class Player extends Participant {
  String positionValue = '';

  Player({
    required super.id,
    required super.name,
    required String position,
  }) {
    this.position = position;
  }

  // Named constructor.
  Player.beginner({
    required int id,
    required String name,
  }) : super(id: id, name: name) {
    position = 'Beginner';
  }

  String get position => positionValue;

  set position(String value) {
    if (value.trim().isEmpty) {
      throw ArgumentError('Position cannot be empty.');
    }
    positionValue = value.trim();
  }

  @override
  void display() {
    print('Player ID: $id | Name: $name | Position: $position');
  }

  @override
  String getRole() => 'Player';
}

// Second child class.
class Coach extends Participant {
  int experienceYearsValue = 0;

  Coach({
    required super.id,
    required super.name,
    required int experienceYears,
  }) {
    this.experienceYears = experienceYears;
  }

  int get experienceYears => experienceYearsValue;

  set experienceYears(int value) {
    if (value < 0) {
      throw ArgumentError('Experience cannot be negative.');
    }
    experienceYearsValue = value;
  }

  @override
  void display() {
    print('Coach ID: $id | Name: $name | Experience: $experienceYears years');
  }

  @override
  String getRole() => 'Coach';
}

// Team class.
class Team {
  String nameValue;
  int? coachId;
  Set<int> playerIds = {};

  Team({required String name}) : nameValue = '' {
    this.name = name;
  }

  String get name => nameValue;

  set name(String value) {
    if (value.trim().isEmpty) {
      throw ArgumentError('Team name cannot be empty.');
    }
    nameValue = value.trim();
  }

  void display() {
    print('Team: $name');
    print('Coach ID: ${coachId ?? "Not assigned"}');
    print('Players IDs: $playerIds');
  }
}

// Manages players, coaches and teams.
class TeamManager {
  // Two static members.
  static int totalPlayers = 0;
  static const int maximumPlayersPerTeam = 30;

  Map<int, Player> players = {};
  Map<int, Coach> coaches = {};
  Map<String, Team> teams = {};

  // Required nested Set.
  Set<Set<int>> teamPlayers = {};

  // Add player.
  bool addPlayer(Player player) {
    if (players.containsKey(player.id)) {
      print('Player ID already exists.');
      return false;
    }

    players[player.id] = player;
    totalPlayers++;

    print('Player added successfully.');
    return true;
  }

  // Add coach.
  bool addCoach(Coach coach) {
    if (coaches.containsKey(coach.id)) {
      print('Coach ID already exists.');
      return false;
    }

    coaches[coach.id] = coach;
    print('Coach added successfully.');
    return true;
  }

  // Create team.
  bool createTeam(String name) {
    String key = name.trim().toLowerCase();

    if (key.isEmpty || teams.containsKey(key)) {
      print('Invalid or existing team name.');
      return false;
    }

    Team team = Team(name: name);
    teams[key] = team;

    // Add the team's player set to the nested Set.
    teamPlayers.add(team.playerIds);

    print('Team created successfully.');
    return true;
  }

  // Find team by name.
  Team? findTeam(String name) {
    String key = name.trim().toLowerCase();
    return teams[key];
  }

  // Assign player to team.
  bool assignPlayer(int playerId, String teamName) {
    if (!players.containsKey(playerId)) {
      print('Player does not exist.');
      return false;
    }

    String key = teamName.trim().toLowerCase();
    Team? team = teams[key];

    if (team == null) {
      print('Team does not exist.');
      return false;
    }

    // Prevent assigning one player to more than one team.
    for (Team t in teams.values) {
      if (t.playerIds.contains(playerId)) {
        print('Player already assigned to a team.');
        return false;
      }
    }

    if (team.playerIds.length >= maximumPlayersPerTeam) {
      print('Team is full.');
      return false;
    }

    team.playerIds.add(playerId);
    print('Player assigned successfully.');
    return true;
  }

  // Assign coach to team.
  bool assignCoach(int coachId, String teamName) {
    if (!coaches.containsKey(coachId)) {
      print('Coach does not exist.');
      return false;
    }

    Team? team = teams[teamName.trim().toLowerCase()];

    if (team == null) {
      print('Team does not exist.');
      return false;
    }

    team.coachId = coachId;
    print('Coach assigned successfully.');
    return true;
  }

  // Search player.
  Player? searchPlayer(int id) {
    Player? player = players[id];

    if (player == null) {
      print('Player not found.');
    } else {
      player.display();
    }

    return player;
  }

  // Search team.
  Team? searchTeam(String name) {
    Team? team = teams[name.trim().toLowerCase()];

    if (team == null) {
      print('Team not found.');
    } else {
      team.display();
    }

    return team;
  }

  // Update player.
  bool updatePlayer(int id, String newName, String newPosition) {
    Player? player = players[id];

    if (player == null) {
      print('Player not found.');
      return false;
    }

    try {
      if (newName.trim().isNotEmpty) {
        player.name = newName;
      }

      if (newPosition.trim().isNotEmpty) {
        player.position = newPosition;
      }
    } on ArgumentError catch (e) {
      print('Invalid data: $e');
      return false;
    }

    print('Player updated successfully.');
    return true;
  }

  // Delete player.
  bool deletePlayer(int id) {
    Player? player = players.remove(id);

    if (player == null) {
      print('Player not found.');
      return false;
    }

    for (Team team in teams.values) {
      team.playerIds.remove(id);
    }

    totalPlayers--;
    print('Player deleted successfully.');
    return true;
  }

  // Delete coach.
  bool deleteCoach(int id) {
    Coach? coach = coaches.remove(id);

    if (coach == null) {
      print('Coach not found.');
      return false;
    }

    for (Team team in teams.values) {
      if (team.coachId == id) {
        team.coachId = null;
      }
    }

    print('Coach deleted successfully.');
    return true;
  }

  // Delete team.
  bool deleteTeam(String name) {
    String key = name.trim().toLowerCase();
    Team? team = teams.remove(key);

    if (team == null) {
      print('Team not found.');
      return false;
    }

    teamPlayers.remove(team.playerIds);
    print('Team deleted successfully.');
    return true;
  }

  // Display all players.
  void displayPlayers() {
    print('\\n--- PLAYERS ---');

    if (players.isEmpty) {
      print('No players found.');
    }

    for (Player p in players.values) {
      p.display();
    }
  }

  // Display all coaches.
  void displayCoaches() {
    print('\\n--- COACHES ---');

    if (coaches.isEmpty) {
      print('No coaches found.');
    }

    for (Coach c in coaches.values) {
      c.display();
    }
  }

  // Display all teams.
  void displayTeams() {
    print('\\n--- TEAMS ---');

    if (teams.isEmpty) {
      print('No teams found.');
    }

    for (Team t in teams.values) {
      t.display();
    }
  }

  // Nested Set shallow and deep copy demonstration.
  void demonstrateTeamPlayersCopies() {
    print('\\n===== TEAM PLAYERS COPY TEST =====');

    // Create a separate original example from current data.
    Set<Set<int>> original =
        teamPlayers.map((s) => Set<int>.from(s)).toSet();

    if (original.isEmpty) {
      print('Create a team and assign a player first.');
      return;
    }

    // Shallow copy: inner Sets are shared.
    Set<Set<int>> shallow = Set<Set<int>>.from(original);

    // Deep copy: every inner Set is cloned.
    Set<Set<int>> deep =
        original.map((s) => Set<int>.from(s)).toSet();

    print('Original before changes: $original');

    // Change inner Set in shallow copy.
    shallow.first.add(999);

    // Change inner Set in deep copy.
    deep.first.add(888);

    print('Original after shallow change: $original');
    print('Shallow copy: $shallow');
    print('Deep copy: $deep');

    print('Shallow change affects original because inner Sets are shared.');
    print('Deep change does not affect original because inner Sets are copied.');
  }
}
