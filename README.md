
# Sports Tournament Management System

A Dart console application for managing sports tournaments, including players, coaches, teams, matches, results, statistics, and rankings.

## Requirements

- Dart SDK 3.0.0 or later.

## How to Run

```bash
dart pub get
dart run bin/main.dart
```

## Project Structure

```text
SportsTournament/
│
├── lib/
│   ├── person1_people_teams.dart
│   └── person2_tournament.dart
│
├── bin/
│   └── main.dart
│
├── pubspec.yaml
└── README.md
```

## Person 1 — People & Teams

**File:** `lib/person1_people_teams.dart`

### Classes
- `Participant` — Abstract class.
- `Player` — Represents a player.
- `Coach` — Represents a coach.
- `Team` — Represents a team.
- `TeamManager` — Manages players, coaches, and teams.

### Features
- Register, update, delete, and search players.
- Register, delete, and search coaches.
- Create and delete teams.
- Assign players and coaches to teams.
- Prevent duplicate and invalid player assignments.
- Limit the number of players in each team.
- Display players, coaches, and teams.
- Use static members and nested collections.
- Demonstrate shallow and deep copying using `Set<Set<int>>`.

## Person 2 — Matches & Tournament

**File:** `lib/person2_tournament.dart`

### Classes
- `Ranked` — Interface for displaying rankings.
- `Match` — Represents a match between two teams.
- `TournamentSystem` — Manages tournament operations.

### Features
- Schedule matches between teams.
- Organize matches into tournament rounds.
- Record match scores.
- Calculate match winners.
- Update team points and statistics.
- Search matches by ID or team.
- Display matches, rounds, and statistics.
- Calculate and display team rankings.
- Generate a tournament report.
- Remove a team's related matches and statistics when the team is deleted.
- Demonstrate shallow and deep copying using nested Lists and Maps.

## Main Menu

The application provides the following options:

| Option | Feature |
|---|---|
| 1 | Add Player |
| 2 | Add Coach |
| 3 | Create Team |
| 4 | Assign Player |
| 5 | Assign Coach |
| 6 | Display Players |
| 7 | Display Coaches |
| 8 | Display Teams |
| 9 | Search Player |
| 10 | Search Team |
| 11 | Update Player |
| 12 | Delete Player |
| 13 | Delete Coach |
| 14 | Delete Team |
| 15 | Schedule Match |
| 16 | Record Result |
| 17 | Display Matches |
| 18 | Search Match |
| 19 | Search Matches by Team |
| 20 | Display Rounds |
| 21 | Display Statistics |
| 22 | Display Ranking |
| 23 | Tournament Report |
| 24 | Set Copy Demonstration |
| 25 | List Copy Demonstration |
| 26 | Map Copy Demonstration |
| 0 | Exit |

## Scoring System

- Win: 3 points.
- Draw: 1 point for each team.
- Loss: 0 points.

Teams are ranked according to their total points.

## Team Collaboration

The project is divided into two parts:

- **Person 1:** Responsible for participants, players, coaches, and teams.
- **Person 2:** Responsible for matches, tournament rounds, results, statistics, and rankings.

Both parts are connected through `bin/main.dart`, which provides the main menu and runs the application.
