import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';

import '../core/app_colors.dart';
import '../core/data.dart';
import '../core/variable_name.dart';
import '../widgets/app_text.dart';

class FooterView extends StatelessWidget {
  const FooterView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: 350,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 20,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12.0),
                    child: Row(
                      children: [
                        const Icon(CupertinoIcons.heart_fill, color: primaryColor, size: 40),
                        const AppText(text: appName, fontWeight: FontWeight.bold, fontSize: 32, color: Colors.white),
                      ],
                    ),
                  ),
                  const AppText(
                    text: "La plateforme de référence pour organiser votre mariage de rêve. Plus de 1000 prestataires sélectionnés pour vous accompagner dans cette aventure unique.",
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    overflow: TextOverflow.clip,
                  ),
                  const Column(
                    spacing: 5,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        spacing: 10,
                        children: [
                          Icon(IconlyLight.call, color: primaryColor),
                          AppText(text: '+226 70 90 00 00', color: Colors.white),
                        ],
                      ),
                      Row(
                        spacing: 10,
                        children: [
                          Icon(IconlyLight.message, color: primaryColor),
                          AppText(text: 'diversshoot@gmail.com', color: Colors.white),
                        ],
                      ),
                      Row(
                        spacing: 10,
                        children: [
                          Icon(IconlyLight.location, color: primaryColor),
                          AppText(text: 'Ouagadougou, Burkina Faso', color: Colors.white),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const AppText(text: "Services", fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white),
                const SizedBox(height: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: services.map((s) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6.0),
                    child: AppText(text: s.title, color: Colors.white),
                  )).toList(),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const AppText(text: "Aide & Support", fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white),
                const SizedBox(height: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: supportLinks.map((s) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6.0),
                    child: AppText(text: s, color: Colors.white),
                  )).toList(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
