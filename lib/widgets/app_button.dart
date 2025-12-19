import 'package:flutter/material.dart';

import '../core/app_colors.dart';
import 'app_text.dart';

class AppButton extends StatelessWidget {
  final String text;
  final Function() onPressed;
  final Color? btnColor, textColor;
  const AppButton({super.key, required this.text, required this.onPressed, this.btnColor, this.textColor});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
          backgroundColor: btnColor ?? primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 15)
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        child: AppText(text: text, fontWeight: FontWeight.w500, fontSize: 16,
          color: textColor?? Colors.white,),
      ),
    );
  }
}
