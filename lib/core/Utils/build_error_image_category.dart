import 'package:elmaleka_kitchen_project/Services/api_services.dart';
import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';
import '../theme/colors.dart';

Widget buildErrorImageCategory({required String imageUrl,required int
categoryId}) {

  if (imageUrl == '') {
    // local placeholder when model has no image path
    if(categoryId==1){
      return Image.asset(
          'lib/assets/images/pasta.jpg',
          fit: BoxFit.cover,
          width: 18.sw,
          height: 18.sw
      );
    }else if(categoryId==2){
      return Image.asset(
          'lib/assets/images/burger.png',
          fit: BoxFit.cover,
          width: 18.sw,
          height: 18.sw
      );
    }else if(categoryId==3){
      return Image.asset(
          'lib/assets/images/pizza.jpg',
          fit: BoxFit.cover,
          width: 18.sw,
          height: 18.sw
      );
    }else {
      return Image.asset(
          'lib/assets/images/image_not_found.jpg',
          fit: BoxFit.cover,
          width: 18.sw,
          height: 18.sw
      );
    }
  }

  return Image.network('${ApiServices().baseUrl}$imageUrl',
    fit: BoxFit.cover,
      width:18.sw,
      height:18.sw,
    loadingBuilder: (ctx, child, loadingProgress) {
      if (loadingProgress == null) return child;
      return SizedBox(
        width:18.sw,
        height:18.sw,
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
        width:18.sw,
        height:18.sw,
      );
    },
  );
}
