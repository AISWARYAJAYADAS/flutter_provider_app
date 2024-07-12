import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../data/models/vacancy.dart';
import '../providers/vacancy_provider.dart';

class VacancyListView extends StatelessWidget {
  const VacancyListView({super.key});

  @override
  Widget build(BuildContext context) {
    final vacancyProvider = Provider.of<VacancyProvider>(context);
    final List<Vacancy> vacancies = vacancyProvider.vacancies;

    return Column(
      children: [
        // Add the filter row here
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: MediaQuery.of(context).size.width * 0.75,
                decoration: BoxDecoration(
                  color: Colors.white70,
                  borderRadius: const BorderRadius.all(Radius.circular(5)),
                  border: Border.all(
                    width: 0.8, // Border width in pixels
                    color: Colors.grey, // Border color
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: DropdownButton<String>(
                    isExpanded: true,
                    items: <String>['Employee', 'Job Title'].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      // Handle dropdown value change
                      // Add your logic here
                    },
                    hint: Text(
                      'Filter By',
                      style: TextStyle(color: Colors.black),
                    ),
                    underline: SizedBox(),
                  ),
                ),
              ),
              SizedBox(width: 8.0), // Small space gap
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
        // Vacancy list
        Expanded(
          child: ListView.builder(
            itemCount: vacancies.length,
            itemBuilder: (context, index) {
              final Vacancy vacancy = vacancies[index];

              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white70,
                        borderRadius: const BorderRadius.all(Radius.circular(15)),
                        border: Border.all(
                          width: 1.0, // Border width in pixels
                          color: Colors.white, // Border color
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              vacancy.title,
                              style: const TextStyle(color: Colors.blue, fontSize: 16),
                            ),
                            Text(vacancy.details),
                            const SizedBox(height: 2,),
                            Row(
                              children: [
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.calendar_today,
                                      color: Colors.black,
                                      size: 12,
                                    ),
                                    const SizedBox(
                                      width: 4,
                                    ),
                                    Text(
                                      _formatDateWithOrdinal(vacancy.startDate),
                                      style: TextStyle(fontSize: 12),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text("|",style: TextStyle(color: Colors.grey.shade400),),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    const Icon(
                                      Icons.alarm,
                                      color: Colors.black,
                                      size: 12,
                                    ),
                                    const SizedBox(
                                      width: 4,
                                    ),
                                    Text(
                                      vacancy.timeRange,
                                      style: TextStyle(fontSize: 12),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  String _formatDateWithOrdinal(DateTime date) {
    String day = DateFormat('d').format(date);
    String monthYear = DateFormat('MMM yyyy').format(date);
    String ordinalSuffix = _getOrdinalSuffix(int.parse(day));

    return '$day$ordinalSuffix $monthYear';
  }

  String _getOrdinalSuffix(int day) {
    if (day >= 11 && day <= 13) {
      return 'th';
    }
    switch (day % 10) {
      case 1:
        return 'st';
      case 2:
        return 'nd';
      case 3:
        return 'rd';
      default:
        return 'th';
    }
  }
}
