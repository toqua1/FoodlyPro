import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:responsive_builder/responsive_builder.dart';

import '../../core/theme/colors.dart';

class EmptyProductsSection extends StatelessWidget {
  const EmptyProductsSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        // mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
         Icon(Icons.no_food_rounded,size: 20.sw,color: AppColors.secondaryColor,),
          Text(
            'لا يوجد منتجات حاليا',
            style: TextStyle(fontSize: 5.sw),
          )
        ],
      ),
    );
  }
}
