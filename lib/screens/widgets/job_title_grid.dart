import 'package:flutter/material.dart';
import 'package:job_scheduler_app/screens/widgets/row_header.dart';

import '../../data/models/vacancy.dart';


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
                RowHeader(
                  day: day,
                  vacancyCount: dateWiseCount[day] ?? 0,
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