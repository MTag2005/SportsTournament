
import 'dart:io';
import 'package:sports_tournament/person1_people_teams.dart';
import 'package:sports_tournament/person2_tournament.dart';

String ask(String message) {
  stdout.write(message);
  return stdin.readLineSync()?.trim() ?? '';
}

int askInt(String message) {
  while (true) {
    final value = int.tryParse(ask(message));
    if (value != null) return value;
    print('Enter a valid integer.');
  }
}

void main() {
  final manager = TeamManager();
  final tournament = TournamentSystem(manager);

  while (true) {
    print('''
========= SPORTS TOURNAMENT MANAGEMENT =========
1 Register player       2 Register coach
3 Create team           4 Assign player to team
5 Assign coach          6 Display players
7 Display coaches       8 Display teams
9 Schedule match        10 Record result
11 Display matches      12 Display rounds
13 Display statistics   14 Display ranking
15 Search matches       16 Update player
17 Remove player from team
18 Delete player        19 Delete coach
20 Delete team          21 Copy demonstrations
22 Search player        23 Search team
24 Tournament report
0 Exit
================================================
''');
    final choice = askInt('Choose: ');

    switch (choice) {
      case 1:
        manager.registerPlayer(Player(
          id: askInt('Player ID: '),
          name: ask('Player name: '),
          position: ask('Position: '),
        ));
        break;
      case 2:
        manager.registerCoach(Coach(
          id: askInt('Coach ID: '),
          name: ask('Coach name: '),
          experienceYears: askInt('Experience years: '),
        ));
        break;
      case 3:
        manager.createTeam(ask('Team name: '));
        break;
      case 4:
        manager.assignPlayer(askInt('Player ID: '), ask('Team name: '));
        break;
      case 5:
        manager.assignCoach(askInt('Coach ID: '), ask('Team name: '));
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
        tournament.scheduleMatch(
          askInt('Match ID: '), ask('First team: '),
          ask('Second team: '), askInt('Round number: '),
        );
        break;
      case 10:
        tournament.recordResult(
          askInt('Match ID: '), askInt('First team score: '),
          askInt('Second team score: '),
        );
        break;
      case 11:
        tournament.displayMatches();
        break;
      case 12:
        tournament.displayRounds();
        break;
      case 13:
        tournament.displayStatistics();
        break;
      case 14:
        tournament.displayRanking();
        break;
      case 15:
        tournament.searchMatches(ask('Team name: '));
        break;
      case 16:
        final id = askInt('Player ID: ');
        final name = ask('New name (Enter to keep): ');
        final position = ask('New position (Enter to keep): ');
        manager.updatePlayer(id,
          name: name.isEmpty ? null : name,
          position: position.isEmpty ? null : position);
        break;
      case 17:
        manager.removePlayerFromTeam(
          askInt('Player ID: '), ask('Team name: '));
        break;
      case 18:
        manager.deletePlayer(askInt('Player ID: '));
        break;
      case 19:
        manager.deleteCoach(askInt('Coach ID: '));
        break;
      case 20:
        final teamName = ask('Team name: ');
        if (manager.deleteTeam(teamName)) {
          tournament.removeTeamData(teamName);
        }
        break;
      case 21:
        manager.demonstrateTeamPlayersCopies();
        tournament.demonstrateRoundsCopies();
        tournament.demonstrateStatisticsCopies();
        break;
      case 22:
        manager.searchPlayer(askInt('Player ID: '));
        break;
      case 23:
        manager.searchTeam(ask('Team name: '));
        break;
      case 24:
        tournament.displayTournamentReport();
        break;
      case 0:
        print('Program closed.');
        return;
      default:
        print('Invalid choice.');
    }
    print('\nPress Enter to continue...');
    stdin.readLineSync();
  }
}
