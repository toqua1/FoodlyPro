import 'package:elmaleka_kitchen_project/core/Utils/build_error_image_category.dart';
import 'package:elmaleka_kitchen_project/core/Utils/is_tablet_service.dart';
import 'package:elmaleka_kitchen_project/core/theme/colors.dart';
import 'package:elmaleka_kitchen_project/view/Widgets/dummy_search_container.dart';
import 'package:elmaleka_kitchen_project/view/Widgets/try_again_section.dart';
import 'package:elmaleka_kitchen_project/view/screens/Home/Home%20Widgets/home_screen_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../../view_model/Products/products_cubit.dart';

class FoodMenuScreen extends StatelessWidget {
  const FoodMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // You can keep this for placeholder in loading state
    final dummyItems = [
      {
        'name': 'جاهز للأكل',
        'num': 'صنف 0',
        'image': 'lib/assets/images/pasta.jpg',
        'categoryId': 1,
      },
      {
        'name': 'جاهز للطبخ',
        'num': 'صنف 0',
        'image': 'lib/assets/images/burger.png',
        'categoryId': 2,
      },
      {
        'name': 'طبق اليوم',
        'num': 'صنف 0',
        'image': 'lib/assets/images/pizza.jpg',
        'categoryId': 3,
      },
    ];

    final cardWhiteHeight = isTablet(context) ? 11.sh : 11.sh;
    final heightBetweenCards = isTablet(context) ? 6.sh : 5.sh;
    final cardRedWidth = isTablet(context) ? 20.sw : 25.sw;
    final cardWhitePaddingLeft = isTablet(context) ? 20.sw : 15.sw;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsetsDirectional.symmetric(vertical: 3.sh),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4.sw),
                  child: Column(
                    children: const [
                      HomeScreenHeader(title: 'قائمة الطعام'),
                      DummyTextFieldContainer(),
                    ],
                  ),
                ),
                SizedBox(height: 2.sh),

                BlocBuilder<ProductsCubit, ProductsState>(
                  builder: (context, state) {
                    List<Map<String, dynamic>> items;
                    bool isLoading = false;

                    if (state is ProductsLoaded) {
                      items = [
                        {
                          'name': state.productsSection1.first.category.name,
                          'num': '${state.productsSection1.length} صنف',
                          'image': state.productsSection1.first.category.imageUrl,
                          'categoryId': 1,
                        },
                        {
                          'name': state.productsSection2.first.category.name,
                          'num': '${state.productsSection2.length} صنف',
                          'image': state.productsSection2.first.category.imageUrl,
                          'categoryId': 2,
                        },
                        {
                          'name': state.productsSection3.first.category.name,
                          'num': '${state.productsSection3.length} صنف',
                          'image': state.productsSection3.first.category.imageUrl,
                          'categoryId': 3,
                        },
                      ];
                      isLoading = false;
                    } else if (state is ProductsError) {
                      return TryAgainSection(
                        message: state.message,
                        method: () => context.read<ProductsCubit>().getProductsForAllCategories(),
                      );
                    } else {
                      // This handles ProductsInitial and ProductsLoading states
                      items = dummyItems;
                      isLoading = true;
                    }

                    // The UI for both loading and loaded states
                    return Skeletonizer(
                      enabled: isLoading,
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          final totalHeight = items.length * (cardWhiteHeight + heightBetweenCards) + heightBetweenCards;
                          return Stack(
                            children: [
                              Positioned(
                                right: 0,
                                top: 0,
                                child: Container(
                                  width: cardRedWidth,
                                  height: totalHeight,
                                  decoration: BoxDecoration(
                                    color: AppColors.secondaryColor,
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(38),
                                      bottomRight: Radius.circular(38),
                                    ),
                                  ),
                                ),
                              ),
                              Column(
                                children: List.generate(items.length, (index) {
                                  final item = items[index];
                                  return Padding(
                                    padding: EdgeInsets.only(
                                      left: cardWhitePaddingLeft,
                                      right: 4.sw + cardRedWidth * 0.3,
                                      top: index == 0 ? heightBetweenCards : 0,
                                      bottom: heightBetweenCards,
                                    ),
                                    child: SizedBox(
                                      height: cardWhiteHeight,
                                      child: InkWell(
                                        onTap: () => context.pushNamed(
                                          'foodMenuItem',
                                          extra: {
                                            'title': item['name'],
                                            'isFoodType': false,
                                            'categoryId': item['categoryId'],
                                          },
                                        ),
                                        child: Stack(
                                          clipBehavior: Clip.none,
                                          children: [
                                            Container(
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(30),
                                                  topRight: Radius.circular(10),
                                                  bottomLeft: Radius.circular(10),
                                                  bottomRight: Radius.circular(30),
                                                ),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.black12,
                                                    blurRadius: 6,
                                                    spreadRadius: 1,
                                                    offset: Offset(0, 7),
                                                  )
                                                ],
                                              ),
                                              child: Row(
                                                children: [
                                                  Padding(
                                                    padding: EdgeInsets.all(2.sw),
                                                    child: ClipRRect(
                                                      borderRadius: BorderRadius.circular(5.sw),
                                                      child: buildErrorImageCategory(
                                                        imageUrl: item['image'],
                                                        categoryId: item['categoryId'],
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(width: 2.sw),
                                                  Expanded(
                                                    child: Column(
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Text(
                                                          item['name']!,
                                                          style: TextStyle(
                                                            fontSize: 5.sw,
                                                            color: AppColors.textColor,
                                                            fontWeight: FontWeight.bold,
                                                          ),
                                                        ),
                                                        SizedBox(height: 0.5.sh),
                                                        Text(
                                                          item['num']!.toString(),
                                                          style: TextStyle(
                                                            fontSize: 3.5.sw,
                                                            color: AppColors.loginGreyColor,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Positioned(
                                              left: -4.sw,
                                              top: (cardWhiteHeight - 8.sw) / 2,
                                              child: CircleAvatar(
                                                radius: 4.sw,
                                                backgroundColor: AppColors.secondaryColor,
                                                child: Icon(
                                                  Icons.arrow_forward_ios_rounded,
                                                  size: 4.sw,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                }),
                              ),
                            ],
                          );
                        },
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}