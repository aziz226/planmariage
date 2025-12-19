import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconly/iconly.dart';
import 'package:plan_mariage/screens/footer_view.dart';
import 'package:plan_mariage/widgets/app_button.dart';
import 'package:responsive_builder/responsive_builder.dart';

import '../core/app_colors.dart';
import '../widgets/app_text.dart';
import '../widgets/header.dart';

class ServicesPage extends StatefulWidget {
  const ServicesPage({super.key});

  @override
  State<ServicesPage> createState() => _ServicesPageState();
}

class _ServicesPageState extends State<ServicesPage> {
  bool isMobile= false, isTablet= false, isDesktop= false;
  double width= 0, height= 0;
  String? selectedValue, selectedVille;
  List<String> prestataires= [
    "Décoration",
    "Habillement",
    "Véhicules",
    "Lieux de réception",
    "Sonorisation",
    "Photographie",
    "Traiteurs",
    "Fleuristes",
  ];
  List<String> villes= [
    "Ouagadouguou",
    "Bobo-Dioulasso",
    "Koudougou",
    "Banfora",
    "Ouahigouya",
    "Tenkodogo",
    "Dédougou",
    "Fada N'Gourma",
  ];

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
  List<String> servicesDescription= [
    "Transformez votre lieu en décor de rêve ",
    "Robes, costumes et accessoires",
    "Lumousines, voitures, carrosses",
    "Châteaux, salles, jardins privatisés",
    "DJ, orchestres, animations musicales",
    "Immortaliser vos plus beaux moments",
    "Menus sur mesure et service premium",
    "Bouquets, centres de table, arches florales",
  ];


