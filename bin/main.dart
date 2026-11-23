
import 'dart:io';

import 'package:sports_tournament/person1_people_teams.dart';
import 'package:sports_tournament/person2_tournament.dart';

// Read text safely.
String ask(String message) {
  stdout.write(message);
  return stdin.readLineSync()?.trim() ?? '';
}

// Read integer safely.
int askInt(String message) {
  while (true) {
    stdout.write(message);

    String? input = stdin.readLineSync();

    if (input == null) {
      print('\nInput closed. Program terminated.');
      exit(0);
    }

    int? number = int.tryParse(input.trim());

    if (number != null) {
      return number;
    }

    print('Please enter a valid number.');
  }
}

void main() {
  TeamManager manager = TeamManager();
  TournamentSystem tournament = TournamentSystem(manager);

  while (true) {
    print('''
========================================
     SPORTS TOURNAMENT MANAGEMENT
========================================

PERSON 1 - PLAYERS, COACHES AND TEAMS

1. Add Player
2. Add Coach
3. Create Team
4. Assign Player to Team
5. Assign Coach to Team
6. Display Players
7. Display Coaches
8. Display Teams
9. Search Player
10. Search Team
11. Update Player
12. Delete Player
13. Delete Coach
14. Delete Team

PERSON 2 - TOURNAMENT

15. Schedule Match
16. Record Match Result
17. Display Matches
18. Search Match
19. Search Matches by Team
20. Display Rounds
21. Display Statistics
22. Display Ranking
23. Tournament Report

COPY DEMONSTRATIONS

24. Copy Team Players (Set)
25. Copy Tournament Rounds (List)
26. Copy Team Statistics (Map)

0. Exit

========================================
''');

    int choice = askInt('Choose an option: ');

    try {
      switch (choice) {
        case 1:
          Player player = Player(
            id: askInt('Player ID: '),
            name: ask('Player Name: '),
            position: ask('Player Position: '),
          );

          manager.addPlayer(player);
          break;

        case 2:
          Coach coach = Coach(
            id: askInt('Coach ID: '),
            name: ask('Coach Name: '),
            experienceYears: askInt('Experience Years: '),
          );

          manager.addCoach(coach);
          break;

        case 3:
          manager.createTeam(ask('Team Name: '));
          break;

        case 4:
          manager.assignPlayer(
            askInt('Player ID: '),
            ask('Team Name: '),
          );
          break;

        case 5:
          manager.assignCoach(
            askInt('Coach ID: '),
            ask('Team Name: '),
          );
          break;

        case 6:
          manager.displayPlayers();
          break;

        case 7:
          manager.displayCoaches();
          break;

        case 8:
          manager.displayTeams();
          break;

        case 9:
          manager.searchPlayer(askInt('Player ID: '));
          break;

        case 10:
          manager.searchTeam(ask('Team Name: '));
          break;

        case 11:
          int playerUpdateId = askInt('Player ID: ');
          String name = ask('New Name: ');
          String position = ask('New Position: ');

          manager.updatePlayer(id, name, position);
          break;

        case 12:
          manager.deletePlayer(askInt('Player ID: '));
          break;

        case 13:
          manager.deleteCoach(askInt('Coach ID: '));
          break;

        case 14:
          String teamName = ask('Team Name: ');

          if (manager.deleteTeam(teamName)) {
            tournament.removeTeamData(teamName);
          }
          break;

        case 15:
          int matchId = askInt('Match ID: ');
          String team1 = ask('First Team: ');
          String team2 = ask('Second Team: ');
          int round = askInt('Round Number: ');

          tournament.scheduleMatch(
            matchId,
            team1,
            team2,
            round,
          );
          break;

        case 16:
          int resultMatchId = askInt('Match ID: ');
          int score1 = askInt('First Team Score: ');
          int score2 = askInt('Second Team Score: ');

          tournament.recordResult(id, score1, score2);
          break;

        case 17:
          tournament.displayMatches();
          break;

        case 18:
          tournament.searchMatch(askInt('Match ID: '));
          break;

        case 19:
          tournament.searchMatchesByTeam(
            ask('Team Name: '),
          );
          break;

        case 20:
          tournament.displayRounds();
          break;

        case 21:
          tournament.displayStatistics();
          break;

        case 22:
          tournament.displayRanking();
          break;

        case 23:
          tournament.displayReport();
          break;

        case 24:
          manager.demonstrateTeamPlayersCopies();
          break;

        case 25:
          tournament.demonstrateRoundsCopies();
          break;

        case 26:
          tournament.demonstrateStatisticsCopies();
          break;

        case 0:
          print('Program closed successfully.');
          return;

        default:
          print('Invalid menu choice.');
      }
    } on ArgumentError catch (e) {
      print('Invalid input: $e');
    } catch (e) {
      print('Something went wrong: $e');
    }

    print('\nPress Enter to return to menu...');
    stdin.readLineSync();
  }
}
