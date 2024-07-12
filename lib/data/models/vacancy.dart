class Vacancy {
  final int id;
  final String title;
  final int duration;
  final String details;
  final String allocatedEmployee;
  final String timeRange;
  final DateTime startDate;
  final DateTime endDate;

  Vacancy({
    required this.id,
    required this.title,
    required this.duration,
    required this.details,
    required this.allocatedEmployee,
    required this.timeRange,
    required this.startDate,
    required this.endDate,
  });
}
