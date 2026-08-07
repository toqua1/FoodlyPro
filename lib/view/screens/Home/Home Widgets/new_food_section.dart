import 'package:elmaleka_kitchen_project/core/Utils/build_product_image.dart';
import 'package:elmaleka_kitchen_project/data/models/product_model.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:responsive_builder/responsive_builder.dart';
import '../../../../core/theme/colors.dart';
import '../../../Widgets/section_and_title.dart';

class TodayDishSection extends StatelessWidget {
  const TodayDishSection({
    super.key,
    required this.itemsFamous,
  });

  final List<ProductModel> itemsFamous;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SectionAndTitle(title: 'طبق اليوم',method: ()=>context.push('/foodMenuItem',
            extra: {'title':'طبق اليوم' , 'isFoodType': false,'categoryId':3})),
        SizedBox(
          height: 1.sh,
        ),
        ListView.separated(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            scrollDirection: Axis.vertical,
            itemBuilder: (context, index) {
              final item = itemsFamous[index];
              return InkWell(
               onTap:()=> context.push('/productItem',extra: {
                 'product':item
               }),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(2.sw),
                      child:  buildProductImage(item: item,isTodayDish: true,
                          isVertical: false) ),
                    SizedBox(
                      width: 5.sh,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.name,
                          style: TextStyle(
                              color: AppColors.textColor,
                              fontSize: 5.sw),
                        ),
                        SizedBox(
                          height: 1.sh,
                        ),
                        // Text(
                        //     '${item.category!.name}',
                        //     style: TextStyle(
                        //         color: AppColors.loginGreyColor,
                        //         fontSize: 3.5.sw)),
                        Row(
                          children: [
                            Text(
                                '(${item.ratingCount}تقييمات) ',
                                style: TextStyle(
                                    color: AppColors.loginGreyColor,
                                    fontSize: 3.5.sw)),
                            Text(
                              item.ratingAverage.toStringAsFixed(1),
                              style: TextStyle(
                                  color: AppColors.secondaryColor,
                                  fontSize: 3.5.sw),
                            ),
                            Icon(
                              Icons.star_rounded,
                              color: AppColors.primaryColor,
                              size: 5.sw,
                            ),
                          ],
                        ),
                      ],
                    )
                  ],
                ),
              );
            },
            separatorBuilder: (_, __) => SizedBox(
              height: 3.sh,
            ),
            itemCount: itemsFamous.length)
      ],
    );
  }
}
