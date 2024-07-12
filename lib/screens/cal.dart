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
                            child: Text('Site'),
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
                            child: Text('NSW Government'),
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

class JobTitleGrid extends StatelessWidget {
  final Map<String, int> dateWiseCount;
  final List<Vacancy> vacancies;

  JobTitleGrid({required this.vacancies, required this.dateWiseCount});

  @override
  Widget build(BuildContext context) {
    final List<DateTime> daysOfWeek =
    _generateDaysOfWeek(vacancies.first.startDate);

    List<Widget> vacancyRows = _buildVacancyRows(daysOfWeek, vacancies);

    final List<String> days = dateWiseCount.keys.toList();

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Row headers (Monday to Friday)
          Row(
            children: [
              for (String day in days)
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
                          day, // Day of the week (e.g., Mon, Tue)
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
                              padding:
                              const EdgeInsets.symmetric(horizontal: 4),
                              decoration: BoxDecoration(
                                borderRadius:
                                const BorderRadius.all(Radius.circular(20)),
                                border: Border.all(
                                  width: 1.0,
                                  color: Colors.grey,
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
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
                children: vacancyRows,
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<DateTime> _generateDaysOfWeek(DateTime startDate) {
    DateTime weekStartDate =
    startDate.subtract(Duration(days: startDate.weekday - 1));
    return List<DateTime>.generate(
        5, (index) => weekStartDate.add(Duration(days: index)));
  }

  List<Widget> _buildVacancyRows(List<DateTime> days, List<Vacancy> vacancies) {
    Map<DateTime, int> dateIndices = {
      for (var i = 0; i < days.length; i++) days[i]: i
    };
    List<Map<int, int>> rowOccupancy = [{}];
    List<Widget> rows = [];

    vacancies.sort((a, b) {
      int startComparison = (dateIndices[a.startDate] ?? -1)
          .compareTo(dateIndices[b.startDate] ?? -1);
      if (startComparison != 0) return startComparison;
      return (dateIndices[a.endDate] ?? -1)
          .compareTo(dateIndices[b.endDate] ?? -1);
    });

    for (var vacancy in vacancies) {
      int? startIndex = dateIndices[vacancy.startDate];
      int? endIndex = dateIndices[vacancy.endDate];

      if (startIndex == null || endIndex == null) continue;

      int spanDays = (endIndex - startIndex) + 1;
      bool placed = false;

      for (var rowIndex = 0; rowIndex < rowOccupancy.length; rowIndex++) {
        if (_canPlaceVacancy(rowOccupancy[rowIndex], startIndex, endIndex)) {
          _addVacancyToRow(rows, rowOccupancy[rowIndex], vacancy, startIndex,
              spanDays, rowIndex);
          placed = true;
          break;
        }
      }

      if (!placed) {
        rowOccupancy.add({});
        _addVacancyToRow(rows, rowOccupancy.last, vacancy, startIndex, spanDays,
            rowOccupancy.length - 1);
      }
    }

    return rows;
  }

  bool _canPlaceVacancy(Map<int, int> occupancy, int start, int end) {
    for (int i = start; i <= end; i++) {
      if (occupancy.containsKey(i)) {
        return false;
      }
    }
    return true;
  }

  void _addVacancyToRow(List<Widget> rows, Map<int, int> occupancy,
      Vacancy vacancy, int startIndex, int spanDays, int rowIndex) {
    while (rows.length <= rowIndex) {
      rows.add(Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [],
      ));
    }

    Row row = rows[rowIndex] as Row;
    List<Widget> children = row.children!;

    if (children.isEmpty) {
      for (int i = 0; i < startIndex; i++) {
        children.add(Container(width: 100));
      }
    } else {
      int lastIndex =
      children.isNotEmpty ? (children.last.key as ValueKey<int>).value : -1;
      for (int i = lastIndex + 1; i < startIndex; i++) {
        children.add(Container(width: 100));
      }
    }

    for (int i = startIndex; i < startIndex + spanDays; i++) {
      occupancy[i] = 1;
    }

    children.add(
      Container(
        margin: EdgeInsets.fromLTRB(0, 8, 4, 0),
        height: 100,
        key: ValueKey(startIndex + spanDays - 1),
        width: spanDays * 100.0,
        decoration: BoxDecoration(
          color: vacancy.allocatedEmployee.isEmpty
              ? Colors.orange.shade100
              : Colors.blue.shade100,
          border: Border.all(
            color: Colors.white70,
            width: 0.5,
          ),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                vacancy.title,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                vacancy.timeRange.toString(),
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
