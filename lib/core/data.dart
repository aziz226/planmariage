import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

import 'models.dart';

const List<ServiceModel> services = [
  ServiceModel(
    title: "Décoration",
    description: "Transformez votre lieu en décor de rêve",
    icon: Icons.palette_outlined,
    count: 150,
    providerLabel: "prestataires",
  ),
  ServiceModel(
    title: "Habillement",
    description: "Robes, costumes et accessoires",
    icon: Ionicons.shirt_outline,
    count: 80,
    providerLabel: "boutiques",
  ),
  ServiceModel(
    title: "Véhicules",
    description: "Limousines, voitures, carrosses",
    icon: CupertinoIcons.car_detailed,
    count: 45,
    providerLabel: "locations",
  ),
  ServiceModel(
    title: "Lieux de réception",
    description: "Châteaux, salles, jardins privatisés",
    icon: CupertinoIcons.building_2_fill,
    count: 200,
    providerLabel: "lieux",
  ),
  ServiceModel(
    title: "Sonorisation",
    description: "DJ, orchestres, animations musicales",
    icon: CupertinoIcons.music_note_2,
    count: 120,
    providerLabel: "artistes",
  ),
  ServiceModel(
    title: "Photographie",
    description: "Immortalisez vos plus beaux moments",
    icon: CupertinoIcons.camera,
    count: 90,
    providerLabel: "photographes",
  ),
  ServiceModel(
    title: "Traiteurs",
    description: "Menus sur mesure et service premium",
    icon: Icons.restaurant,
    count: 110,
    providerLabel: "traiteurs",
  ),
  ServiceModel(
    title: "Fleuristes",
    description: "Bouquets, centres de table, arches florales",
    icon: Ionicons.rose_outline,
    count: 75,
    providerLabel: "fleuristes",
  ),
];

const List<PackModel> packs = [
  PackModel(
    title: "Pack Essentiel",
    qualifier: "Populaire",
    price: "950 000 FCFA",
    description: "Pour un mariage intime et authentique",
    includes: [
      "Lieu de réception (50 personnes)",
      "Décoration florale simple",
      "Photographe (4h)",
      "DJ ou playlist",
      "Menu 3 services",
    ],
  ),
  PackModel(
    title: "Pack Prestige",
    qualifier: "Recommandé",
    price: "1 500 000 FCFA",
    description: "L'équilibre parfait entre élégance et budget",
    includes: [
      "Lieu de prestige (100 personnes)",
      "Décoration personnalisée",
      "Photographe & vidéaste (8h)",
      "Orchestre ou DJ premium",
      "Menu gastronomique 4 services",
      "Coordination jour J",
    ],
  ),
  PackModel(
    title: "Pack Royal",
    qualifier: "Luxe",
    price: "5 000 000 FCFA",
    description: "Le mariage de vos rêves, sans compromis",
    includes: [
      "Château ou domaine d'exception (150+ personnes)",
      "Décoration haut de gamme sur mesure",
      "Photographe + vidéaste premium journée complète",
      "Orchestre live + DJ",
      "Menu signature par chef étoilé",
      "Wedding planner dédiée",
      "Limousine ou voiture de collection",
      "Suite nuptiale incluse",
    ],
  ),
];

const List<String> villes = [
  "Ouagadougou",
  "Bobo-Dioulasso",
  "Koudougou",
  "Banfora",
  "Ouahigouya",
  "Tenkodogo",
  "Dédougou",
  "Fada N'Gourma",
];

const List<String> supportLinks = [
  "A propos",
  "FAQ",
  "Conditions générales",
  "Politique de confidentialité",
  "Contact",
];

const List<String> menuItems = [
  'Accueil',
  "Services",
  "Prestataires",
  "Contact",
];
