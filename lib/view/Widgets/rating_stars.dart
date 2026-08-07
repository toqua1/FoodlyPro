import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';
import '../../core/theme/colors.dart';

class RatingStars extends StatelessWidget {
  final double rating;
  final double size;
  final ValueChanged<double>? onRatingUpdate;

  const RatingStars({
    super.key,
    required this.rating,
    this.size = 4.5,
    this.onRatingUpdate, // Make it optional
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(5, (index) {
        final starIndex = index + 1;
        IconData icon;
        Color color = AppColors.primaryColor;

        if (rating >= starIndex) {
          icon = Icons.star_rounded;
        } else if (rating > (starIndex - 1) && rating < starIndex) {
          icon = Icons.star_half_rounded;
        } else {
          icon = Icons.star_border_rounded;
          color = AppColors.primaryColor.withOpacity(0.5);
        }

        return InkWell(
          // Trigger the callback when a star is tapped
          onTap: onRatingUpdate == null
              ? null
              : () => onRatingUpdate!(starIndex.toDouble()),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 0.8.sw),
            child: Icon(icon, color: color, size: size),
          ),
        );
      }),
    );
  }
}
// import 'package:flutter/material.dart';
// import 'package:responsive_builder/responsive_builder.dart';
// import '../../core/theme/colors.dart';
//
// class RatingStars extends StatelessWidget {
//   final double rating;
//   final double size;
//
//   const RatingStars({super.key, required this.rating, this.size = 4.5});
//
//   @override
//   Widget build(BuildContext context) {
//     final stars = <Widget>[];
//     // we will iterate 5 stars and decide full/half/empty
//     for (var i = 0; i < 5; i++) {
//       final starIndex = i + 1;
//       if (rating >= starIndex) {
//         // full star
//         stars.add(Icon(Icons.star, color: AppColors.primaryColor, size: size));
//       } else if (rating > (starIndex - 1) && rating < starIndex) {
//         // half star (if >= .25 approx treat as half)
//         final fraction = rating - (starIndex - 1);
//         if (fraction >= 0.75) {
//           stars.add(Icon(Icons.star, color: AppColors.primaryColor, size: size));
//         } else if (fraction >= 0.25) {
//           stars.add(Icon(Icons.star_half, color: AppColors.primaryColor, size: size));
//         } else {
//           stars.add(Icon(Icons.star_border, color: AppColors.primaryColor.withOpacity(0.5), size: size));
//         }
//       } else {
//         // empty
//         stars.add(Icon(Icons.star_border, color: AppColors.primaryColor.withOpacity(0.5), size: size));
//       }
//       if (i != 4) stars.add(SizedBox(width: 0.8.sw));
//     }
//
//     return Row(children: stars);
//   }
// }
