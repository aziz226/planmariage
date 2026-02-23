import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:plan_mariage/core/routes.dart';
import 'package:responsive_builder/responsive_builder.dart';

import '../core/app_colors.dart';
import '../core/variable_name.dart';
import '../screens/home_view.dart';
import '../screens/services_page.dart';
import 'app_button.dart';
import 'app_text.dart';

class Header extends StatefulWidget {
  final int index;
  const Header({super.key, required this.index});

  @override
  State<Header> createState() => _HeaderState();
}

class _HeaderState extends State<Header> {
  bool isMobile= false, isTablet= false, isDesktop= false;
  double width= 0, height= 0;
  List<String> menuItems= [
    'Acceuil',
    "Services",
    //"Packs",
    "Prestataires",
    "Contact"
  ];
  List<String> route= [
    homeRoute,
    serviceRoute,
    prestataireRoute,
    ''
  ];
  int selectedIndex= 0;
  bool isAuthenticated= false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      selectedIndex= widget.index;
    });
  }

  @override
  Widget build(BuildContext context) {
    width= MediaQuery.of(context).size.width;
    height= MediaQuery.of(context).size.height;
    return ResponsiveBuilder(builder: (context, screenSize){
      isMobile= screenSize.isMobile;
      isTablet= screenSize.isTablet;
      isDesktop= screenSize.isDesktop;
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          if(isDesktop)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12.0),
              child: Row(
                children: [
                  Icon(
                    CupertinoIcons.heart_fill,
                    color: primaryColor,
                    size: 40,
                  ),
                  AppText(text: appName, fontWeight: FontWeight.bold, fontSize: 32,),
                ],
              ),
            ),
          if(!isMobile)Row(
            children: List.generate(menuItems.length, (index) => TextButton(
              onPressed: (){
                setState(() {
                  selectedIndex= index;
                  Navigator.pushNamed(context, route[index]);
                });
              },

              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0,),
                child: AppText(text: menuItems[index], fontWeight:selectedIndex== index? FontWeight.bold: FontWeight.w500,
                  fontSize: 18, color: selectedIndex== index? primaryColor: Colors.black54,),
              ),
            )),
          ),

          Row(
            children: [
              IconButton(
                onPressed: (){},
                icon: const Icon(IconlyLight.buy, color: Colors.black54,),
                style: IconButton.styleFrom(
                    padding: const EdgeInsets.all(12),
                    hoverColor: primaryColor
                ),
              ),
              const SizedBox(width: 8,),
              AppButton(text: 'Se connecter', onPressed: (){}),

              if(isAuthenticated)
                OutlinedButton(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: primaryColor, width: 1),
                      backgroundColor: Colors.white,
                      foregroundColor: primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: Row(
                        spacing: 5,
                        children: [
                          Icon(IconlyLight.profile),
                          AppText(text: 'Mon Compte', fontWeight: FontWeight.bold,
                            color: primaryColor,),
                        ],
                      ),
                    )
                )

            ],
          )
        ],
      );
    });
  }
}
