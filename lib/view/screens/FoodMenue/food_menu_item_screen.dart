import 'package:elmaleka_kitchen_project/Services/food_type_service.dart';
import 'package:elmaleka_kitchen_project/core/theme/colors.dart';
import 'package:elmaleka_kitchen_project/data/models/product_model.dart';
import 'package:elmaleka_kitchen_project/view/Widgets/snack_bar.dart';
import 'package:elmaleka_kitchen_project/view/screens/FoodMenue/Food%20Menue%20Widgets/food_menu_item_list.dart';
import 'package:elmaleka_kitchen_project/view_model/Products/products_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../../core/Utils/dummy_products.dart';
import '../../../view_model/Food Menu List/food_menu_list_cubit.dart';
import '../../Widgets/dummy_search_container.dart';
import '../../Widgets/empty_products_section.dart';
import '../Home/Home Widgets/home_screen_header.dart';

class FoodMenuItemScreen extends StatefulWidget {
  const FoodMenuItemScreen(
      {super.key,
      required this.title,
      required this.isFoodType,
      this.categoryId});
  final String title;
  final bool isFoodType;
  final int? categoryId;

  @override
  State<FoodMenuItemScreen> createState() => _FoodMenuItemScreenState();
}

class _FoodMenuItemScreenState extends State<FoodMenuItemScreen> {
  late final String? _foodTypeValue;

  @override
  void initState() {
    super.initState();
    // map Arabic title to API foodType string (or null)
    _foodTypeValue =
        widget.isFoodType ? foodTypeFromArabic(widget.title) : null;

    // trigger initial load after build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.isFoodType) {
        context.read<FoodMenuCubit>().getProducts(foodType: _foodTypeValue);
      } else {
        context
            .read<FoodMenuCubit>()
            .getProducts(categoryId: widget.categoryId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    List<ProductModel> realItems;

    return Scaffold(
      body: SafeArea(
          child: Padding(
        padding: EdgeInsetsDirectional.symmetric(vertical: 3.sh),
        child: Column(
          children: [
            // Header + search
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.sw),
              child: Column(
                children: [
                  HomeScreenHeader(
                    title: widget.title,
                    isMain: true,
                  ),
                  DummyTextFieldContainer(),
                ],
              ),
            ),
            Expanded(
              child: BlocBuilder<FoodMenuCubit, FoodMenuState>(
                  builder: (context, state) {
                if (state is FoodMenuLoading) {
                  return Skeletonizer(
                    enabled: true,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          SizedBox(height: 2.sh),
                          // Provide dummy products to build the UI structure
                          FoodMenuItemList(itemsFamous: getDummyProducts(5)),
                        ],
                      ),
                    ),
                  );
                } else if (state is FoodMenuLoaded) {
                  return (state.products.isEmpty)
                      ? EmptyProductsSection()
                      : SingleChildScrollView(
                          child: Column(
                            children: [
                              SizedBox(height: 2.sh),
                              FoodMenuItemList(itemsFamous: state.products)
                            ],
                          ),
                        );
                } else if (state is FoodMenuError) {
                  return Center(
                      child: Column(
                    children: [
                      SizedBox(
                        height: 30.sh,
                      ),
                      Text(
                        state.message,
                        style: TextStyle(fontSize: 4.sw),
                      ),
                    ],
                  ));
                } else {
                  return SizedBox();
                }
              }),
            ),
          ],
        ),
      )),
    );
  }
}
