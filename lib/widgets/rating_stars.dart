import 'package:flutter/material.dart';

import '../core/app_colors.dart';

/// Affiche des étoiles de notation (lecture seule ou interactive).
class RatingStars extends StatelessWidget {
  final double rating;
  final double size;
  final Color color;
  final ValueChanged<int>? onRatingChanged;

  const RatingStars({
    super.key,
    required this.rating,
    this.size = 20,
    this.color = primaryColor,
    this.onRatingChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (i) {
        final starIndex = i + 1;
        IconData icon;
        if (rating >= starIndex) {
          icon = Icons.star_rounded;
        } else if (rating >= starIndex - 0.5) {
          icon = Icons.star_half_rounded;
        } else {
          icon = Icons.star_outline_rounded;
        }

        final star = Icon(icon, size: size, color: color);

        if (onRatingChanged != null) {
          return GestureDetector(
            onTap: () => onRatingChanged!(starIndex),
            child: star,
          );
        }
        return star;
      }),
    );
  }
}
