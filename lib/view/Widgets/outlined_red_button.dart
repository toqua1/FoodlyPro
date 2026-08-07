
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:responsive_builder/responsive_builder.dart';
import '../../core/Utils/is_tablet_service.dart';
import '../../core/theme/colors.dart';

class OutlinedRedButton extends StatelessWidget {
  const OutlinedRedButton({
    super.key, required this.method,
  });
final VoidCallback method ;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height:isTablet(context)?9.sh :7.sh,
      width:isTablet(context)?70.sw : 85.sw,
      child: ElevatedButton(
        onPressed: method,
        style: ElevatedButton.styleFrom(
          // backgroundColor: Colors.transparent,
          // padding: EdgeInsetsDirectional.symmetric(horizontal: isTablet
          //   (context)?200:35.sw,vertical: isTablet(context)? 20:15),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6.sw),
              side: BorderSide(color: AppColors.secondaryColor,width: 2)
          ),
        ),
        child: Text('إنشاء حساب',style: TextStyle(color: AppColors
            .secondaryColor,fontSize: 4.sw),),
      ),
    );
  }
}
