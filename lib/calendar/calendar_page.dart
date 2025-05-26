import 'package:flutter/material.dart';
import 'package:flutter_application_4/add_rehearsal_page.dart';
import 'package:flutter_application_4/hive/hive_boxes.dart';
import 'package:flutter_application_4/hive/model/rehearsal_model.dart';
import 'package:flutter_application_4/provider/them_provider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';

import 'date/calendar.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  Box<RehearsalModel> rehearsalBox = Hive.box<RehearsalModel>(
    HiveBoxes.rehearsalModel,
  );

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<CalendarBloc, CalendarState>(
        builder: (context, state) {
          final selectedDate = state.selectedDate;

          return Padding(
            padding: EdgeInsets.only(top: MediaQuery.paddingOf(context).top),
            child: SingleChildScrollView(
              child: SizedBox(
                width: double.infinity,
                child: Column(
                  children: [
                    SizedBox(
                      width: 336.w,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Icon(
                              Icons.arrow_back,
                              size: 36.w,
                              color:
                                  context.watch<ThemeProvider>().isDarkMode
                                      ? Colors.white
                                      : Colors.black,
                            ),
                          ),
                          Text(
                            "Rehearsal schedule",
                            style: GoogleFonts.roboto(
                              fontSize: 22.sp,
                              fontWeight: FontWeight.bold,
                              color:
                                  context.watch<ThemeProvider>().isDarkMode
                                      ? Colors.white
                                      : Colors.black,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute<void>(
                                  builder:
                                      (BuildContext context) =>
                                          const AddRehearsalPage(),
                                ),
                              );
                            },
                            child: Icon(
                              Icons.add,
                              size: 36.w,
                              color:
                                  context.watch<ThemeProvider>().isDarkMode
                                      ? Colors.white
                                      : Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 25.h),
                    Container(
                      width: 306.w,
                      height: calculateCalendarHeight(state.currentMonth),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(20.r)),
                      ),
                      child: Center(
                        child: SizedBox(
                          width: 258.w,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 18.h),
                                child: SizedBox(
                                  width: 341.w,
                                  height: 34.86.h,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          context.read<CalendarBloc>().add(
                                            CalendarArrowBackEvent(),
                                          );
                                        },
                                        child: Icon(
                                          Icons.arrow_back_ios,
                                          size: 12.w,
                                          color: Color(0xFF4A5660),
                                        ),
                                      ),
                                      Text(
                                        DateFormat(
                                          "MMMM y",
                                        ).format(state.currentMonth),
                                        style: TextStyle(
                                          color: Color(0xFF4A5660),
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          context.read<CalendarBloc>().add(
                                            CalendarArrowForwardEvent(),
                                          );
                                        },
                                        child: Icon(
                                          Icons.arrow_forward_ios,
                                          size: 12.w,
                                          color: Color(0xFF4A5660),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Expanded(
                                child: ValueListenableBuilder(
                                  valueListenable: rehearsalBox.listenable(),
                                  builder: (
                                    context,
                                    Box<RehearsalModel> box,
                                    _,
                                  ) {
                                    // Получаем все репетиции для текущего месяца
                                    final rehearsalsForMonth =
                                        box.values
                                            .where(
                                              (rehearsal) =>
                                                  rehearsal.date.year ==
                                                      state.currentMonth.year &&
                                                  rehearsal.date.month ==
                                                      state.currentMonth.month,
                                            )
                                            .toList();
                                    return CalendarWidget(
                                      month: state.currentMonth,
                                      selectedDate: state.selectedDate,
                                      onDateSelected: (date) {
                                        context.read<CalendarBloc>().add(
                                          CalendarTabDateEvent(
                                            selectedDate: date,
                                          ),
                                        );
                                      },
                                      rehearsals: rehearsalsForMonth,
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 26.h),
                    ValueListenableBuilder(
                      valueListenable: rehearsalBox.listenable(),
                      builder: (context, Box<RehearsalModel> box, _) {
                        // Получаем данные из Hive для выбранной даты
                        List<RehearsalModel> rehearsalsForSelectedDate = [];

                        if (selectedDate != null) {
                          rehearsalsForSelectedDate =
                              box.values
                                  .where(
                                    (rehearsal) =>
                                        rehearsal.date.year ==
                                            selectedDate.year &&
                                        rehearsal.date.month ==
                                            selectedDate.month &&
                                        rehearsal.date.day == selectedDate.day,
                                  )
                                  .toList();
                        }
                        return Column(
                          children: [
                            for (var rehearsal
                                in rehearsalsForSelectedDate) ...[
                              Padding(
                                padding: EdgeInsets.only(bottom: 16.h),
                                child: Container(
                                  padding: EdgeInsets.only(
                                    top: 13.h,
                                    bottom: 12.h,
                                    right: 11.w,
                                    left: 13.6.w,
                                  ),
                                  width: 306.w,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(10.r),
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      CircleAvatar(
                                        backgroundColor: Color(0xFFF04D23),
                                        radius: 4.r,
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(
                                          left: 10.w,
                                          right: 14.w,
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              rehearsal.time,
                                              style: GoogleFonts.roboto(
                                                fontSize: 14.sp,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.black,
                                              ),
                                            ),
                                            Text(
                                              DateFormat(
                                                "dd/MM",
                                              ).format(rehearsal.date),
                                              style: GoogleFonts.roboto(
                                                fontSize: 12.sp,
                                                fontWeight: FontWeight.w400,
                                                color: Colors.black,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              rehearsal.nameOfThePerformance,
                                              style: GoogleFonts.roboto(
                                                fontSize: 14.sp,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.black,
                                              ),
                                            ),
                                            Text(
                                              rehearsal.chooseHall,
                                              style: GoogleFonts.roboto(
                                                fontSize: 12.sp,
                                                fontWeight: FontWeight.w400,
                                                color: Colors.black,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  double calculateCalendarHeight(DateTime currentMonth) {
    int numberOfWeeks =
        getNumberOfWeeksInMonth(currentMonth.year, currentMonth.month) + 1;
    return (270.h / 6 * numberOfWeeks) + 36.h + 34.86.h;
  }
}

class CalendarWidget extends StatelessWidget {
  final DateTime month; // Текущий месяц
  final DateTime? selectedDate;
  final Function(DateTime) onDateSelected;
  final List<RehearsalModel> rehearsals;

  const CalendarWidget({
    required this.month,
    required this.selectedDate,
    required this.onDateSelected,
    required this.rehearsals,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    int daysInMonth = DateTime(month.year, month.month + 1, 0).day;
    DateTime firstDayOfMonth = DateTime(month.year, month.month, 1);
    int weekdayOfFirstDay = firstDayOfMonth.weekday;

    List<Widget> calendarCells = [];

    // Добавляем названия дней недели
    List<String> weekDays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    for (String day in weekDays) {
      calendarCells.add(
        Container(
          alignment: Alignment.center,
          child: Text(
            day.toUpperCase(),
            style: GoogleFonts.inder(
              fontWeight: FontWeight.w400,
              fontSize: 10.sp,
              color: Color(0xFFB5BEC6),
            ),
          ),
        ),
      );
    }

    // Добавляем дни предыдущего месяца
    int daysInPreviousMonth = DateTime(month.year, month.month, 0).day;
    int daysToShowFromPreviousMonth = (weekdayOfFirstDay - 1) % 7;

    for (
      int i = daysInPreviousMonth - daysToShowFromPreviousMonth + 1;
      i <= daysInPreviousMonth;
      i++
    ) {
      calendarCells.add(SizedBox.shrink());
    }

    // Добавляем дни текущего месяца
    for (int i = 1; i <= daysInMonth; i++) {
      DateTime date = DateTime(month.year, month.month, i);
      List<RehearsalModel> rehearsalsForDate =
          rehearsals
              .where(
                (rehearsal) =>
                    rehearsal.date.year == date.year &&
                    rehearsal.date.month == date.month &&
                    rehearsal.date.day == date.day,
              )
              .toList();
      calendarCells.add(
        GestureDetector(
          onTap: () => onDateSelected(date),
          child: Container(
            height: 30.h,
            width: 30.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color:
                  selectedDate != null &&
                          DateFormat("dd MM yyyy").format(date) ==
                              DateFormat("dd MM yyyy").format(selectedDate!)
                      ? const Color(0xFFF04D23)
                      : Colors.transparent,
            ),
            child: Stack(
              children: [
                Center(
                  child: Text(
                    date.day.toString(),
                    style: GoogleFonts.inter(
                      color:
                          (selectedDate != null &&
                                  DateFormat("dd MM yyyy").format(date) ==
                                      DateFormat(
                                        "dd MM yyyy",
                                      ).format(selectedDate!))
                              ? Colors.white
                              : Colors.black,
                      fontWeight: FontWeight.w400,
                      fontSize: 16.sp,
                    ),
                  ),
                ),
                if (!(selectedDate != null &&
                    DateFormat("dd MM yyyy").format(date) ==
                        DateFormat("dd MM yyyy").format(selectedDate!)))
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 2.h),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: List.generate(
                          rehearsalsForDate.length > 3
                              ? 3
                              : rehearsalsForDate.length,
                          (index) => Container(
                            width: 5.w,
                            height: 5.h,
                            margin: EdgeInsets.symmetric(horizontal: 1.w),
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color(0xFFF04D23),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      );
    }

    // Добавляем пустые ячейки для выравнивания
    int size = calendarCells.length;
    for (
      int i = 1;
      size % 7 != 0 ? i <= (7 * ((size / 7).toInt() + 1)) - size : false;
      i++
    ) {
      calendarCells.add(SizedBox.shrink());
    }

    return GridView.count(
      padding: EdgeInsets.zero,
      crossAxisCount: 7,
      childAspectRatio: 220 / 258,
      children: calendarCells,
    );
  }
}

int getNumberOfWeeksInMonth(int year, int month) {
  // Получаем первый день месяца
  DateTime firstDayOfMonth = DateTime(year, month, 1);

  // Получаем последний день месяца
  DateTime lastDayOfMonth = DateTime(year, month + 1, 0);

  // Вычисляем количество дней в месяце
  int numberOfDaysInMonth = lastDayOfMonth.day;

  // Вычисляем день недели для первого дня месяца (1 - понедельник, 7 - воскресенье)
  int firstWeekdayOfMonth = firstDayOfMonth.weekday;

  // Вычисляем количество недель
  int numberOfWeeks =
      ((numberOfDaysInMonth + firstWeekdayOfMonth - 1) / 7).ceil();

  return numberOfWeeks;
}
