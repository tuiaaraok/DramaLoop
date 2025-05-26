import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_application_4/provider/them_provider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final currentmode =
        context.watch<ThemeProvider>().isDarkMode ? "Dark" : "Light";
    return Scaffold(
      body: SizedBox(
        width: double.infinity,
        child: Padding(
          padding: EdgeInsets.only(top: MediaQuery.paddingOf(context).top),
          child: Column(
            children: [
              SizedBox(
                width: 362.w,
                child: Row(
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
                    Padding(
                      padding: EdgeInsets.only(left: 97.w),
                      child: Text(
                        "Settings",
                        style: GoogleFonts.roboto(
                          fontSize: 22.sp,
                          fontWeight: FontWeight.bold,
                          color:
                              context.watch<ThemeProvider>().isDarkMode
                                  ? Colors.white
                                  : Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 30.h),
              SizedBox(
                width: 342.w,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children:
                      ["Light", "Dark"].map((toElement) {
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              context.read<ThemeProvider>().toggleTheme(
                                toElement == "Dark",
                              );
                            });
                          },
                          child: Container(
                            width: 156.w,
                            height: 107.h,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(
                                Radius.circular(8.r),
                              ),
                              color: Colors.white,
                              border: Border.all(
                                color:
                                    currentmode == toElement
                                        ? Color(0xFF6C4AE5)
                                        : Colors.white,
                                width: 2.w,
                              ),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  "assets/${toElement.toLowerCase()}.png",
                                ),
                                Text(
                                  "$toElement mode",
                                  style: GoogleFonts.roboto(
                                    fontSize: 22.sp,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                ),
              ),
              SizedBox(height: 82.h),
              SizedBox(
                height: 210.h,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    MenuAndSettingWidget(
                      title: 'Contact us',
                      onTap: () async {
                        String? encodeQueryParameters(
                          Map<String, String> params,
                        ) {
                          return params.entries
                              .map(
                                (MapEntry<String, String> e) =>
                                    '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}',
                              )
                              .join('&');
                        }

                        // ···
                        final Uri emailLaunchUri = Uri(
                          scheme: 'mailto',
                          path: 'aykutsahin222@icloud.com',
                          query: encodeQueryParameters(<String, String>{
                            '': '',
                          }),
                        );
                        try {
                          if (await canLaunchUrl(emailLaunchUri)) {
                            await launchUrl(emailLaunchUri);
                          } else {
                            throw Exception("Could not launch $emailLaunchUri");
                          }
                        } catch (e) {
                          log(
                            'Error launching email client: $e',
                          ); // Log the error
                        }
                      },
                    ),
                    MenuAndSettingWidget(
                      title: 'Privacy policy',
                      onTap: () async {
                        final Uri url = Uri.parse(
                          'https://docs.google.com/document/d/1js5earTYoiLeGWrx4U61VSo66QDF2F8OXUibub6k2W8/mobilebasic',
                        );
                        if (!await launchUrl(url)) {
                          throw Exception('Could not launch $url');
                        }
                      },
                    ),
                    MenuAndSettingWidget(
                      title: 'Rate us',
                      onTap: () {
                        InAppReview.instance.openStoreListing(
                          appStoreId: '6746263545',
                        );
                        // 6746263545
                      },
                    ),
                  ],
                ),
              ),
              Spacer(),
              Image.asset("assets/menu.png", width: 310.17.w, height: 313.h),
            ],
          ),
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class MenuAndSettingWidget extends StatelessWidget {
  MenuAndSettingWidget({super.key, required this.title, required this.onTap});
  final String title;
  Function() onTap;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 362.w,
        height: 58.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(30.r)),
          color: Color(0xFFA17CFF),
        ),
        child: Center(
          child: Text(
            title,
            style: GoogleFonts.roboto(
              fontSize: 22.sp,
              fontWeight: FontWeight.w500,
              color:
                  context.watch<ThemeProvider>().isDarkMode
                      ? Colors.black
                      : Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
