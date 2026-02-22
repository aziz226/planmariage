import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:plan_mariage/screens/footer_view.dart';
import 'package:plan_mariage/screens/home_view.dart';
import 'package:plan_mariage/widgets/header.dart';
import 'package:responsive_builder/responsive_builder.dart';

import '../core/data.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedIndex = 0;

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
                  setState(() { selectedIndex = index; });
                },
                items: List.generate(
                  menuItems.length,
                  (index) => BottomNavigationBarItem(
                    icon: const Icon(IconlyLight.home),
                    label: menuItems[index],
                  ),
                ),
              )
            : null,
      );
    });
  }
}
