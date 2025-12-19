import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconly/iconly.dart';
import 'package:ionicons/ionicons.dart';
import 'package:plan_mariage/widgets/hover_button.dart';
import 'package:responsive_builder/responsive_builder.dart';

import '../core/app_colors.dart';
import '../widgets/app_button.dart';
import '../widgets/app_text.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
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

  List<int> nbre= [
    150, 80, 45, 200, 120, 90, 110, 75
  ];

  List<String> prestataires= [
    "prestataires",
    "boutiques",
    "locations",
    "lieux",
    "artistes",
    "photographes",
    "traiteurs",
    "fleuristes",
  ];

  List<IconData> servicesIcon= [
    Icons.palette_outlined,
    Ionicons.shirt_outline,
    CupertinoIcons.car_detailed,
    CupertinoIcons.building_2_fill,
    CupertinoIcons.music_note_2,
    CupertinoIcons.camera,
    Icons.restaurant,
    Ionicons.rose_outline,
  ];

  //Packs
  List<String> packsTitle= [
    "Pack Essentiel",
    "Pack Pestige",
    "Pack Royal",
  ];
  List<String> packsQualif= [
    "Populaire",
    "Recommandé",
    "Luxe",
  ];
  List<String> packsPrices= [
    "950 000 FCFA",
    "1 500 000 FCFA",
    "5 000 000 FCFA",
  ];
  List<String> packsDescription= [
    "Pour un mariage intime et authentique",
    "L'équilibre parfait entre élégance et budget",
    "Le mariage de vos rêves, sans compromis",
  ];
  List<List<String>> packsIncludes= [
    [
      "Lieu de réception (50 personnes)",
      "Décoration florale simple",
      "Photographe (4h)",
      "DJ ou playlist",
      "Menu 3 services",
    ],
    [
      "Lieu de prestige (100 personnes)",
      "Décoration personnalisée",
      "Photographe & vidéaste (8h)",
      "Orchestre ou DJ premium",
      "Menu gastronomique 4 services",
      "Coordination jour J",
    ],
    [
      "Château ou domaine d'exception (150+ personnes)",
      "Décoration haut de gamme sur mesure",
      "Photographe + vidéaste premium journée complète",
      "Orchestre live + DJ",
      "Menu signature par chef étoilé",
      "Wedding planner dédiée",
      "Limousine ou voiture de collection",
      "Suite nuptiale incluse"
    ],
  ];

  @override
  Widget build(BuildContext context) {
    width= MediaQuery.of(context).size.width;
    height= MediaQuery.of(context).size.height;

    return ResponsiveBuilder(builder: (context, screenSize){
      isMobile= screenSize.isMobile;
      isTablet= screenSize.isTablet;
      isDesktop= screenSize.isDesktop;

      return Column(
        children: [
          Stack(
            children: [
              Container(
                height: height*0.8,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('assets/images/hero-wedding.jpg'),
                        fit: BoxFit.cover,
                        alignment: Alignment.centerRight
                    )
                ),
              ),
              Container(
                height: height*0.8,
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [
                        Colors.white.withOpacity(0.8),
                        Colors.white.withOpacity(0.6),
                        Colors.white.withOpacity(0.5),
                        Colors.white.withOpacity(0.2),
                        Colors.white.withOpacity(0.08),
                      ],
                    )
                ),
              ),
              Align(
                  alignment: Alignment.topLeft,
                  child: Container(
                    width: isDesktop? width*0.5: width,
                    height: height*0.8,
                    //color: Colors.white.withOpacity(0.65),

                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: isDesktop? 60: 20.0),
                      child: Column(
                        spacing: 30,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Align(
                            alignment: Alignment.topLeft,

                            child: RichText(text: TextSpan(
                                children: [
                                  TextSpan(
                                      text: 'Votre mariage de\n',
                                      style: GoogleFonts.montserrat(
                                        fontSize: isMobile? 32: 48,
                                        fontWeight: FontWeight.bold,
                                      )
                                  ),
                                  TextSpan(
                                      text: 'rêve commence ici.',
                                      style: GoogleFonts.montserrat(
                                          fontSize: isMobile?  32: 48,
                                          fontWeight: FontWeight.bold,
                                          color: primaryColor
                                      )
                                  ),
                                ]
                            )),
                          ),

                          AppText(text: "Découvrez tous les services pour organiser le mariage parfait. Des prestataires de qualité, des packs adaptés à votre budget.",
                            fontSize: isMobile? 16: 20, fontWeight: FontWeight.w500, alignement: TextAlign.justify,
                            color: Colors.black54, overflow: TextOverflow.clip,
                          ),

                          Row(
                            spacing: 20,
                            children: [
                              Expanded(
                                child: TextFormField(

                                  decoration: InputDecoration(
                                      hint: AppText(text: 'Rechercher un service, un lieu, un prestataire...',
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
                                              color: Colors.white,
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
                              AppButton(text: 'Rechercher', onPressed: (){})
                            ],
                          ),


                          Wrap(
                            runSpacing: 20,
                            spacing: 20,
                            children: [
                              AppButton(text: 'Découvrir nos packs', onPressed: (){}),
                              AppButton(text: 'Voir tous les services', onPressed: (){},
                                btnColor: Colors.white, textColor: primaryColor,
                              ),
                            ],
                          )


                        ],
                      ),
                    ),
                  )
              ),
            ],
          ),

          // Services
          SizedBox(height: isDesktop? 60: 20,),

          Column(
            children: [
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  children: [
                    TextSpan(
                        text: 'Tous nos services de mariage\n',
                        style: GoogleFonts.montserrat(
                          fontSize: isMobile? 22: 32,
                          fontWeight: FontWeight.bold,
                        )
                    ),
                    TextSpan(
                        text: 'en un seul endroit',
                        style: GoogleFonts.montserrat(
                            fontSize: isMobile?  22: 32,
                            fontWeight: FontWeight.bold,
                            color: primaryColor
                        )
                    ),
                  ]
              )),

              const SizedBox(height: 20,),
              SizedBox(
                width: isDesktop? width*0.6: width,
                child: AppText(text: "Une selection rigoureuse de prestataires professionnels pour chaque aspect de votre mariage.",
                  fontSize: isMobile? 16: 20, fontWeight: FontWeight.w500, alignement: TextAlign.center,
                  color: Colors.black54, overflow: TextOverflow.clip,
                ),
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
                        width: isMobile? width*0.4: isTablet? 300: width*0.2,
                        height: isDesktop? 300: isTablet? 300: 250,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          spacing: 15,
                          children: [

                            Padding(
                              padding: const EdgeInsets.only(top: 22.0),
                              child: CircleAvatar(
                                radius: isMobile? 25: 35,
                                backgroundColor: primaryColor.withOpacity(0.1),
                                child: Icon(servicesIcon[index], size: isMobile? 25: 35, color: primaryColor,),
                              ),
                            ),
                            AppText(text: servicesTitle[index], fontSize: isMobile? 14: 16, fontWeight: FontWeight.w600,),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8.0),
                              child: AppText(text: servicesDescription[index],
                                //fontSize: isMobile? 12: 14,
                                color: Colors.grey, alignement: TextAlign.center,
                                overflow: TextOverflow.clip,
                              ),
                            ),

                            Padding(
                              padding: const EdgeInsets.only(top: 8.0, bottom: 20),
                              child: AppText(text: "${nbre[index]}+ ${prestataires[index]}",fontWeight: FontWeight.bold, color: primaryColor,),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),)
                ],
              ),

              const SizedBox(height: 30,),
              AppButton(text: 'Voir les services', onPressed: (){},),
              const SizedBox(height: 30,),
            ],
          ),

          // Packs
          SizedBox(height: isDesktop? 60: 20,),

          Column(
            children: [
              RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                      children: [
                        TextSpan(
                            text: 'Nos packs tout compris\n',
                            style: GoogleFonts.montserrat(
                              fontSize: isMobile? 22: 32,
                              fontWeight: FontWeight.bold,
                            )
                        ),
                        TextSpan(
                            text: 'adaptés à votre budget',
                            style: GoogleFonts.montserrat(
                                fontSize: isMobile?  22: 32,
                                fontWeight: FontWeight.bold,
                                color: primaryColor
                            )
                        ),
                      ]
                  )),

              const SizedBox(height: 20,),
              SizedBox(
                width: isDesktop? width*0.6: width,
                child: AppText(text: "Simplifiez-vous la vie avec nos formules clés en main, conçues par nos experts",
                  fontSize: isMobile? 16: 20, fontWeight: FontWeight.w500, alignement: TextAlign.center,
                  color: Colors.black54, overflow: TextOverflow.clip,
                ),
              ),

              const SizedBox(height: 20,),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    ...List.generate(packsTitle.length, (index) => Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: primaryColor,
                            width: 1
                          )
                        ),
                        child: Container(
                          width: isMobile? width: isTablet? 350: width*0.3,
                          height: isDesktop? 800: null,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              spacing: 15,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Wrap(
                                  //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(top: 25.0),
                                      child: AppText(text: packsTitle[index], fontSize: isMobile? 16: 22, fontWeight: FontWeight.bold,),
                                    ),
                                    Container(
                                      width: 150,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(30),
                                        color: packsQualif[index]== "Recommandé"? Colors.green: primaryColor
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 2),
                                        child: Row(
                                          spacing: 5,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Icon(IconlyLight.star, color: Colors.white, size: 16,),
                                            AppText(text: packsQualif[index], fontWeight: FontWeight.bold, color: Colors.white,),
                                          ],
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                                RichText(
                                    textAlign: TextAlign.start,
                                    text: TextSpan(
                                        children: [
                                          TextSpan(
                                              text: '${packsPrices[index]} ',
                                              style: GoogleFonts.montserrat(
                                                fontSize: isMobile? 22: 28,
                                                fontWeight: FontWeight.bold,
                                                color: primaryColor
                                              )
                                          ),
                                          TextSpan(
                                              text: 'à partir de',
                                              style: GoogleFonts.montserrat(
                                                color: Colors.black54,
                                                fontSize: 18
                                              )
                                          ),
                                        ]
                                    )),
                                AppText(text: packsDescription[index],
                                  fontSize: 18, fontWeight: FontWeight.w500, alignement: TextAlign.start,
                                  color: Colors.black54, overflow: TextOverflow.clip,),

                                //AppText(text: "Ce pack inclut :", fontSize: 16, fontWeight: FontWeight.bold, alignement: TextAlign.start,
                                  //color: Colors.black54, overflow: TextOverflow.clip,),

                                ... List.generate(packsIncludes[index].length, (i)=> Row(
                                  children: [
                                    Icon(Icons.check, color: primaryColor, size: 16,),
                                    const SizedBox(width: 8,),
                                    Expanded(
                                      child: AppText(text: packsIncludes[index][i],
                                        fontSize: 18,
                                        alignement: TextAlign.start,
                                        overflow: TextOverflow.clip,
                                      ),
                                    ),
                                  ],
                                )),

                                if(isDesktop) Spacer(),

                                SizedBox(
                                  width: width,
                                  height: 50,
                                  child: ElevatedButton(
                                    style: ButtonStyle(
                                      // Fond qui change au survol
                                      backgroundColor: WidgetStateProperty.resolveWith<Color>(
                                            (states) => states.contains(WidgetState.hovered)
                                            ? primaryColor
                                            : Colors.white,
                                      ),
                                      // Couleur de texte/icone qui change au survol
                                      foregroundColor: WidgetStateProperty.resolveWith<Color>(
                                            (states) => states.contains(WidgetState.hovered)
                                            ? Colors.white
                                            : primaryColor,
                                      ),

                                      side: WidgetStateProperty.all(
                                        BorderSide(color: primaryColor),
                                      ),

                                      shape: WidgetStateProperty.all(
                                        RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(5), // <-- ton radius ici
                                        ),
                                      ),

                                    ),
                                    onPressed: () {},
                                    child: Text('Choisir ce pack', style: GoogleFonts.montserrat(),),
                                  ),
                                )

                              ],
                            ),
                          ),
                        ),
                      ),

                    )
                  ],
                ),
              ),

              const SizedBox(height: 40,),
              AppText(text: "Besoin d'un pack ? Nos experts sont là pour vous accompagner.", fontSize: 18,
              color: Colors.black45,),
              const SizedBox(height: 20,),

              Container(
                height: 50,
                child: HoverButton(text: 'Demander un devis sur mesure',
                    defaultColor: Colors.white, hoveringColor: primaryColor),
              ),

              const SizedBox(height: 30,),
            ],
          ),
        ],
      );
    });
  }
}
