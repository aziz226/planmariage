import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:responsive_builder/responsive_builder.dart';

import '../core/app_colors.dart';
import '../core/routes.dart';
import '../providers/cart_provider.dart';
import '../widgets/cart_item_widget.dart';
import '../widgets/header.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();

    return ResponsiveBuilder(builder: (context, screenSize) {
      final isMobile = screenSize.isMobile;
      final padding = isMobile ? 16.0 : 24.0;

      return Scaffold(
        body: Column(
          children: [
            const Header(index: -1),
            Expanded(
              child: cart.isEmpty
                  ? Center(
                      child: Padding(
                        padding: EdgeInsets.all(padding),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.shopping_cart_outlined, size: isMobile ? 60 : 80, color: Colors.grey[300]),
                            const SizedBox(height: 16),
                            Text(
                              'Votre panier est vide',
                              style: GoogleFonts.montserrat(fontSize: isMobile ? 18 : 20, color: Colors.grey[600]),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Parcourez nos prestataires et ajoutez-les à votre panier',
                              style: GoogleFonts.montserrat(color: Colors.grey[500], fontSize: isMobile ? 13 : 14),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 24),
                            ElevatedButton(
                              onPressed: () => Navigator.pushNamed(context, prestatairesRoute),
                              style: ElevatedButton.styleFrom(backgroundColor: primaryColor, foregroundColor: Colors.white),
                              child: const Text('Voir les prestataires'),
                            ),
                          ],
                        ),
                      ),
                    )
                  : SingleChildScrollView(
                      padding: EdgeInsets.all(padding),
                      child: Center(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 700),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Mon panier (${cart.itemCount})',
                                style: GoogleFonts.montserrat(fontSize: isMobile ? 20 : 24, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 20),

                              // Liste articles
                              ...List.generate(
                                cart.items.length,
                                (i) => CartItemWidget(
                                  item: cart.items[i],
                                  onRemove: () => cart.removeAt(i),
                                ),
                              ),

                              const Divider(height: 32),

                              // Total
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Total', style: GoogleFonts.montserrat(fontSize: isMobile ? 18 : 20, fontWeight: FontWeight.bold)),
                                  Text(
                                    cart.totalFormatted,
                                    style: GoogleFonts.montserrat(fontSize: isMobile ? 18 : 22, fontWeight: FontWeight.bold, color: primaryColor),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 24),

                              // Boutons — Column sur mobile, Row sur desktop
                              if (isMobile)
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: [
                                    SizedBox(
                                      height: 48,
                                      child: ElevatedButton(
                                        onPressed: () => Navigator.pushNamed(context, checkoutRoute),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: primaryColor,
                                          foregroundColor: Colors.white,
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                        ),
                                        child: Text(
                                          'Passer au paiement',
                                          style: GoogleFonts.montserrat(fontWeight: FontWeight.w600, fontSize: 16),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    OutlinedButton(
                                      onPressed: () => cart.clear(),
                                      child: const Text('Vider le panier'),
                                    ),
                                  ],
                                )
                              else
                                Row(
                                  children: [
                                    Expanded(
                                      child: OutlinedButton(
                                        onPressed: () => cart.clear(),
                                        child: const Text('Vider le panier'),
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      flex: 2,
                                      child: SizedBox(
                                        height: 48,
                                        child: ElevatedButton(
                                          onPressed: () => Navigator.pushNamed(context, checkoutRoute),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: primaryColor,
                                            foregroundColor: Colors.white,
                                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                          ),
                                          child: Text(
                                            'Passer au paiement',
                                            style: GoogleFonts.montserrat(fontWeight: FontWeight.w600, fontSize: 16),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
            ),
          ],
        ),
      );
    });
  }
}
