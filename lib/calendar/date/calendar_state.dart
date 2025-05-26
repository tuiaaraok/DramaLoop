part of 'calendar_bloc.dart';

class CalendarState {
  final DateTime currentMonth;
  final DateTime? selectedDate;
  final List<String> items;

  CalendarState({
    required this.currentMonth,
    this.selectedDate,
    required this.items,
  });
}
