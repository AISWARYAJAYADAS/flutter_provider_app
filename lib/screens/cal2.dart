import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Import for DateFormat
import 'package:provider/provider.dart';
import '../providers/vacancy_provider.dart';
import '../data/models/vacancy.dart';

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
        if (weekRange.isNotEmpty)
          Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                weekRange,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
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

class JobTitleGrid extends StatelessWidget {
  final Map<String, int> dateWiseCount;
  final List<Vacancy> vacancies;

  JobTitleGrid({required this.vacancies, required this.dateWiseCount});

  @override
  Widget build(BuildContext context) {
    final List<String> daysOfWeek = dateWiseCount.keys.toList();

    // Track row occupation
    List<List<bool>> rowOccupancy = List.generate(5, (index) => List.filled(daysOfWeek.length, false));

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Row headers (Monday to Friday)
          Row(
            children: [
              for (String day in daysOfWeek)
                Container(
                  width: 100.0,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    border: Border.all(
                      color: Colors.grey,
                      width: 0.5,
                    ),
                  ),
                  child: Center(
                    child: Column(
                      children: [
                        Text(
                          day,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade900,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Container(
                              width: 35,
                              margin: EdgeInsets.all(8),
                              padding: const EdgeInsets.symmetric(horizontal: 4),
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.all(Radius.circular(20)),
                                border: Border.all(
                                  width: 1.0,
                                  color: Colors.grey,
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Icon(
                                    Icons.shopping_bag_outlined,
                                    color: Colors.black,
                                    size: 12,
                                  ),
                                  const SizedBox(width: 1),
                                  Text(
                                    '${dateWiseCount[day]}',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 10,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Icon(
                              Icons.add_box_rounded,
                              color: Colors.blue.shade400,
                              size: 18,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
          // Job vacancies titles as cells
          Flexible(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (var vacancy in vacancies)
                    _buildVacancyRow(vacancy, rowOccupancy, daysOfWeek),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVacancyRow(
      Vacancy vacancy, List<List<bool>> rowOccupancy, List<String> daysOfWeek) {
    // Determine the width based on the vacancy's duration (max 5 cells wide)
    double rowWidth = 500.0;

    // Calculate the starting position based on the vacancy's start date
    DateTime weekStartDate =
    vacancies.first.startDate.subtract(Duration(days: vacancies.first.startDate.weekday - 1));
    int startDayIndex = vacancy.startDate.difference(weekStartDate).inDays;

    // Calculate left margin based on start day index
    double marginLeft = startDayIndex * 100.0;

    // Calculate right margin based on the end day index
    double marginRight = rowWidth - (marginLeft + (vacancy.duration * 100.0));

    // Find the first available row where the vacancy can fit
    int rowIndex = -1;
    for (int i = 0; i < rowOccupancy.length; i++) {
      bool fitsInRow = true;
      for (int j = startDayIndex; j < startDayIndex + vacancy.duration; j++) {
        if (j >= daysOfWeek.length || rowOccupancy[i][j]) {
          fitsInRow = false;
          break;
        }
      }
      if (fitsInRow) {
        rowIndex = i;
        break;
      }
    }

    // Update rowOccupancy with vacancy placement
    if (rowIndex != -1) {
      for (int j = startDayIndex; j < startDayIndex + vacancy.duration; j++) {
        rowOccupancy[rowIndex][j] = true;
      }
    }

    return Container(
      height: 100,
      padding: EdgeInsets.fromLTRB(0,8,0,0),
      color: Colors.white70,
      width: rowWidth,
      child: Container(
          padding: EdgeInsets.all(8),
          margin: EdgeInsets.only(left: marginLeft, right: marginRight),
          width: vacancy.duration * 100.0,
          decoration: BoxDecoration(
            color: vacancy.allocatedEmployee.isEmpty ? Colors.orange.shade100 : Colors.blue.shade100,
            border: Border.all(
              color: Colors.white70,
              width: 0.5,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(
                vacancy.title,
                style: TextStyle(
                    fontSize: 14,
                    color: Colors.black,
                    fontWeight: FontWeight.bold
                ),
              ),
              Text(
                vacancy.timeRange.toString(),
                style: TextStyle(
                  color: Colors.grey,
                ),
              ),

            ],
          )
      ),
    );




  }
}











