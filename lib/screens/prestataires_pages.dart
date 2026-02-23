import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:iconly/iconly.dart';

import '../widgets/header.dart';

// ─── Data Models ──────────────────────────────────────────────────────────────

class Prestataire {
  final int id;
  final String name;
  final String category;
  final String location;
  final double rating;
  final int reviews;
  final String price;
  final String image;
  final bool verified;
  final String description;

  const Prestataire({
    required this.id,
    required this.name,
    required this.category,
    required this.location,
    required this.rating,
    required this.reviews,
    required this.price,
    required this.image,
    required this.verified,
    required this.description,
  });
}

// ─── Static Data ──────────────────────────────────────────────────────────────

const List<Prestataire> prestatairesData = [
  Prestataire(
    id: 1,
    name: "Château de Malmaison",
    category: "Lieu de réception",
    location: "Paris",
    rating: 4.9,
    reviews: 156,
    price: "À partir de 2500€",
    image: "https://images.unsplash.com/photo-1519167758481-83f29e8e7317?w=800&h=600&fit=crop",
    verified: true,
    description: "Château historique avec jardins à la française, capacité 150 personnes",
  ),
  Prestataire(
    id: 2,
    name: "Studio Photo Lumière",
    category: "Photographie",
    location: "Lyon",
    rating: 4.8,
    reviews: 203,
    price: "À partir de 1200€",
    image: "https://images.unsplash.com/photo-1606800052052-a08af7148866?w=800&h=600&fit=crop",
    verified: true,
    description: "Photographes professionnels spécialisés dans les mariages",
  ),
  Prestataire(
    id: 3,
    name: "Élégance Florale",
    category: "Décoration",
    location: "Marseille",
    rating: 4.7,
    reviews: 89,
    price: "À partir de 800€",
    image: "https://images.unsplash.com/photo-1519225421980-715cb0215aed?w=800&h=600&fit=crop",
    verified: true,
    description: "Créations florales sur mesure pour tous vos espaces",
  ),
  Prestataire(
    id: 4,
    name: "Saveurs & Délices",
    category: "Traiteur",
    location: "Bordeaux",
    rating: 4.9,
    reviews: 178,
    price: "À partir de 65€/pers",
    image: "https://images.unsplash.com/photo-1555244162-803834f70033?w=800&h=600&fit=crop",
    verified: true,
    description: "Cuisine gastronomique française avec chef étoilé",
  ),
  Prestataire(
    id: 5,
    name: "DJ Sensation",
    category: "Sonorisation",
    location: "Nice",
    rating: 4.6,
    reviews: 124,
    price: "À partir de 600€",
    image: "https://images.unsplash.com/photo-1470229722913-7c0e2dbbafd3?w=800&h=600&fit=crop",
    verified: true,
    description: "Animation musicale et sonorisation professionnelle",
  ),
  Prestataire(
    id: 6,
    name: "Maison Blanc",
    category: "Habillement",
    location: "Paris",
    rating: 4.8,
    reviews: 267,
    price: "À partir de 1500€",
    image: "https://images.unsplash.com/photo-1594552072238-b8befca88d3b?w=800&h=600&fit=crop",
    verified: true,
    description: "Robes de mariée et costumes sur mesure",
  ),
  Prestataire(
    id: 7,
    name: "Prestige Limousine",
    category: "Véhicules",
    location: "Lyon",
    rating: 4.7,
    reviews: 91,
    price: "À partir de 400€",
    image: "https://images.unsplash.com/photo-1449965408869-eaa3f722e40d?w=800&h=600&fit=crop",
    verified: true,
    description: "Location de voitures de luxe et véhicules anciens",
  ),
  Prestataire(
    id: 8,
    name: "Sweet Dreams Cakes",
    category: "Pâtisserie",
    location: "Toulouse",
    rating: 4.9,
    reviews: 142,
    price: "À partir de 350€",
    image: "https://images.unsplash.com/photo-1535254973040-607b474cb50d?w=800&h=600&fit=crop",
    verified: true,
    description: "Pièces montées et wedding cakes exceptionnels",
  ),
  Prestataire(
    id: 9,
    name: "Domaine des Roses",
    category: "Lieu de réception",
    location: "Provence",
    rating: 4.8,
    reviews: 134,
    price: "À partir de 3000€",
    image: "https://images.unsplash.com/photo-1464366400600-7168b8af9bc3?w=800&h=600&fit=crop",
    verified: true,
    description: "Domaine viticole avec vue panoramique",
  ),
];

const List<String> categories = [
  "Tous",
  "Lieu de réception",
  "Photographie",
  "Décoration",
  "Traiteur",
  "Sonorisation",
  "Habillement",
  "Véhicules",
  "Pâtisserie",
];

