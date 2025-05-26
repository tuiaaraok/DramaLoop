import 'package:flutter/material.dart';
import 'package:flutter_application_4/menu_page.dart';
import 'package:flutter_application_4/provider/them_provider.dart';
import 'package:flutter_application_4/setting_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  List<Map<String, String>> onboarding = [
    {
      "image": "assets/onboarding1.png",
      "text":
          "This is a universal solution for production managers, which helps to organize the work of the theater, manage the rehearsal schedule, take into account the props and the schedule of the actors.",
      "button": "Let’s start!",
    },
    {
      "image": "assets/ondoarding2.png",
      "text":
          "The application combines ease of use, data accuracy and flexibility of settings, making it an ideal tool for professional work.",
      "button": "Let’s start!",
    },
  ];
  int currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: double.infinity,
        child: SafeArea(
          child: Column(
            children: [
              SizedBox(height: 20.h),
              Image.asset(
                onboarding[currentIndex]["image"]!,
                width: 310.17.w,
                height: 313.h,
              ),
              SizedBox(height: 24.h),
              SizedBox(
                width: 362.w,
                child: Text(
                  onboarding[currentIndex]["text"]!,
                  style: GoogleFonts.roboto(
                    height: 1.2,
                    fontSize: 22.sp,
                    fontWeight: FontWeight.w400,
                    color:
                        context.watch<ThemeProvider>().isDarkMode
                            ? Colors.white
                            : Colors.black,
                  ),
                ),
              ),
              Spacer(),
              MenuAndSettingWidget(
                title: onboarding[currentIndex]["button"]!,
                onTap: () {
                  if (currentIndex == 1) {
                    Navigator.push(
                      context,
                      MaterialPageRoute<void>(
                        builder: (BuildContext context) => const MenuPage(),
                      ),
                    );
                  } else {
                    setState(() {
                      currentIndex++;
                    });
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
