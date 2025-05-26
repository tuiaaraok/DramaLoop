import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'calendar_state.dart';
part 'calendar_event.dart';

class CalendarBloc extends Bloc<CalendarEvent, CalendarState> {
  DateTime _currentMonth = DateTime.now();
  DateTime? _selectedDate;
  List<String> _items = [];

  CalendarBloc()
      : super(CalendarState(currentMonth: DateTime.now(), items: [])) {
    on<CalendarArrowForwardEvent>(calendarArrowForwardEvent);

    on<CalendarArrowBackEvent>(calendarArrowBackEvent);

    on<CalendarTabDateEvent>(calendarTabDateEvent);

    on<InitialListEvent>(initialListEvent);
  }

  FutureOr<void> calendarEvent(event, emit) {
    emit(CalendarState(
        currentMonth: _currentMonth,
        selectedDate: _selectedDate,
        items: _items));
  }

  FutureOr<void> calendarArrowForwardEvent(event, emit) {
    _currentMonth = DateTime(_currentMonth.year, _currentMonth.month + 1);
    emit(CalendarState(
        currentMonth: _currentMonth,
        selectedDate: _selectedDate,
        items: _items));
  }

  FutureOr<void> calendarArrowBackEvent(event, emit) {
    _currentMonth = DateTime(_currentMonth.year, _currentMonth.month - 1);
    emit(CalendarState(
        currentMonth: _currentMonth,
        selectedDate: _selectedDate,
        items: _items));
  }

  FutureOr<void> calendarTabDateEvent(event, emit) {
    if (_selectedDate == event.selectedDate) {
      _selectedDate = null;
    } else {
      _selectedDate = event.selectedDate;
    }

    emit(CalendarState(
        currentMonth: _currentMonth,
        selectedDate: _selectedDate,
        items: _items));
  }

  FutureOr<void> initialListEvent(event, emit) {
    _items = event.items;
    emit(CalendarState(
        currentMonth: _currentMonth,
        selectedDate: _selectedDate,
        items: _items));
  }
}
