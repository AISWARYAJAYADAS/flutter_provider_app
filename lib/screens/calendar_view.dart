import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Import for DateFormat
import 'package:provider/provider.dart';
import '../providers/vacancy_provider.dart';
import '../data/models/vacancy.dart';
import 'widgets/job_title_grid.dart';

class CalendarView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final vacancyProvider = Provider.of<VacancyProvider?>(context);

    if (vacancyProvider == null || vacancyProvider.vacancies.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(), // Show loading indicator
      );
    }

    final List<Vacancy> vacancies = vacancyProvider.vacancies;

    // Calculate lowest start date and highest end date
    DateTime? lowestStartDate = _calculateLowestStartDate(vacancies);
    DateTime? highestEndDate = _calculateHighestEndDate(vacancies);

    // Format week range
    String weekRange = '';
    if (lowestStartDate != null && highestEndDate != null) {
      weekRange = _calculateWeekRange(lowestStartDate, highestEndDate);
    }

    // Calculate vacancies count by date
    Map<String, int> dateWiseCount =
        vacancyProvider.countVacanciesByDate(lowestStartDate!, highestEndDate!);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Week Range row
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: Container(
                  padding: EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(15)),
                    border: Border.all(
                      width: 1.0, // Border width in pixels
                      color: Colors.grey, // Border color
                    ),
                  ),
                  child: Icon(
                    Icons.arrow_back_ios_new,
                    size: 12,
                  )),
              onPressed: () {
                // Handle navigation to previous week
                // Add your logic here
              },
            ),
            if (weekRange.isNotEmpty)
              Text(
                weekRange,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            IconButton(
              icon: Container(
                  padding: EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(15)),
                    border: Border.all(
                      width: 1.0, // Border width in pixels
                      color: Colors.grey, // Border color
                    ),
                  ),
                  child: Icon(
                    Icons.arrow_forward_ios,
                    size: 12,
                  )),
              onPressed: () {
                // Handle navigation to next week
                // Add your logic here
              },
            ),
          ],
        ),

        Padding(
          padding: const EdgeInsets.fromLTRB(8.0, 8.0, 0, 0),
          child: Text(
            'Group by',
            style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.white70,
                  borderRadius: const BorderRadius.all(Radius.circular(5)),
                  border: Border.all(
                    width: 0.8, // Border width in pixels
                    color: Colors.grey, // Border color
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      child: Center(
                        child: DropdownButton<String>(
                          items: <String>['Employee', 'Job Title']
                              .map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            // Handle dropdown value change
                            // Add your logic here
                          },
                          hint: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Text('Group by'),
                          ),
                          style: TextStyle(color: Colors.blue),
                          underline: SizedBox(),
                        ),
                      ),
                    ),

                    Container(
                      height: 40,
                      child: VerticalDivider(
                        color: Colors.grey,
                        thickness: 0.5,
                      ),
                    ),
                    // Adjust spacing between boxes
                    Container(
                      child: Center(
                        child: DropdownButton<String>(
                          items: <String>['Abb', 'Bbb'].map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            // Handle dropdown value change
                            // Add your logic here
                          },
                          hint: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Text('Site'),
                          ),
                          style: TextStyle(color: Colors.blue),
                          underline: SizedBox(),
                        ),
                      ),
                    ),
                    // Add more boxes as needed
                  ],
                ),
              ),
              // Filter Button
              GestureDetector(
                onTap: () {
                  // Handle filter button press
                  // Add your logic here
                },
                child: Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(8)),
                      border: Border.all(
                        width: 0.5, // Border width in pixels
                        color: Colors.grey.shade400, // Border color
                      ),
                    ),
                    child: Icon(
                      Icons.filter_list,
                      color: Colors.grey.shade500,
                    )),
              ),
            ],
          ),
        ),

        SizedBox(
          height: 8,
        ),

        Flexible(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: JobTitleGrid(
              vacancies: vacancies,
              dateWiseCount: dateWiseCount,
            ),
          ),
        ),
      ],
    );
  }

  DateTime? _calculateLowestStartDate(List<Vacancy> vacancies) {
    if (vacancies.isEmpty) return null;
    DateTime lowestStartDate = vacancies.first.startDate;
    for (var vacancy in vacancies) {
      if (vacancy.startDate.isBefore(lowestStartDate)) {
        lowestStartDate = vacancy.startDate;
      }
    }
    return lowestStartDate;
  }

  DateTime? _calculateHighestEndDate(List<Vacancy> vacancies) {
    if (vacancies.isEmpty) return null;
    DateTime highestEndDate = vacancies.first.endDate;
    for (var vacancy in vacancies) {
      if (vacancy.endDate.isAfter(highestEndDate)) {
        highestEndDate = vacancy.endDate;
      }
    }
    return highestEndDate;
  }

  String _calculateWeekRange(DateTime startDate, DateTime endDate) {
    return '${startDate.day}-${endDate.day} ${DateFormat.MMMM().format(startDate)} ${startDate.year}';
  }
}


