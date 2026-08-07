import 'package:elmaleka_kitchen_project/data/models/product_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';
import '../../core/theme/colors.dart';

class FoodInfo extends StatelessWidget {
  const FoodInfo({
    super.key,
    required this.item,
    required this.isBlackBackground,
  });
  final bool isBlackBackground;
  final ProductModel item;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // SizedBox(
        //   height: 1.sh,
        // ),
        Text(
          item.name,
          style: TextStyle(
              color: isBlackBackground ? Colors.white : AppColors.textColor,
              fontSize: 4.2.sw),
        ),
        SizedBox(
          height: 1.sh,
        ),
        Row(
          children: [
            Text('(${item.ratingCount}تقييمات) ',
                // '${item.category!.name}',
                style: TextStyle(
                    color: AppColors.loginGreyColor, fontSize: 4.sw)),
            Text(
              ' ${item.ratingAverage.toStringAsFixed(1)}',
              style: TextStyle(color: AppColors.primaryColor, fontSize: 4.sw),
            ),
            Icon(
              Icons.star_rounded,
              color: AppColors.primaryColor,
              size: 6.sw,
            ),
          ],
        ),
      ],
    );
  }
}
