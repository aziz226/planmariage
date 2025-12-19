import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:plan_mariage/widgets/app_text.dart';

class MyAlertDialog {
  // Warning Dialog
  static void warningDialog(
      BuildContext context, String title, String content, void Function()? onTap) {
    showCupertinoDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: Column(
            children: [
              const Icon(Icons.warning_rounded, color: Colors.orange, size: 50,),
              const SizedBox(width: 8),
              Text(title)
            ],
          ),
          content: Text(content),
          actions: <Widget>[
            CupertinoDialogAction(
              child: const Text('Annuler'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            CupertinoDialogAction(
              child: const Text('OK'),
              onPressed: () {
                if (onTap != null) onTap();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  static void webWarningDialog(
      BuildContext context, String title, String content, void Function()? onTap) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Row(
            children: [
              const Icon(Icons.warning_rounded, color: Colors.orange, size: 30),
              const SizedBox(width: 8),
              Expanded(child: Text(title)),
            ],
          ),
          content: Text(content),
          actions: <Widget>[
            TextButton(
              child: const Text('Annuler'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                if (onTap != null) onTap();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  // Success Dialog
  static void successDialog(
      BuildContext context, String title, String content, void Function()? onTap) {
    showCupertinoDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: Column(
            children: [
              const Icon(Icons.check_circle, color: Colors.green, size: 50,),
              const SizedBox(width: 8),
              Text(title)
            ],
          ),
          content: Text(content),
          actions: <Widget>[
            CupertinoDialogAction(
              child: const Text('OK'),
              onPressed: () {
                if (onTap != null) onTap();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  static void webSuccessDialog(
      BuildContext context, String title, String content, void Function()? onTap) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Column(
            children: [
              const Icon(Icons.check_circle, color: Colors.green, size: 50,),
              const SizedBox(width: 8),
              Text(title)
            ],
          ),
          content: Text(content),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                if (onTap != null) onTap();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  // Error Dialog
  static void errorDialog(
      BuildContext context, String title, String content, void Function()? onTap) {
    showCupertinoDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: Column(
            children: [
              const Icon(Icons.error, color: Colors.red, size: 50,),
              const SizedBox(width: 8),
              Text(title)
            ],
          ),
          content: Text(content),
          actions: <Widget>[
            CupertinoDialogAction(
              child: const Text('OK'),
              onPressed: () {
                if (onTap != null) onTap();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  static void webErrorDialog(
      BuildContext context, String title, String content, void Function()? onTap) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Column(
            children: [
              const Icon(Icons.error, color: Colors.red, size: 50,),
              const SizedBox(width: 8),
              Text(title)
            ],
          ),
          content: Text(content),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                if (onTap != null) onTap();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  // Progress Dialog
  static void progressDialog(
      BuildContext context, String message) {
    showCupertinoDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return CupertinoAlertDialog(
          title: Column(
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 60,
                    height: 60,
                    child: CircularProgressIndicator(
                      strokeWidth: 5.0,
                      valueColor: const AlwaysStoppedAnimation<Color>(Color.fromARGB(255, 216, 189, 154)),
                      backgroundColor: Colors.grey.shade200,
                    ),
                  ),
                  // Text inside the Progress Indicator
                ],
              ),
              const SizedBox(height: 20),
              // Accompanying Text
              AppText(text: message, color: Colors.black54, fontSize: 16,),
            ],
          ),
          //content: Text(content),
        );
      },
    );
  }

  static void webProgressDialog(
      BuildContext context,) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: Column(
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 60,
                    height: 60,
                    child: CircularProgressIndicator(
                      strokeWidth: 5.0,
                      valueColor: const AlwaysStoppedAnimation<Color>(Color.fromARGB(255, 216, 189, 154)),
                      backgroundColor: Colors.grey.shade200,
                    ),
                  ),
                  // Text inside the Progress Indicator
                ],
              ),
              const SizedBox(height: 20),
              // Accompanying Text
              const Text('Veuillez patienter...',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                ),
              ),
            ],
          ),
          //content: Text(content),
        );
      },
    );
  }

  static void showImageDetails(BuildContext context, String imageUrl) {

    showDialog(

      context: context,
      builder: (context) {
        return Stack(
          clipBehavior: Clip.none, // Permet de positionner le bouton en dehors du Dialog
          children: [
            Dialog(
              insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              backgroundColor: const Color(0xFFF7F5FA),
              child: StatefulBuilder(
                builder: (context, setState) {
                  return Container(
                    width: MediaQuery.of(context).size.width * 0.8,
                    height: MediaQuery.of(context).size.height * 0.9,
                    color: Colors.white,
                    child: Image.network(imageUrl, ),
                  );
                },
              ),
            ),

            // **Bouton jaune repositionné directement au-dessus du conteneur**
            Positioned(
              top: 180,
              right: 100,
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: const Icon(Icons.close, size: 30, color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }
  static void showImageMemo(BuildContext context, Uint8List imageUrl) {

    showDialog(

      context: context,
      builder: (context) {
        return Stack(
          clipBehavior: Clip.none, // Permet de positionner le bouton en dehors du Dialog
          children: [
            Dialog(
              insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              backgroundColor: const Color(0xFFF7F5FA),
              child: StatefulBuilder(
                builder: (context, setState) {
                  return Container(
                    width: MediaQuery.of(context).size.width * 0.8,
                    height: MediaQuery.of(context).size.height * 0.9,
                    color: Colors.white,
                    child: Image.memory(imageUrl, ),
                  );
                },
              ),
            ),

            // **Bouton jaune repositionné directement au-dessus du conteneur**
            Positioned(
              top: 180,
              right: 100,
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: const Icon(Icons.close, size: 30, color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

}
