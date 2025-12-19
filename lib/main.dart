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

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: appName,
      theme: ThemeData(

        colorScheme: ColorScheme.fromSeed(seedColor: primaryColor),
      ),
      //home: const MyHomePage(title: 'Flutter Demo Home Page'),
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => const HomePage(),
        serviceRoute: (context) => ServicesPage()
      },
    );
  }
}

