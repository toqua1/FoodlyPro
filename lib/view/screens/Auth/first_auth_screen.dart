import 'package:elmaleka_kitchen_project/core/Utils/is_tablet_service.dart';
import 'package:elmaleka_kitchen_project/core/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:responsive_builder/responsive_builder.dart';
import '../../Widgets/header_cutout.dart';
import '../../Widgets/outlined_red_button.dart';
import '../../Widgets/primary_button.dart';

class FirstAuthScreen extends StatelessWidget {
  const FirstAuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          HeaderWithCutout(),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                RichText(
                  text: TextSpan(
                      text: 'مطبخ ',
                      style: TextStyle(color: AppColors.textColor,fontSize:5
                          .sh),
                      children: [
                        TextSpan(
                            text: 'الملكة',
                            style: TextStyle(color: AppColors.secondaryColor,
                              fontSize: 5.sh,))
                      ]),
                ),
                SizedBox(
                  height: 2.sh,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: isTablet(context)
                      ?3.sw:2.sw),
                  child: Text(textAlign: TextAlign.center,
                      'اكتشف أفضل الأطعمة من أكثر من 1,000 مطعم مع توصيل سريع '
                          'إلى باب منزلك !',style: TextStyle
                      (fontSize:4.5.sw,
                        color: AppColors.textLightColor,fontWeight: FontWeight.w500
                    ),),
                ),
              ],
            ),
          ),
          PrimaryButton(color: AppColors.primaryColor,txt: 'تسجيل الدخول',
              method: () => context.push('/login')),
          SizedBox(
            height: 2.sh,
          ),
          OutlinedRedButton(method:()=> context.push('/signup'),),
          SizedBox(
            height: 4.sh,
          ),
        ],
      ),
    );
  }
}
