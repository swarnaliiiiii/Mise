import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mise_frontend/app/home_view.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Set the design size based on your reference (standard iPhone/Android)
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, child) {
        return MaterialApp(
          title: "Mise Expense Tracker",
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            brightness: Brightness.dark,
            scaffoldBackgroundColor: const Color(0xFF0A0A0A),
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color(0xFFB4F59E),
              brightness: Brightness.dark,
            ),
          ),
          home: child,
        );
      },
      child: const HomeView(),
    );
  }
}