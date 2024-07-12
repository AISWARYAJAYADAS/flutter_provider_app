import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../data/models/vacancy.dart';

class VacancyProvider extends ChangeNotifier {
  List<Vacancy> _vacancies = [];

  List<Vacancy> get vacancies => _vacancies;

  VacancyProvider() {
    // Load vacancies initially when the provider is instantiated
    loadVacancies();
  }

  Future<void> loadVacancies() async {
    try {
      String jsonData = await rootBundle.loadString('assets/vacancies.json');
      final List<dynamic> parsedJson = json.decode(jsonData);
      _vacancies = parsedJson.map((json) {
        return Vacancy(
          id: json['id'],
          title: json['title'],
          duration: json['duration'],
          details: json['details'],
          allocatedEmployee: json['allocatedEmployee'],
          timeRange: json['timeRange'],
          startDate: DateTime.parse(json['startDate']),
          endDate: DateTime.parse(json['endDate']),
        );
      }).toList();
      notifyListeners(); // Notify listeners after updating _vacancies
    } catch (e) {
      print('Error loading vacancies: $e');
      // Handle error gracefully
    }
  }

  Map<String, int> countVacanciesByDate(DateTime startDate, DateTime endDate) {
    Map<String, int> dateWiseCount = {};

    for (var vacancy in _vacancies) {
      DateTime vacancyDate = vacancy.startDate;

      while (vacancyDate.isBefore(vacancy.endDate.add(Duration(days: 1)))) {
        if (vacancyDate.isAfter(startDate.subtract(Duration(days: 1))) &&
            vacancyDate.isBefore(endDate.add(Duration(days: 1)))) {
          String dateString = DateFormat('EEE dd, MMM').format(vacancyDate);
          if (dateWiseCount.containsKey(dateString)) {
            dateWiseCount[dateString] = dateWiseCount[dateString]! + 1;
          } else {
            dateWiseCount[dateString] = 1;
          }
        }
        vacancyDate = vacancyDate.add(Duration(days: 1));
      }
    }

    return dateWiseCount;
  }

}

