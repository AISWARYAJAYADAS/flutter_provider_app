import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Import for DateFormat
import '../data/models/vacancy.dart';

class GroupingProvider with ChangeNotifier {
  List<Vacancy> _vacancies = [];
  String? _selectedGroupBy;
  Map<String, List<Vacancy>> _groupedVacancies = {};
  Map<String, int> _dateWiseCount = {};

  void updateVacancies(List<Vacancy> vacancies) {
    _vacancies = vacancies;
    _updateGroupedVacancies();
    notifyListeners();
  }

  void setGroupBy(String? groupBy) {
    _selectedGroupBy = groupBy;
    _updateGroupedVacancies();
    notifyListeners();
  }

  void _updateGroupedVacancies() {
    if (_vacancies.isNotEmpty) {
      final DateTime? lowestStartDate = _calculateLowestStartDate(_vacancies);
      final DateTime? highestEndDate = _calculateHighestEndDate(_vacancies);
      if (lowestStartDate != null && highestEndDate != null) {
        _dateWiseCount = _countVacanciesByDate(lowestStartDate, highestEndDate);
      }
      if (_selectedGroupBy == 'Job Title') {
        _groupedVacancies = _groupVacanciesByJobTitle(_vacancies);
      } else if (_selectedGroupBy == 'Employee') {
        _groupedVacancies = _groupVacanciesByEmployee(_vacancies);
      } else {
        _groupedVacancies = {'All Vacancies': _vacancies};
      }
    }
  }

  Map<String, List<Vacancy>> _groupVacanciesByJobTitle(List<Vacancy> vacancies) {
    Map<String, List<Vacancy>> groupedVacancies = {};
    for (var vacancy in vacancies) {
      if (!groupedVacancies.containsKey(vacancy.title)) {
        groupedVacancies[vacancy.title] = [];
      }
      groupedVacancies[vacancy.title]!.add(vacancy);
    }
    return groupedVacancies;
  }

  Map<String, List<Vacancy>> _groupVacanciesByEmployee(List<Vacancy> vacancies) {
    Map<String, List<Vacancy>> groupedVacancies = {};
    for (var vacancy in vacancies) {
      if (!groupedVacancies.containsKey(vacancy.allocatedEmployee)) {
        groupedVacancies[vacancy.allocatedEmployee] = [];
      }
      groupedVacancies[vacancy.allocatedEmployee]!.add(vacancy);
    }
    return groupedVacancies;
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

  Map<String, int> _countVacanciesByDate(DateTime startDate, DateTime endDate) {
    Map<String, int> dateWiseCount = {};
    for (var date = startDate; date.isBefore(endDate) || date.isAtSameMomentAs(endDate); date = date.add(Duration(days: 1))) {
      dateWiseCount[DateFormat('yyyy-MM-dd').format(date)] = 0;
    }
    for (var vacancy in _vacancies) {
      String start = DateFormat('yyyy-MM-dd').format(vacancy.startDate);
      if (dateWiseCount.containsKey(start)) {
        dateWiseCount[start] = dateWiseCount[start]! + 1;
      }
    }
    return dateWiseCount;
  }

  String? get selectedGroupBy => _selectedGroupBy;
  Map<String, List<Vacancy>> get groupedVacancies => _groupedVacancies;
  Map<String, int> get dateWiseCount => _dateWiseCount;
}

