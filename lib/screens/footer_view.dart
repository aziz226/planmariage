import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:responsive_builder/responsive_builder.dart';

import '../core/app_colors.dart';
import '../core/variable_name.dart';
import '../widgets/app_text.dart';

class FooterView extends StatefulWidget {
  const FooterView({super.key});

  @override
  State<FooterView> createState() => _FooterViewState();
}

class _FooterViewState extends State<FooterView> {
  bool isMobile= false, isTablet= false, isDesktop= false;
  double width= 0, height= 0;

  List<String> servicesTitle= [
    "Décoration",
    "Habillement",
    "Véhicules",
    "Lieux de réception",
    "Sonorisation",
    "Photographie",
    "Traiteurs",
    "Fleuristes",
  ];
  List<String> support= [
    "A propos",
    "FAQ",
    "Conditions générales",
    "Politique de confidentialité",
    "Contact",
  ];

  @override
  Widget build(BuildContext context) {
    width= MediaQuery.of(context).size.width;
    height= MediaQuery.of(context).size.height;
    return ResponsiveBuilder(builder: (context, screenSize){
      isMobile= screenSize.isMobile;
      isTablet= screenSize.isTablet;
      isDesktop= screenSize.isDesktop;

      return Container(
        color: Colors.black,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 350,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 20,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12.0),
                      child: Row(
                        children: [
                          Icon(
                            CupertinoIcons.heart_fill,
                            color: primaryColor,
                            size: 40,
                          ),
                          AppText(text: appName, fontWeight: FontWeight.bold, fontSize: 32, color: Colors.white,),
                        ],
                      ),
                    ),
                    AppText(text: "La plateforme de référence pour organiser votre mariage de rêve. Plus de 1000 prestataires sélectionnés pour vous accompagner dans cette aventure unique.",
                          fontWeight: FontWeight.bold,color: Colors.white, overflow: TextOverflow.clip,),

                    Column(
                      spacing: 5,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          spacing: 10,
                          children: [
                            Icon(IconlyLight.call, color: primaryColor,),
                            AppText(text: '+226 70 90 00 00', color: Colors.white,)
                          ],
                        ),
                        Row(
                          spacing: 10,
                          children: [
                            Icon(IconlyLight.message, color: primaryColor,),
                            AppText(text: 'diversshoot@gmail.com', color: Colors.white,)
                          ],
                        ),
                        Row(
                          spacing: 10,
                          children: [
                            Icon(IconlyLight.location, color: primaryColor,),
                            AppText(text: 'Ouagadougou, Burkina Faso', color: Colors.white,)
                          ],
                        ),
                      ],
                    ),

                    const SizedBox(height: 40,)

                  ],
                ),
              ),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText(text: "Services", fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white,),
                  const SizedBox(height: 20,),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: List.generate(servicesTitle.length, (index) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6.0),
                      child: AppText(text: servicesTitle[index], color: Colors.white,),
                    )),
                  )
                ],
              ),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText(text: "Aide & Support", fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white,),
                  const SizedBox(height: 20,),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: List.generate(support.length, (index) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6.0),
                      child: AppText(text: support[index], color: Colors.white,),
                    )),
                  )
                ],
              ),
            ],
          ),
        ),
      );
    });
  }
}
