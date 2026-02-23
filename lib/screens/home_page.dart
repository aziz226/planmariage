import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:responsive_builder/responsive_builder.dart';

import '../core/app_colors.dart';
import '../core/routes.dart';
import '../screens/footer_view.dart';
import '../screens/home_view.dart';
import '../widgets/header.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedIndex = 0;

  static const List<String> _mobileRoutes = [
    homeRoute,
    serviceRoute,
    prestatairesRoute,
    contactRoute,
  ];

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(builder: (context, screenSize) {
      final isMobile = screenSize.isMobile;

      return Scaffold(
        body: Column(
          children: [
            const SizedBox(height: 10),
            const Header(index: 0),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const HomeView(),
                    if (!isMobile) const FooterView(),
                  ],
                ),
              ),
            ),
          ],
        ),
        bottomNavigationBar: isMobile
            ? BottomNavigationBar(
                currentIndex: selectedIndex,
                onTap: (index) {
                  if (index == 0) {
                    setState(() { selectedIndex = index; });
                  } else {
                    Navigator.pushNamed(context, _mobileRoutes[index]);
                  }
                },
                selectedItemColor: primaryColor,
                unselectedItemColor: Colors.grey,
                type: BottomNavigationBarType.fixed,
                items: const [
                  BottomNavigationBarItem(icon: Icon(IconlyLight.home), label: 'Accueil'),
                  BottomNavigationBarItem(icon: Icon(IconlyLight.category), label: 'Services'),
                  BottomNavigationBarItem(icon: Icon(IconlyLight.search), label: 'Prestataires'),
                  BottomNavigationBarItem(icon: Icon(IconlyLight.chat), label: 'Contact'),
                ],
              )
            : null,
      );
    });
  }
}
