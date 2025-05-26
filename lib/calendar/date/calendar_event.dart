part of 'calendar_bloc.dart';

abstract class CalendarEvent {}

class InitialCalendarEvent extends CalendarEvent {}

class CalendarArrowForwardEvent extends CalendarEvent {}

class CalendarArrowBackEvent extends CalendarEvent {}

class CalendarTabDateEvent extends CalendarEvent {
  final DateTime selectedDate;

  CalendarTabDateEvent({required this.selectedDate});
}

class InitialListEvent extends CalendarEvent {
  final List<String> items;

  InitialListEvent({required this.items});
}
