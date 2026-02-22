import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppText extends StatelessWidget {
  final String text;
  final double? fontSize;
  final FontWeight? fontWeight;
  final TextAlign? alignement;
  final Color? color;
  final TextOverflow? overflow;
  const AppText({super.key, required this.text, this.fontSize, this.fontWeight, this.alignement,
    this.color, this.overflow});

  @override
  Widget build(BuildContext context) {
    return  Text(text,
      textAlign: alignement,
      overflow: overflow?? TextOverflow.ellipsis,
      style: GoogleFonts.montserrat(
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: color?? Colors.black
      ),
    );
  }
}
