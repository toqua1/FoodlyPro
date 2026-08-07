import 'package:elmaleka_kitchen_project/data/models/product_model.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:responsive_builder/responsive_builder.dart';
import '../../../../core/Utils/build_product_image.dart';
import '../../../../core/Utils/is_tablet_service.dart';
import '../../../Widgets/food_info.dart';
import '../../../Widgets/section_and_title.dart';

class FoodCategoryList extends StatelessWidget {
  const FoodCategoryList({
    super.key,
    required this.itemsFamous,
    this.title,
    required this.isVertical, this.categoryId,
  });
  final String? title;
  final int? categoryId;
  final List<ProductModel> itemsFamous;
  final bool isVertical;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (title != null)
          SectionAndTitle(
            title: title!,
            method: () => context.push('/foodMenuItem',
                extra: {'title': title, 'isFoodType': false, 'categoryId': categoryId}),
          ),
        SizedBox(height: 1.sh),

        // If !isVertical (horizontal list) use fixed height; otherwise make it flexible
        isVertical
            ? ListView.separated(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              scrollDirection: Axis.vertical,
              itemBuilder: _buildItem,
              separatorBuilder: (_,__) => SizedBox(height: 4.sh),
              itemCount: itemsFamous.length,
            )
            : SizedBox(
          height: isTablet(context) ? 42.sh : 30.sh,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemBuilder: _buildItem,
            separatorBuilder: (_,__) => SizedBox(width: 3.sw),
            itemCount: itemsFamous.length,
          ),
        ),
      ],
    );
  }

  Widget _buildItem(BuildContext context, int index) {
    final item = itemsFamous[index];
    return InkWell(
      onTap: () => context.push('/productItem', extra: {'product': item}),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(isVertical ? 0 : 2.sw),
            child: buildProductImage(item: item, isVertical: isVertical, isTodayDish: false),
          ),
          SizedBox(height: 1.sh),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.sw),
            child: FoodInfo(item: item, isBlackBackground: false),
          ),
        ],
      ),
    );
  }

// @override
  // Widget build(BuildContext context) {
  //   return Column(
  //     children: [
  //       title != null
  //           ? SectionAndTitle(
  //               title: title!,
  //               method: () => context.push('/foodMenuItem',
  //                   extra: {'title': title, 'isFoodType': false,'categoryId':
  //                   categoryId}),
  //             )
  //           : SizedBox(),
  //       SizedBox(
  //         height: 1.sh,
  //       ),
  //       SizedBox(
  //         height: !isVertical
  //             ? isTablet(context)
  //                 ? 40.sh
  //                 : 28.sh
  //             : null,
  //         child:
  //         ListView.separated(
  //             shrinkWrap: isVertical ? true : false,
  //             /*it sizes itself*/
  //             physics: isVertical
  //                 ? NeverScrollableScrollPhysics()
  //                 : null /*doesn’t try
  //              to scroll
  //              on its own*/
  //             ,
  //             scrollDirection: isVertical ? Axis.vertical : Axis.horizontal,
  //             itemBuilder: (context, index) {
  //               final item = itemsFamous[index];
  //               return InkWell(
  //                 onTap: () =>
  //                     context.push('/productItem', extra: {'product': item}),
  //                 child: Column(
  //                   crossAxisAlignment: CrossAxisAlignment.start,
  //                   children: [
  //                     ClipRRect(
  //                         borderRadius:
  //                             BorderRadius.circular(isVertical ? 0 : 2.sw),
  //                         child: buildProductImage(
  //                             item: item,
  //                             isVertical: isVertical,
  //                             isTodayDish: false)),
  //                     SizedBox(
  //                       height: 1.sh,
  //                     ),
  //                     Padding(
  //                       padding: EdgeInsets.symmetric(horizontal: 4.sw),
  //                       child: FoodInfo(
  //                         item: item,
  //                         isBlackBackground: false,
  //                       ),
  //                     )
  //                   ],
  //                 ),
  //               );
  //             },
  //             separatorBuilder: (_, __) => isVertical
  //                 ? SizedBox(
  //                     height: 4.sh,
  //                   )
  //                 : SizedBox(
  //                     width: 3.sw,
  //                   ),
  //             itemCount: itemsFamous.length),
  //       )
  //     ],
  //   );
  // }
}
