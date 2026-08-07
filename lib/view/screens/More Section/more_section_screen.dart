import 'package:elmaleka_kitchen_project/core/Utils/is_tablet_service.dart';
import 'package:elmaleka_kitchen_project/core/theme/colors.dart';
import 'package:elmaleka_kitchen_project/view/Widgets/cart_icon.dart';
import 'package:elmaleka_kitchen_project/view/Widgets/snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:responsive_builder/responsive_builder.dart';

class MoreSectionScreen extends StatelessWidget {
  const MoreSectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text("أكثر",
          style: TextStyle( fontWeight: FontWeight.bold,fontSize: 5.5.sw),
        ),
        actions: [
          CartIcon()
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(4.sw),
        child: Center(
          child: Column(
            children: [
              // _menuItem(
              //   icon: Icons.attach_money_rounded,
              //   title: "تفاصيل الدفع",
              //   onTap: () {},
              // ),
              // _menuItem(
              //   icon: Icons.shopping_bag_rounded,
              //   title: "طلباتي",
              //   badgeCount: 0,
              //   onTap: () => showSnackBar(context,'معلومة', "هذه الخدمة لم "
              //       "تتوفر بعد", "info"),
              //   context: context
              // ),
              _menuItem(
                  icon: Icons.favorite_rounded,
                  title: "المفضلة",
                  onTap: () => context.push('/fav'),
                  context: context
              ),
              _menuItem(
                icon: Icons.info,
                title: "من نحن",
                onTap: () => context.push('/about'),
                context: context
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// ---------- Menu Item Widget ----------
  Widget _menuItem({
    required IconData icon,
    required String title,
    int? badgeCount,
    required VoidCallback onTap,
    required BuildContext context
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: 85.sw,
            height:isTablet(context)? 12.sh:10.sh,
            margin: EdgeInsets.symmetric(vertical: 1.sh),
            padding: EdgeInsets.symmetric(horizontal: 4.sw, vertical: 2.sh),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 6.sw,
                  backgroundColor: Colors.grey[300],
                  child: Icon(icon, color: Colors.black54, size: 6.sw),
                ),
                SizedBox(width: 4.sw),

                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(fontSize: 4.sw, fontWeight: FontWeight.w500),
                  ),
                ),

                if (badgeCount != null && badgeCount > 0)
                  Container(
                    margin: EdgeInsets.only(right: 2.sw),
                    padding: EdgeInsets.symmetric(horizontal: 2.5.sw, vertical: 0.5.sh),
                    decoration: BoxDecoration(
                      color: AppColors.secondaryColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      "$badgeCount",
                      style: TextStyle(color: Colors.white, fontSize: 3.5.sw),
                    ),
                  ),
                SizedBox(width: 5.sw,)
              ],
            ),
          ),
          Positioned(
            left: -3.sw,
            top: 4.sh,
            child: CircleAvatar(
                radius: 4.sw,
                backgroundColor: Colors.grey[200]
                ,child: Icon(Icons.chevron_right, color: Colors.grey,size: 6.sw,)),
          ),
        ],
      ),
    );
  }
}
