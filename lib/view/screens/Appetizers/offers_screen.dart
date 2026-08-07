import 'package:elmaleka_kitchen_project/core/Utils/is_tablet_service.dart';
import 'package:elmaleka_kitchen_project/core/theme/colors.dart';
import 'package:elmaleka_kitchen_project/view/screens/Home/Home%20Widgets/food_category_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../../core/Utils/dummy_products.dart';
import '../../../view_model/Food Menu List/food_menu_list_cubit.dart';
import '../../../view_model/Products/products_cubit.dart';
import '../../Widgets/empty_products_section.dart';
import '../../Widgets/snack_bar.dart';
import '../FoodMenue/Food Menue Widgets/food_menu_item_list.dart';
import '../Home/Home Widgets/home_screen_header.dart';

class OffersScreen extends StatefulWidget {
  const OffersScreen({super.key});

  @override
  State<OffersScreen> createState() => _OffersScreenState();
}

class _OffersScreenState extends State<OffersScreen> {

  @override
  void initState() {
    super.initState();

    // trigger initial load after build
    WidgetsBinding.instance.addPostFrameCallback((_) {
        context.read<FoodMenuCubit>().getProducts();

    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: SafeArea(
          child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsetsDirectional.symmetric(vertical: 3.sh),
          child: Column(
            children: [
              // Header + search
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.sw),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    HomeScreenHeader(
                      title: 'أحدث العروض',
                    ),
                    Text(
                      'ابحث عن خصومات, عروض خاصة وجبات والمزيد!',
                      style: TextStyle(
                          color: AppColors.loginGreyColor, fontSize: 4.sw),
                    ),
                    SizedBox(height: 2.sh,),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: isTablet(context)? EdgeInsets.symmetric
                            (horizontal: 5.sw,vertical: 1.5.sh)
                              :null,
                          backgroundColor: AppColors.secondaryColor,
                        ),
                        onPressed: () => showSnackBar(context, 'لايوجد عروض '
                            'حاليا','', 'info'),
                        child: Text(
                          'تحقق من العروض',
                          style: TextStyle(color: Colors.white,fontSize: 4.sw),
                        ))
                  ],
                ),
              ),
              BlocBuilder<FoodMenuCubit, FoodMenuState>(
                  builder: (context, state) {
                    if (state is FoodMenuLoading) {
                      return Skeletonizer(
                        enabled: true,
                        child: Column(
                          children: [
                            SizedBox(height: 2.sh),
                            // Provide dummy products to build the UI structure
                            FoodMenuItemList(itemsFamous: getDummyProducts(5)),
                          ],
                        ),
                      );
                    } else if (state is FoodMenuLoaded) {
                      return state.products.isEmpty
                          ? EmptyProductsSection()
                          : Column(
                        children: [
                          SizedBox(height: 2.sh),
                          FoodCategoryList(itemsFamous: state.products, isVertical:
                          true,)
                        ],
                      );
                    } else if (state is FoodMenuError) {
                      return Center(child: Column(
                        children: [
                          SizedBox(height: 30.sh,),
                          Text(state.message,style:
                          TextStyle(fontSize: 4.sw),),
                        ],
                      ));
                    } else {
                      return SizedBox();
                    }
                  }),
            ],
          ),
        ),
      )),
    );
  }
}
