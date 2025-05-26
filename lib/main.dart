import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_4/firebase_options.dart';
import 'package:flutter_application_4/hive/hive_boxes.dart';
import 'package:flutter_application_4/hive/model/pods_model.dart';
import 'package:flutter_application_4/hive/model/rehearsal_model.dart';
import 'package:flutter_application_4/menu_page.dart';
import 'package:flutter_application_4/onboarding_page.dart';
import 'package:flutter_application_4/provider/them_provider.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'calendar/date/calendar.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await Hive.initFlutter();
  await Hive.openBox("privacyLink");
  await Hive.openBox("Settings");
  Hive.registerAdapter(RehearsalModelAdapter());
  Hive.registerAdapter(PodsModelAdapter());
  await Hive.openBox<RehearsalModel>(HiveBoxes.rehearsalModel);
  await Hive.openBox<PodsModel>(HiveBoxes.podsModel);
  final InAppReview inAppReview = InAppReview.instance;
  if (await inAppReview.isAvailable()) {
    Future.delayed(const Duration(seconds: 10), () {
      inAppReview.requestReview();
    });
  }
  await _initializeRemoteConfig().then((onValue) {
    runApp(MyApp(link: onValue));
  });
}

Future<String> _initializeRemoteConfig() async {
  final remoteConfig = FirebaseRemoteConfig.instance;

  String link = '';

  if (Hive.box("privacyLink").isEmpty) {
    await remoteConfig.setConfigSettings(
      RemoteConfigSettings(
        fetchTimeout: const Duration(minutes: 1),
        minimumFetchInterval: const Duration(minutes: 1),
      ),
    );

    try {
      await remoteConfig.fetchAndActivate();
      link = remoteConfig.getString("link");
    } catch (e) {
      log("Failed to fetch remote config: $e");
    }
  } else {
    if (Hive.box("privacyLink").get('link').contains("showAgreebutton")) {
      await remoteConfig.setConfigSettings(
        RemoteConfigSettings(
          fetchTimeout: const Duration(minutes: 1),
          minimumFetchInterval: const Duration(minutes: 1),
        ),
      );

      try {
        await remoteConfig.fetchAndActivate().whenComplete(() {
          link = remoteConfig.getString("link");
          if (!link.contains("showAgreebutton") && link.isNotEmpty) {
            Hive.box("privacyLink").put('link', link);
          }
        });
      } catch (e) {
        log("Failed to fetch remote config: $e");
      }
    } else {
      link = Hive.box("privacyLink").get('link');
    }
  }

  return link == ""
      ? "https://telegra.ph/DramaLoop-Act-Flow---Privacy-Policy-05-22?showAgreebutton"
      : link;
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.link});
  final String link;

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(402, 874),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, child) {
        return ValueListenableBuilder<Box>(
          valueListenable: Hive.box('Settings').listenable(),
          builder: (context, box, _) {
            return ChangeNotifierProvider(
              create: (_) => ThemeProvider(box),
              child: Consumer<ThemeProvider>(
                builder: (context, provider, _) {
                  return MaterialApp(
                    title: 'Flutter Demo',
                    debugShowCheckedModeBanner: false,
                    theme: ThemeData(
                      scaffoldBackgroundColor:
                          context.watch<ThemeProvider>().isDarkMode
                              ? Color(0xFF130634)
                              : const Color(0xFFE9E2FB),
                      appBarTheme: const AppBarTheme(
                        backgroundColor: Colors.transparent,
                        systemOverlayStyle: SystemUiOverlayStyle.dark,
                      ),

                      colorScheme: Theme.of(
                        context,
                      ).colorScheme.copyWith(outline: Colors.transparent),
                    ),
                    home: MultiBlocProvider(
                      providers: [
                        BlocProvider<CalendarBloc>(
                          create: (BuildContext context) => CalendarBloc(),
                        ),
                      ],
                      child:
                          Hive.box("privacyLink").isEmpty
                              ? WebViewScreen(link: link)
                              : Hive.box(
                                "privacyLink",
                              ).get('link').contains("showAgreebutton")
                              ? const MenuPage()
                              : WebViewScreen(link: link),
                    ),
                  );
                },
              ),
            );
          },
        );
      },
    );
  }
}

class WebViewScreen extends StatefulWidget {
  const WebViewScreen({super.key, required this.link});
  final String link;

  @override
  State<WebViewScreen> createState() {
    return _WebViewScreenState();
  }
}

class _WebViewScreenState extends State<WebViewScreen> {
  bool loadAgree = false;
  WebViewController controller = WebViewController();
  final remoteConfig = FirebaseRemoteConfig.instance;

  @override
  void initState() {
    super.initState();

    _initializeWebView(widget.link); // Initialize WebViewController
  }

  void _initializeWebView(String url) {
    controller =
        WebViewController()
          ..setJavaScriptMode(JavaScriptMode.unrestricted)
          ..setNavigationDelegate(
            NavigationDelegate(
              onProgress: (int progress) {
                if (progress == 100) {
                  loadAgree = true;
                  setState(() {});
                }
              },
              onPageStarted: (String url) {},
              onPageFinished: (String url) {},
              onHttpError: (HttpResponseError error) {},
              onWebResourceError: (WebResourceError error) {},
              onNavigationRequest: (NavigationRequest request) {
                if (request.url.startsWith('https://www.youtube.com/')) {
                  return NavigationDecision.prevent;
                }
                return NavigationDecision.navigate;
              },
            ),
          )
          ..loadRequest(Uri.parse(url));
    setState(() {}); // Optional, if you want to trigger a rebuild elsewhere
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.only(top: MediaQuery.paddingOf(context).top),
        child: Stack(
          children: [
            WebViewWidget(controller: controller),
            if (loadAgree) ...[
              if (widget.link.contains("showAgreebutton")) ...[
                GestureDetector(
                  onTap: () async {
                    await Hive.openBox('privacyLink').then((box) {
                      box.put('link', widget.link);
                      Navigator.push(
                        // ignore: use_build_context_synchronously
                        context,
                        MaterialPageRoute<void>(
                          builder:
                              (BuildContext context) => const OnboardingPage(),
                        ),
                      );
                    });
                  },
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: Container(
                        width: 200,
                        height: 60,
                        color: Colors.amber,
                        child: const Center(child: Text("AGREE")),
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ],
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class AppBarIcon extends StatelessWidget {
  AppBarIcon({super.key, required this.onTap, required this.icon});
  Function() onTap;
  Widget icon;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 32.w,
        height: 32.h,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.black, width: 1.w),
          boxShadow: [BoxShadow(offset: Offset(0, 1.33), color: Colors.black)],
        ),
        child: Center(child: icon),
      ),
    );
  }
}
