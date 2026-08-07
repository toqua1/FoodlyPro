import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';
import '../../data/models/product_model.dart';
import '../theme/colors.dart';

Widget buildProductImage({required ProductModel item, required bool isVertical, required bool
isTodayDish}) {
  final width =isTodayDish?25.sw: (isVertical != null && isVertical == true ) ?
  double.infinity
      : 70.sw ;
  final height =isTodayDish?25.sw:  (isVertical != null && isVertical == true
  ) ? 28.sh : 19.sh;

  final imageUrl = item.imageUrl;

  if (imageUrl == null) {
    // local placeholder when model has no image path
    return Image.asset(
      'lib/assets/images/image_not_found.jpg',
      fit: BoxFit.cover,
      width:width,
      height:height,
    );
  }

  return Image.network(
    imageUrl,
    fit: BoxFit.cover,
    width: width,
    height: height,
    loadingBuilder: (ctx, child, loadingProgress) {
      if (loadingProgress == null) return child;
      return SizedBox(
        width: width,
        height: height,
        child: Center(
          child: CircularProgressIndicator(
            value: loadingProgress.expectedTotalBytes != null
                ? loadingProgress.cumulativeBytesLoaded / (loadingProgress.expectedTotalBytes ?? 1)
                : null,
            color: AppColors.secondaryColor,
          ),
        ),
      );
    },
    errorBuilder: (ctx, error, stackTrace) {
      return Image.asset(
        'lib/assets/images/image_not_found.jpg',
        fit: BoxFit.cover,
        width: width,
        height: height,
      );
    },
  );
}
