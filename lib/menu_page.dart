import 'package:flutter/material.dart';
import 'package:flutter_application_4/accounting_for_props_page.dart';
import 'package:flutter_application_4/actors_schedule_page.dart';
import 'package:flutter_application_4/calendar/calendar_page.dart';
import 'package:flutter_application_4/calendar/date/calendar_bloc.dart';
import 'package:flutter_application_4/history_of_productions_page.dart';
import 'package:flutter_application_4/setting_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({super.key});

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: double.infinity,
        child: SafeArea(
          child: Column(
            children: [
              SizedBox(height: 20.h),
              Image.asset("assets/menu.png", width: 310.17.w, height: 313.h),
              SizedBox(height: 44.h),
              SizedBox(
                height: 362.h,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    MenuAndSettingWidget(
                      title: 'Rehearsal schedule',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (BuildContext context) => BlocProvider(
                                  create:
                                      (context) =>
                                          CalendarBloc(), // Create the bloc here!
                                  child: const CalendarPage(),
                                ),
                          ),
                        );
                      },
                    ),
                    MenuAndSettingWidget(
                      title: 'Accounting for props',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute<void>(
                            builder:
                                (BuildContext context) =>
                                    const AccountingForPropsPage(),
                          ),
                        );
                      },
                    ),
                    MenuAndSettingWidget(
                      title: 'Actors schedule',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute<void>(
                            builder:
                                (BuildContext context) =>
                                    const ActorsSchedulePage(),
                          ),
                        );
                      },
                    ),
                    MenuAndSettingWidget(
                      title: 'History of productions',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute<void>(
                            builder:
                                (BuildContext context) =>
                                    const HistoryOfProductionsPage(),
                          ),
                        );
                      },
                    ),
                    MenuAndSettingWidget(
                      title: 'Settings',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute<void>(
                            builder:
                                (BuildContext context) => const SettingPage(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
