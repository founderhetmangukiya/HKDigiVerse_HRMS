import 'package:demo_project/views/home_view.dart';
import 'package:demo_project/views/login_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const HKDigiVerseApp());
}

class HKDigiVerseApp extends StatelessWidget {
  const HKDigiVerseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: "HK's HRMS",
      home: LoginPage(),

      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Poppins',

        scaffoldBackgroundColor: Colors.white,

        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF00B686)),
      ),
    );
  }
}
