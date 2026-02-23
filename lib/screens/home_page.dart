import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconly/iconly.dart';
import 'package:plan_mariage/core/app_colors.dart';
import 'package:plan_mariage/core/variable_name.dart';
import 'package:plan_mariage/screens/footer_view.dart';
import 'package:plan_mariage/screens/home_view.dart';
import 'package:plan_mariage/screens/prestataires_pages.dart';
import 'package:plan_mariage/screens/services_page.dart';
import 'package:plan_mariage/widgets/app_button.dart';
import 'package:plan_mariage/widgets/app_text.dart';
import 'package:plan_mariage/widgets/header.dart';
import 'package:responsive_builder/responsive_builder.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isMobile= false, isTablet= false, isDesktop= false;
  double width= 0, height= 0;
  List<String> menuItems= [
    'Acceuil',
    "Services",
    //"Packs",
    "Prestataires",
    "Contact"
  ];
  List<Widget> page= [
    HomeView(),
    ServicesPage(),
    PrestatairesPages(),
    ServicesPage(),
  ];
  int selectedIndex= 0;
  bool isAuthenticated= false;

  @override
  Widget build(BuildContext context) {
    width= MediaQuery.of(context).size.width;
    height= MediaQuery.of(context).size.height;

    return ResponsiveBuilder(builder: (context, screenSize){
        isMobile= screenSize.isMobile;
        isTablet= screenSize.isTablet;
        isDesktop= screenSize.isDesktop;

        return Scaffold(
          body: Column(
            children: [
              const SizedBox(height: 10,),
              Header(index: 0),

              Expanded(
                child: SingleChildScrollView(
                  child:Column(
                      children: [
                        HomeView(),

                        if(!isMobile)
                          FooterView()
                      ],
                    ),
                ),
              )
            ],
          ),

          bottomNavigationBar: isMobile? BottomNavigationBar(
            currentIndex: selectedIndex,
            onTap: (index){
              setState(() {
                selectedIndex= index;
              });
            },
            items: List.generate(menuItems.length, (index) => BottomNavigationBarItem(
              icon: const Icon(IconlyLight.home),
              label: menuItems[index]
            )
          ),
        ): null
        );
      });

  }
}