  @override
  Widget build(BuildContext context) {
    width= MediaQuery.of(context).size.width;
    height= MediaQuery.of(context).size.height;

    return  ResponsiveBuilder(builder: (context, screenSize){
      isMobile= screenSize.isMobile;
      isTablet= screenSize.isTablet;
      isDesktop= screenSize.isDesktop;

      return Scaffold(
        body: Column(
          children: [
            const SizedBox(height: 10,),
            Header(index: 1),
            Divider(
              thickness: 0.5,
              color: Colors.black,
            ),
            Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 60,),
                      RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                          children: [
                            TextSpan(
                                text: 'Découvrez nos\n',
                                style: GoogleFonts.montserrat(
                                  fontSize: isMobile? 18: 38,
                                  fontWeight: FontWeight.bold,
                                )
                            ),
                            TextSpan(
                                text: 'prestataires de qualité',
                                style: GoogleFonts.montserrat(
                                    fontSize: isMobile?  18: 38,
                                    fontWeight: FontWeight.bold,
                                    color: primaryColor
                                )
                            ),
                          ],
                      )),

                      const SizedBox(height: 20,),
                      SizedBox(
                        width: isDesktop? width*0.6: width,
                        child: AppText(text: "Plus de 1000 professionnels sélectionnés pour faire de votre mariage un moment inoubliable",
                          fontSize: isMobile? 16: 20, fontWeight: FontWeight.w500, alignement: TextAlign.center,
                          color: Colors.black54, overflow: TextOverflow.clip,
                        ),
                      ),

                      const SizedBox(height: 20,),
                      Card(
                        elevation: 2,
                        color: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Wrap(
                            spacing: 20,
                            runSpacing: 20,
                            children: [
                              SizedBox(
                                width: 250,
                                //isMobile? width: isTablet? 300:width*0.25,
                                child: TextFormField(

                                  decoration: InputDecoration(
                                      hint: AppText(text: 'Rechercher ...',
                                        color: Colors.black.withOpacity(0.7),),
                                      border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(5),
                                          borderSide: BorderSide(
                                              color: Colors.white,
                                              width: 0
                                          )
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(5),
                                          borderSide: BorderSide(
                                              color: primaryColor,
                                              width: 0
                                          )
                                      ),
                                      filled: true,
                                      fillColor: Colors.white,
                                      contentPadding: const EdgeInsets.symmetric(horizontal: 16,),
                                      prefixIcon: const Icon(IconlyLight.search)
                                  ),
                                ),
                              ),

                              SizedBox(
                                width: 250,
                                //isMobile? width: isTablet? 300: width*0.25,
                                child: DropdownButtonFormField<String>(
                                  decoration: InputDecoration(
                                    hintText: 'Toutes les catégories',

                                    hintStyle: GoogleFonts.montserrat(
                                      color: Colors.black.withOpacity(0.7),
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(5),
                                      borderSide: const BorderSide(
                                        color: Colors.white,
                                        width: 0,
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(5),
                                      borderSide: BorderSide(
                                        color: primaryColor,
                                        width: 0,
                                      ),
                                    ),
                                    filled: true,
                                    fillColor: Colors.white,
                                    contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                                  ),
                                  value: selectedValue, // ta variable d'état
                                  items:  [
                                    for (int i=0; i< prestataires.length; i++)
                                      DropdownMenuItem(
                                        value: prestataires[i],
                                        child: AppText(text: prestataires[i]),
                                      ),
                                  ],
                                  onChanged: (value) {
                                    setState(() {
                                      selectedValue = value!;
                                    });
                                  },
                                ),
                              ),

                              SizedBox(
                                width: 250,
                                child: DropdownButtonFormField<String>(
                                  decoration: InputDecoration(
                                    hintText: 'Toutes les villes',

                                    hintStyle: GoogleFonts.montserrat(
                                      color: Colors.black.withOpacity(0.7),
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(5),
                                      borderSide: const BorderSide(
                                        color: Colors.white,
                                        width: 0,
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(5),
                                      borderSide: BorderSide(
                                        color: primaryColor,
                                        width: 0,
                                      ),
                                    ),
                                    filled: true,
                                    fillColor: Colors.white,
                                    contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                                  ),
                                  value: selectedVille, // ta variable d'état
                                  items:  [
                                    for (int i=0; i< villes.length; i++)
                                      DropdownMenuItem(
                                        value: villes[i],
                                        child: AppText(text: villes[i]),
                                      ),
                                  ],
                                  onChanged: (value) {
                                    setState(() {
                                      selectedVille = value!;
                                    });
                                  },
                                ),
                              ),

                              AppButton(text: 'Filtrer', onPressed: (){})

                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 20,),
                      Column(
                        children: [
                          Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                                child: AppText(text: '6 prestataires trouvés', fontSize: 22, fontWeight: FontWeight.bold,),
                              )
                            ],
                          ),

                          const SizedBox(height: 20,),
                          Wrap(
                            spacing: 10,
                            runSpacing: 10,
                            children: [
                              ...List.generate(servicesTitle.length, (index) => InkWell(
                                onTap: (){},
                                child: Card(
                                  color: Colors.white,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)
                                  ),
                                  elevation: 2,
                                  child: SizedBox(
                                    width: isMobile? width*0.4: isTablet? 300: 300,
                                    //height: isDesktop? 400: isTablet? 300: 250,
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      spacing: 15,
                                      children: [
                                        Container(
                                          height: 200,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.only(topLeft: Radius.circular(10),
                                              topRight: Radius.circular(10),
                                          ),
                                            image: DecorationImage(
                                              image: AssetImage('assets/images/hero-wedding.jpg'),
                                              fit: BoxFit.cover,
                                            )
                                          ),
                                        ),

                                        Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                                          child: Column(
                                           spacing: 5,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(30),
                                                  color: primaryColor,
                                                ),
                                                child: Padding(
                                                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                                                  child: AppText(text: servicesTitle[index],
                                                    fontWeight: FontWeight.w600, color: Colors.white,),
                                                ),
                                              ),
                                              AppText(text: "Divers Shoot", fontSize: 18, fontWeight: FontWeight.bold,),
                                              Row(
                                                children: [
                                                  Icon(IconlyLight.location, color: Colors.black54, size: 16,),
                                                  const SizedBox(width: 5,),
                                                  AppText(text: "Ouagadougou, Zone 1", color: Colors.black54,),
                                                ],
                                              ),

                                              const SizedBox(height: 10,),
                                              AppText(text: servicesDescription[index], color: Colors.black54,
                                                overflow: TextOverflow.clip
                                              ),

                                              const SizedBox(height: 10,),
                                              Row(
                                                children: [
                                                  AppText(text: 'A partir de 325 000fcfa',
                                                    fontWeight: FontWeight.bold, color: primaryColor,
                                                    fontSize: 16,
                                                  ),
                                                ],
                                              ),

                                              const SizedBox(height: 20,)
                                            ],
                                          ),
                                        ),


                                      ],
                                    ),
                                  ),
                                ),
                              ),)
                            ],
                          ),


                          const SizedBox(height: 30,),
                          FooterView()
                        ],
                      ),

                    ],
                  ),
                )
            )
          ],
        ),
      );
    });
  }
}
