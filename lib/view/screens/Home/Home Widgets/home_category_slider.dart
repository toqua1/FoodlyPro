
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:responsive_builder/responsive_builder.dart';

import '../../../../core/Utils/is_tablet_service.dart';
import '../../../../core/theme/colors.dart';

class FoodCategoriesSlider extends StatelessWidget {
  const FoodCategoriesSlider({
    super.key,
    required this.items,
  });

  final List<Map<String, String>> items;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height:isTablet(context)? 25.sh:17.sh,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemBuilder: (BuildContext context, int index) {
          final category = items[index];
          return InkWell(
            onTap: ()=> context.push('/foodMenuItem',extra:
    {'title':category['name'],'isFoodType':true}),
            child: Column(
              children: [
                Container(
                  width:isTablet(context)? 20.sw:25.sw,
                  height:isTablet(context)? 20.sw:25.sw,
                  decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(4.sw),
                      image: DecorationImage(image: AssetImage
                        (category['image']!),fit: BoxFit.cover)
                  ),
                ),
                SizedBox(height: 1.sh,),
                Text(category['name']!,style: TextStyle(
                    fontSize: 4.sw,
                    color: AppColors.textColor
                ),)
              ],
            ),
          );
        },
        separatorBuilder: (BuildContext context, int index)
        =>SizedBox(width: 3.sw,),
        itemCount: items.length,
      ),
    );
  }
}
