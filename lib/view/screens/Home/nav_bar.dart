
import 'package:elmaleka_kitchen_project/core/Utils/is_tablet_service.dart';
import 'package:elmaleka_kitchen_project/core/theme/colors.dart';
import 'package:elmaleka_kitchen_project/view/screens/Appetizers/offers_screen.dart';
import 'package:elmaleka_kitchen_project/view/screens/FoodMenue/food_menu_screen.dart';
import 'package:elmaleka_kitchen_project/view/screens/Home/home_screen.dart';
import 'package:elmaleka_kitchen_project/view/screens/More%20Section/more_section_screen.dart';
import 'package:elmaleka_kitchen_project/view/screens/Profile/profile_screen.dart';
import 'package:elmaleka_kitchen_project/view_model/Home/Navigation/navigation_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_builder/responsive_builder.dart';

class CustomBottomNavBar extends StatelessWidget {
  const CustomBottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    // 0: Menu, 1: FoodMenu, 2: Home, 3: Profile, 4: More
    final pages = [
      const FoodMenuScreen(),
      const OffersScreen(),
      const HomeScreen(),
      const ProfileScreen(),
      const MoreSectionScreen(),
    ];

    final icons = [
      Icons.restaurant_menu,
      Icons.fastfood,
      Icons.home,           // center
      Icons.person_outline,
      Icons.more_horiz,
    ];

    final labels = ['القائمة', 'العروض', 'الرئيسية', 'الملف الشخصي', 'المزيد'];

    return BlocBuilder<NavigationCubit, int>(
      builder: (context, selectedIndex) {
        return Scaffold(
          extendBody: true,
          body: pages[selectedIndex],

          // 1) Center FAB as "Home" at index 2
          floatingActionButton: SizedBox(
            width: 15.sw,
            height: 15.sw,
            child: FloatingActionButton(
              onPressed: () => context.read<NavigationCubit>().setPage(2),
              backgroundColor: selectedIndex == 2
                  ? AppColors.secondaryColor
                  : AppColors.textLightColor,
              shape: CircleBorder(),
              elevation: 4,
              child: Icon(
                icons[2],
                size: 10.sw,
                color: Colors.white,
              ),
            ),
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

          // 2) BottomAppBar with notch
          bottomNavigationBar: BottomAppBar(
            height: isTablet(context)? 12.sh: 10.sh,
            shape: const CircularNotchedRectangle(),
            notchMargin: 4.sw,
            color: Colors.grey.shade200,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              // 3) Build the 4 side icons, skipping the center (index 2)
              children: List.generate(icons.length, (i) {
                if (i == 2) {
                  return SizedBox(width: 15.sw);
                  // leave space for FAB
                }
                final isActive = selectedIndex == i;
                return GestureDetector(
                  onTap: () => context.read<NavigationCubit>().setPage(i),
                  behavior: HitTestBehavior.opaque,/*The area occupied by the widget becomes tappable, even if the widget itself has no visual content.
            */
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        icons[i],
                        color: isActive
                            ? AppColors.secondaryColor
                            : AppColors.textLightColor,
                        size:isActive? 8.sw:7.sw,
                      ),
                      SizedBox(height: 0.5.sh),
                      Text(
                        labels[i],
                        style: TextStyle(
                          fontSize: 3.sw,
                          color: isActive
                              ? AppColors.secondaryColor
                              : AppColors.textLightColor,
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ),
          ),
        );
      },
    );
  }
}
