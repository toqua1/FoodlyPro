import 'package:elmaleka_kitchen_project/core/Utils/build_product_image.dart';
import 'package:elmaleka_kitchen_project/data/models/product_model.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:responsive_builder/responsive_builder.dart';
import '../../../../core/theme/colors.dart';
import '../../../Widgets/food_info.dart';

class FoodMenuItemList extends StatelessWidget {
  const FoodMenuItemList({
    super.key,
    required this.itemsFamous,
  });
  final List<ProductModel> itemsFamous;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: null,
          child: ListView.separated(
              shrinkWrap: true,
              /*it sizes itself*/
              physics: NeverScrollableScrollPhysics(),
              scrollDirection: Axis.vertical,
              itemBuilder: (context, index) {
                final item = itemsFamous[index];
                return InkWell(
                 onTap: ()=> context.push('/productItem',extra: {
                   'product':item
                 }),
                  child: Stack(
                    children: [
                      ClipRRect(
                        child: buildProductImage(item: item, isVertical: true,
                            isTodayDish: false),
                      ),
                      Positioned(
                        bottom:0,
                        right:0,
                        left:0,
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal:4.sw,
                              vertical: 3.sh),
                          color: Colors.black38
                          ,child: FoodInfo(item: item,isBlackBackground: true,),
                        ),
                      ),
                    ],
                  ),
                );
              },
              separatorBuilder: (_, __) => SizedBox(
                    height: 1.sh,
                  ),
              itemCount: itemsFamous.length),
        )
      ],
    );
  }
}