const List<String> locations = [
  "Tous",
  "Paris",
  "Lyon",
  "Marseille",
  "Bordeaux",
  "Nice",
  "Toulouse",
  "Provence",
];

// ─── Color Scheme (adapt to your theme) ───────────────────────────────────────

class AppColors {
  static const Color primary = Color(0xFFD4A574); // Wedding gold/rose
  static const Color secondary = Color(0xFFF5C518); // Star yellow
  static const Color background = Color(0xFFFAF8F5);
  static const Color cardBg = Colors.white;
  static const Color textPrimary = Color(0xFF2D2D2D);
  static const Color textMuted = Color(0xFF8E8E8E);
  static const Color green = Color(0xFF22C55E);
}

// ─── Main Page ────────────────────────────────────────────────────────────────

class PrestatairesPages extends StatefulWidget {
  const PrestatairesPages({super.key});

  @override
  State<PrestatairesPages> createState() => _PrestatairesPagesState();
}

class _PrestatairesPagesState extends State<PrestatairesPages> {
  bool isMobile = false, isTablet = false, isDesktop = false;
  double width = 0, height = 0;

  List<String> menuItems = [
    'Accueil',
    "Services",
    "Prestataires",
    "Contact",
  ];

  int selectedIndex = 2;

  // Filters state
  String searchTerm = "";
  String selectedCategory = "Tous";
  String selectedLocation = "Tous";
  String sortBy = "rating";

  final TextEditingController _searchController = TextEditingController();

  List<Prestataire> get filteredPrestataires {
    var filtered = prestatairesData.where((p) {
      final matchesSearch = p.name.toLowerCase().contains(searchTerm.toLowerCase()) ||
          p.description.toLowerCase().contains(searchTerm.toLowerCase());
      final matchesCategory = selectedCategory == "Tous" || p.category == selectedCategory;
      final matchesLocation = selectedLocation == "Tous" || p.location == selectedLocation;
      return matchesSearch && matchesCategory && matchesLocation;
    }).toList();

    // Sort
    switch (sortBy) {
      case "rating":
        filtered.sort((a, b) => b.rating.compareTo(a.rating));
        break;
      case "reviews":
        filtered.sort((a, b) => b.reviews.compareTo(a.reviews));
        break;
    }

    return filtered;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;

    return ResponsiveBuilder(builder: (context, screenSize) {
      isMobile = screenSize.isMobile;
      isTablet = screenSize.isTablet;
      isDesktop = screenSize.isDesktop;

      return Scaffold(
        backgroundColor: AppColors.background,
        body: Column(
          children: [
            const SizedBox(height: 10),
            Header(index: 2), // ← Uncomment with your Header widget

            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // Hero Section
                    _buildHeroSection(),

                    // Stats Section
                    _buildStatsSection(),

                    const SizedBox(height: 24),

                    // Search & Filters
                    _buildFiltersSection(),

                    // Results count + sort
                    _buildResultsHeader(),

                    // Prestataires Grid
                    _buildPrestatairesGrid(),

                    // Empty state
                    if (filteredPrestataires.isEmpty) _buildEmptyState(),

                    const SizedBox(height: 40),

                    // CTA Section
                    _buildCtaSection(),

                    const SizedBox(height: 24),

                    // if (!isMobile) FooterView(), // ← Uncomment with your Footer
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
            setState(() {
              selectedIndex = index;
            });
          },
          selectedItemColor: AppColors.primary,
          unselectedItemColor: AppColors.textMuted,
          type: BottomNavigationBarType.fixed,
          items: List.generate(
            menuItems.length,
                (index) => BottomNavigationBarItem(
              icon: Icon(_getMenuIcon(index)),
              label: menuItems[index],
            ),
          ),
        )
            : null,
      );
    });
  }

  IconData _getMenuIcon(int index) {
    switch (index) {
      case 0:
        return IconlyLight.home;
      case 1:
        return IconlyLight.category;
      case 2:
        return IconlyLight.user;
      case 3:
        return IconlyLight.call;
      default:
        return IconlyLight.home;
    }
  }

  // ─── Hero Section ─────────────────────────────────────────────────────────

