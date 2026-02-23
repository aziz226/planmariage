import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../core/app_colors.dart';

class HoverButton extends StatelessWidget {
  final String text;
  final Color defaultColor, hoveringColor;
  final VoidCallback? onPressed;
  const HoverButton({super.key, required this.text, required this.defaultColor, required this.hoveringColor, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        // Fond qui change au survol
        backgroundColor: WidgetStateProperty.resolveWith<Color>(
              (states) => states.contains(WidgetState.hovered)
              ? hoveringColor
              : defaultColor,
        ),
        // Couleur de texte/icone qui change au survol
        foregroundColor: WidgetStateProperty.resolveWith<Color>(
              (states) => states.contains(WidgetState.hovered)
              ? defaultColor
              : hoveringColor,
        ),

        side: WidgetStateProperty.all(
          BorderSide(color: hoveringColor),
        ),

        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5), // <-- ton radius ici
          ),
        ),

      ),
      onPressed: onPressed ?? () {},
      child: Text(text, style: GoogleFonts.montserrat(),),
    );
  }
}
