import 'dart:developer';
import 'package:elmaleka_kitchen_project/view/Widgets/try_again_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../../core/Utils/dummy_products.dart';
import '../../../core/theme/colors.dart';
import '../../../data/models/product_model.dart';
import '../../../view_model/Address/address_cubit.dart';
import '../../../view_model/Cart/cart_cubit.dart';
import '../../../view_model/Products/products_cubit.dart';
import '../../Widgets/dummy_search_container.dart';
import 'Home Widgets/food_category_list.dart';
import 'Home Widgets/home_category_slider.dart';
import 'Home Widgets/home_screen_header.dart';
import 'Home Widgets/new_food_section.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  bool loading = true;
  String? error;

  @override
  void initState() {
    super.initState();
      _loadHomeSections();
  }

  Future<void> _loadHomeSections() async {
   context.read<ProductsCubit>().getProductsForAllCategories();
    context.read<AddressCubit>().fetchAddresses();
    context.read<CartCubit>().fetchCart();
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, String>> itemsFoodType = [
      {
        'name': 'مشويات',
        'image': 'lib/assets/images/grilled.jpg',
      },
      {
        'name': 'سلطات',
        'image': 'lib/assets/images/salad.jpg',
      },
      {
        'name': ' عصائر',
        'image': 'lib/assets/images/juice.jpg',
      },
      {
        'name': 'حلويات',
        'image': 'lib/assets/images/dessert.jpg',
      },
      {
        'name': 'مكرونة',
        'image': 'lib/assets/images/pasta.jpg',
      },
      {
        'name': 'مأكولات بحرية',
        'image': 'lib/assets/images/seafood.jpg',
      },
      {
        'name': 'أخرى',
        'image': 'lib/assets/images/pizza.jpg',
      }
    ];

    if (error != null) {
      return TryAgainSection(
        message: error!,
        method: _loadHomeSections,
      );
    }
    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _loadHomeSections,
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsetsDirectional.symmetric(
                  vertical: 3.sh, horizontal: 4.sw),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  HomeScreenHeader(),
                  DummyTextFieldContainer(),
                  FoodCategoriesSlider(items: itemsFoodType),
                  BlocBuilder<ProductsCubit, ProductsState>(
                      builder: (context, state) {

                        if (state is ProductsInitial || state is ProductsLoading) {
                          return Skeletonizer(
                            enabled: true,
                            child: Column(
                              children: [
                                SizedBox(height: 2.sh),
                                FoodCategoryList(itemsFamous: getDummyProducts(3), isVertical: true),
                                SizedBox(height: 4.sh),
                                FoodCategoryList(itemsFamous: getDummyProducts(3), isVertical: false),
                                SizedBox(height: 4.sh),
                                TodayDishSection(itemsFamous: getDummyProducts(3)),
                              ],
                            ),
                          );
                        } else if (state is ProductsLoaded) {
                          return Column(
                            children: [
                              FoodCategoryList(
                                itemsFamous: state.productsSection1.take(3).toList(),
                                title: 'جاهز للاكل',
                                isVertical: true,
                                categoryId: 1,
                              ),
                              SizedBox(height: 4.sh),
                              FoodCategoryList(
                                itemsFamous: state.productsSection2.take(3).toList(),
                                title: 'جاهز للطبخ',
                                isVertical: false,
                                categoryId: 2,
                              ),
                              SizedBox(height: 4.sh),
                              TodayDishSection(
                                itemsFamous: state.productsSection3.take(3).toList(),
                              ),
                            ],
                          );
                        } else if (state is ProductsError) {
                          return TryAgainSection(
                            message: state.message,
                            method: () => _loadHomeSections(),
                          );
                        } else {

                          return SizedBox();
                        }
                      },

                      ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}