  Widget _buildHeroSection() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 20 : 60,
        vertical: isMobile ? 32 : 56,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primary.withOpacity(0.08),
            AppColors.primary.withOpacity(0.02),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Column(
        children: [
          Text(
            "Nos prestataires",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: isMobile ? 28 : 42,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          Text(
            "de confiance",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: isMobile ? 28 : 42,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            "Des professionnels sélectionnés avec soin pour faire de votre mariage un moment inoubliable",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: isMobile ? 14 : 18,
              color: AppColors.textMuted,
            ),
          ),
        ],
      ),
    );
  }

  // ─── Stats Section ────────────────────────────────────────────────────────

  Widget _buildStatsSection() {
    final stats = [
      {"value": "500+", "label": "Prestataires"},
      {"value": "4.8/5", "label": "Note moyenne"},
      {"value": "98%", "label": "Satisfaction"},
      {"value": "15000+", "label": "Mariages réalisés"},
    ];

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: isMobile ? 16 : 60),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: isMobile ? 2 : 4,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: isMobile ? 1.6 : 2.0,
        ),
        itemCount: stats.length,
        itemBuilder: (context, index) {
          return Card(
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    stats[index]["value"]!,
                    style: TextStyle(
                      fontSize: isMobile ? 22 : 28,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    stats[index]["label"]!,
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.textMuted,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // ─── Filters Section ──────────────────────────────────────────────────────

  Widget _buildFiltersSection() {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 16 : 60,
        vertical: 16,
      ),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFFE5E5E5))),
      ),
      child: isMobile ? _buildMobileFilters() : _buildDesktopFilters(),
    );
  }

  Widget _buildDesktopFilters() {
    return Row(
      children: [
        // Search
        Expanded(
          child: TextField(
            controller: _searchController,
            onChanged: (value) => setState(() => searchTerm = value),
            decoration: InputDecoration(
              hintText: "Rechercher un prestataire...",
              prefixIcon: const Icon(Icons.search, color: AppColors.textMuted),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Color(0xFFE5E5E5)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Color(0xFFE5E5E5)),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            ),
          ),
        ),
        const SizedBox(width: 12),

        // Category dropdown
        _buildDropdown(
          value: selectedCategory,
          items: categories,
          width: 200,
          onChanged: (val) => setState(() => selectedCategory = val!),
        ),
        const SizedBox(width: 12),

        // Location dropdown
        _buildDropdown(
          value: selectedLocation,
          items: locations,
          width: 200,
          onChanged: (val) => setState(() => selectedLocation = val!),
        ),
      ],
    );
  }

  Widget _buildMobileFilters() {
    return Column(
      children: [
        // Search
        TextField(
          controller: _searchController,
          onChanged: (value) => setState(() => searchTerm = value),
          decoration: InputDecoration(
            hintText: "Rechercher un prestataire...",
            prefixIcon: const Icon(Icons.search, color: AppColors.textMuted),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Color(0xFFE5E5E5)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Color(0xFFE5E5E5)),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildDropdown(
                value: selectedCategory,
                items: categories,
                onChanged: (val) => setState(() => selectedCategory = val!),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildDropdown(
                value: selectedLocation,
                items: locations,
                onChanged: (val) => setState(() => selectedLocation = val!),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDropdown({
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
    double? width,
  }) {
    return SizedBox(
      width: width,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: const Color(0xFFE5E5E5)),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: value,
            isExpanded: true,
            icon: const Icon(Icons.keyboard_arrow_down, color: AppColors.textMuted),
            items: items
                .map((item) => DropdownMenuItem(
              value: item,
              child: Text(
                item == "Tous" && items == locations ? "Toutes les villes" : item,
                style: const TextStyle(fontSize: 14),
              ),
            ))
                .toList(),
            onChanged: onChanged,
          ),
        ),
      ),
    );
  }

  // ─── Results Header ───────────────────────────────────────────────────────

  Widget _buildResultsHeader() {
    final count = filteredPrestataires.length;
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 16 : 60,
        vertical: 16,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "$count prestataire${count > 1 ? 's' : ''} trouvé${count > 1 ? 's' : ''}",
            style: const TextStyle(color: AppColors.textMuted, fontSize: 14),
          ),
          SizedBox(
            width: 180,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xFFE5E5E5)),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: sortBy,
                  isExpanded: true,
                  icon: const Icon(Icons.keyboard_arrow_down, color: AppColors.textMuted),
                  items: const [
                    DropdownMenuItem(value: "rating", child: Text("Meilleures notes", style: TextStyle(fontSize: 13))),
                    DropdownMenuItem(value: "reviews", child: Text("Plus d'avis", style: TextStyle(fontSize: 13))),
                  ],
                  onChanged: (val) => setState(() => sortBy = val!),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─── Prestataires Grid ────────────────────────────────────────────────────

  Widget _buildPrestatairesGrid() {
    final list = filteredPrestataires;
    if (list.isEmpty) return const SizedBox.shrink();

    int crossAxisCount = isMobile ? 1 : (isTablet ? 2 : 3);
    double childAspectRatio = isMobile ? 0.82 : 0.72;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: isMobile ? 16 : 60),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: childAspectRatio,
        ),
        itemCount: list.length,
        itemBuilder: (context, index) {
          return _PrestataireCard(
            prestataire: list[index],
            isMobile: isMobile,
            onTap: () {
              // Navigator.push(context, MaterialPageRoute(
              //   builder: (_) => ServiceDetailPage(id: list[index].id),
              // ));
            },
          );
        },
      ),
    );
  }

  // ─── Empty State ──────────────────────────────────────────────────────────

  Widget _buildEmptyState() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 60),
      child: Column(
        children: [
          const Icon(Icons.search_off, size: 64, color: AppColors.textMuted),
          const SizedBox(height: 16),
          const Text(
            "Aucun prestataire trouvé pour ces critères",
            style: TextStyle(fontSize: 18, color: AppColors.textMuted),
          ),
          const SizedBox(height: 16),
          OutlinedButton(
            onPressed: () {
              setState(() {
                searchTerm = "";
                selectedCategory = "Tous";
                selectedLocation = "Tous";
                _searchController.clear();
              });
            },
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: AppColors.primary),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            child: const Text(
              "Réinitialiser les filtres",
              style: TextStyle(color: AppColors.primary),
            ),
          ),
        ],
      ),
    );
  }

  // ─── CTA Section ──────────────────────────────────────────────────────────

  Widget _buildCtaSection() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 20 : 60,
        vertical: isMobile ? 32 : 56,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primary.withOpacity(0.08),
            AppColors.primary.withOpacity(0.02),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Column(
        children: [
          Text(
            "Vous êtes prestataire ?",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: isMobile ? 22 : 30,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            "Rejoignez notre plateforme et développez votre activité auprès de milliers de futurs mariés",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: isMobile ? 14 : 18,
              color: AppColors.textMuted,
            ),
          ),
          const SizedBox(height: 24),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            alignment: WrapAlignment.center,
            children: [
              ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.mail_outline, size: 20),
                label: const Text("Devenir partenaire"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
              OutlinedButton.icon(
                onPressed: () {
                  // Navigator.pushNamed(context, '/contact');
                },
                icon: const Icon(Icons.phone_outlined, size: 20),
                label: const Text("Nous contacter"),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.primary,
                  side: const BorderSide(color: AppColors.primary),
                  padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─── Prestataire Card Widget ──────────────────────────────────────────────────

class _PrestataireCard extends StatelessWidget {
  final Prestataire prestataire;
  final bool isMobile;
  final VoidCallback? onTap;

  const _PrestataireCard({
    required this.prestataire,
    required this.isMobile,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            Stack(
              children: [
                AspectRatio(
                  aspectRatio: 16 / 9,
                  child: Image.network(
                    prestataire.image,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      color: Colors.grey[200],
                      child: const Center(child: Icon(Icons.image, size: 40, color: Colors.grey)),
                    ),
                  ),
                ),
                if (prestataire.verified)
                  Positioned(
                    top: 10,
                    right: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.green,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.check_circle, size: 14, color: Colors.white),
                          SizedBox(width: 4),
                          Text(
                            "Vérifié",
                            style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),

            // Content
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Category + Rating
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            prestataire.category,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            const Icon(Icons.star, size: 16, color: AppColors.secondary),
                            const SizedBox(width: 3),
                            Text(
                              "${prestataire.rating}",
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                            ),
                            const SizedBox(width: 3),
                            Text(
                              "(${prestataire.reviews})",
                              style: const TextStyle(color: AppColors.textMuted, fontSize: 12),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    // Name
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            prestataire.name,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (prestataire.verified) ...[
                          const SizedBox(width: 6),
                          const Icon(Icons.workspace_premium, size: 18, color: AppColors.primary),
                        ],
                      ],
                    ),

                    // Location
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.location_on_outlined, size: 15, color: AppColors.textMuted),
                        const SizedBox(width: 3),
                        Text(
                          prestataire.location,
                          style: const TextStyle(fontSize: 13, color: AppColors.textMuted),
                        ),
                      ],
                    ),

                    const SizedBox(height: 8),

                    // Description
                    Text(
                      prestataire.description,
                      style: const TextStyle(fontSize: 12, color: AppColors.textMuted),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),

                    const Spacer(),

                    // Price + Actions
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Text(
                            prestataire.price,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                              fontSize: 14,
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            _iconButton(Icons.phone_outlined, () {}),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                              decoration: BoxDecoration(
                                color: AppColors.primary,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Text(
                                "Voir détails",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _iconButton(IconData icon, VoidCallback onPressed) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xFFE5E5E5)),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, size: 16, color: AppColors.textMuted),
      ),
    );
  }
}