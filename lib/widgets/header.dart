import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:plan_mariage/core/routes.dart';
import 'package:responsive_builder/responsive_builder.dart';

import '../core/app_colors.dart';
import '../core/data.dart';
import '../core/variable_name.dart';
import 'app_button.dart';
import 'app_text.dart';

class Header extends StatelessWidget {
  final int index;
  const Header({super.key, required this.index});

  static const List<String> _routes = [homeRoute, serviceRoute, '', ''];

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return ResponsiveBuilder(builder: (context, screenSize) {
      final isMobile = screenSize.isMobile;
      final isDesktop = screenSize.isDesktop;

      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          if (isDesktop)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12.0),
              child: Row(
                children: [
                  const Icon(CupertinoIcons.heart_fill, color: primaryColor, size: 40),
                  const AppText(text: appName, fontWeight: FontWeight.bold, fontSize: 32),
                ],
              ),
            ),
          if (!isMobile)
            Row(
              children: List.generate(menuItems.length, (i) => TextButton(
                onPressed: () {
                  if (_routes[i].isNotEmpty) {
                    Navigator.pushNamed(context, _routes[i]);
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: AppText(
                    text: menuItems[i],
                    fontWeight: index == i ? FontWeight.bold : FontWeight.w500,
                    fontSize: 18,
                    color: index == i ? primaryColor : Colors.black54,
                  ),
                ),
              )),
            ),
          Row(
            children: [
              IconButton(
                onPressed: () {},
                icon: const Icon(IconlyLight.buy, color: Colors.black54),
                style: IconButton.styleFrom(
                  padding: const EdgeInsets.all(12),
                  hoverColor: primaryColor,
                ),
              ),
              const SizedBox(width: 8),
              AppButton(text: 'Se connecter', onPressed: () {}),
            ],
          ),
        ],
      );
    });
  }
}
