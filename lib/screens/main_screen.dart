import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/bottom_navigation_provider.dart';
import 'bottom_bar/roster_screen.dart';
import 'bottom_bar/screen_one.dart';
import 'bottom_bar/screen_two.dart';
import 'bottom_bar/screen_four.dart';
import 'bottom_bar/screen_five.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => BottomNavigationProvider(),
      child: Consumer<BottomNavigationProvider>(
        builder: (context, bottomNavigationProvider, child) {
          Widget currentScreen;
          switch (bottomNavigationProvider.selectedIndex) {
            case 0:
              currentScreen = RosterScreen();
              break;
            case 1:
              currentScreen = ScreenOne();
              break;
            case 2:
              currentScreen = ScreenTwo();
              break;
            case 3:
              currentScreen = ScreenFour();
              break;
            case 4:
              currentScreen = ScreenFive();
              break;
            default:
              currentScreen = RosterScreen(); // Default to RosterScreen
          }

          return Scaffold(
            body: currentScreen,
            bottomNavigationBar: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              currentIndex: bottomNavigationProvider.selectedIndex,
              onTap: (index) {
                bottomNavigationProvider.setSelectedIndex(index);
              },
              items: [
                _bottomNavigationBarItem(Icons.calendar_month_sharp, 'Roster'),
                _bottomNavigationBarItem(Icons.shopping_bag_outlined, 'Vacancies'),
                _bottomNavigationBarItem(Icons.people_alt_outlined, 'Candidates'),
                _bottomNavigationBarItem(Icons.pending_actions, 'Timesheets'),
                _bottomNavigationBarItem(Icons.more_horiz, 'More'),
              ],
              selectedItemColor: Colors.blue, // Color of selected item icon
              unselectedItemColor: Colors.grey, // Color of unselected item icon
            ),
          );
        },
      ),
    );
  }

  BottomNavigationBarItem _bottomNavigationBarItem(IconData icon, String label) {
    return BottomNavigationBarItem(
      icon: Icon(icon),
      label: label,
    );
  }
}
