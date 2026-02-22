import 'package:flutter/material.dart';
import 'package:plan_mariage/core/app_colors.dart';
import 'package:plan_mariage/core/variable_name.dart';
import 'package:plan_mariage/screens/home_page.dart';
import 'package:plan_mariage/screens/services_page.dart';

import 'core/routes.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: appName,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: primaryColor),
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: homeRoute,
      routes: {
        homeRoute: (context) => const HomePage(),
        serviceRoute: (context) => const ServicesPage(),
      },
    );
  }
}
