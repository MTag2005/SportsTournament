# Sports Tournament Management (Dart)

Run from the SportsTournament folder: `dart run bin/main.dart`

Scoring: win = 3 points, draw = 1 point each, loss = 0.
Ranking: points first, then goal difference.

---

## Person 1 — People & Teams
File: `lib/person1_people_teams.dart`

Classes
- `Participant` (abstract), `Player`, `Coach`, `Team`
- `TeamManager`

Features
- Register / update / delete players and coaches (unique IDs, invalid input rejected)
- Create / delete teams
- Assign player to team (no duplicate / invalid assignment), remove player from team
- Assign coach to team
- Search player by ID, search team by name
- Display players, coaches, teams
- Maintains `Set<Set<int>> teamPlayers`
- Copy demo: `teamPlayers` (original / shallow / deep) -> `demonstrateTeamPlayersCopies()`

Menu options: 1, 2, 3, 4, 5, 6, 7, 8, 16, 17, 18, 19, 20, 22, 23

---

## Person 2 — Matches, Results & Ranking
File: `lib/person2_tournament.dart`

Classes
- `Ranked` (interface), `Match`, `TournamentSystem`

Features
- Schedule matches into rounds (a team's statistics are created when it is first scheduled)
- Record scores, calculate winner, update points/statistics
- Display and search matches, display rounds and statistics
- Calculate and display ranking (standings), tournament report
- `removeTeamData()`: when a team is deleted, its matches, round entries and statistics are removed
- Maintains `List<List<int>> tournamentRounds` and `Map<String, Map<String, int>> teamStatistics`
- Copy demos: `demonstrateRoundsCopies()` and `demonstrateStatisticsCopies()`

Menu options: 9, 10, 11, 12, 13, 14, 15, 24

---

## Shared — `bin/main.dart`
- Menu loop that runs until Exit (0); calls Person 1 and Person 2 methods
- Option 20 (Delete team) calls Person 1's `deleteTeam` then Person 2's `removeTeamData`
- Option 21 runs all three copy demos (Person 1's first, then Person 2's two)
- The copy demos work on a snapshot of the real collections, so real data is never changed
