import 'package:flutter/material.dart';
import 'package:job_scheduler_app/screens/vacancy_list_view.dart';
import 'package:provider/provider.dart';

import '../../providers/tab_provider.dart';
import '../../providers/bottom_navigation_provider.dart'; // Import the provider
import '../calendar_view.dart';

class RosterScreen extends StatelessWidget {
  const RosterScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Consumer<TabProvider>(
                    builder: (context, tabProvider, child) => ToggleButtons(
                      borderRadius: BorderRadius.circular(20),
                      selectedBorderColor: Colors.grey.shade400,
                      fillColor: Colors.grey.withOpacity(0.1),
                      selectedColor: Colors.grey.shade900,
                      color: Colors.black,
                      borderWidth: 1,
                      constraints: const BoxConstraints(minHeight: 30.0),
                      isSelected: [
                        tabProvider.selectedIndex == 0,
                        tabProvider.selectedIndex == 1,
                      ],
                      onPressed: (index) {
                        tabProvider.setSelectedIndex(index);
                      },
                      children: const [
                        SizedBox(
                          width: 80,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.calendar_today,
                                color: Colors.black,
                                size: 12,
                              ),
                              SizedBox(
                                width: 2,
                              ),
                              Text(
                                'Calendar',
                                style: TextStyle(fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: 80,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.list,
                                color: Colors.black,
                                size: 14,
                              ),
                              SizedBox(
                                width: 2,
                              ),
                              Text(
                                'List',
                                style: TextStyle(fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.blue.shade700,
                    ),
                    child: const Row(
                      children: [
                        Icon(
                          Icons.add,
                          color: Colors.white,
                          size: 18,
                        ),
                        SizedBox(width: 2),
                        Text(
                          'Vacancy',
                          style: TextStyle(fontSize: 12, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const Divider(
              height: 1,
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Consumer<TabProvider>(
                builder: (context, tabProvider, child) {
                  if (tabProvider.selectedIndex == 0) {
                    return  CalendarView();
                  } else {
                    return const VacancyListView();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
