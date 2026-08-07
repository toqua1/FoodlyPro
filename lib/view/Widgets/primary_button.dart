import 'package:elmaleka_kitchen_project/core/Utils/is_tablet_service.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:responsive_builder/responsive_builder.dart';

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    super.key, required this.color, required this.txt, required this.method, this.isLong, this.widget,
  });
final Color color ;
final String txt ;
final VoidCallback method ;
final bool? isLong ;
final Widget? widget ;
@override
  Widget build(BuildContext context) {
    return SizedBox(
      height:isTablet(context)?9.sh :7.sh,
        width:isTablet(context)?70.sw : 85.sw,
      child: ElevatedButton(
        onPressed: method,
        style: ElevatedButton.styleFrom(
            backgroundColor: color,
            // padding: EdgeInsetsDirectional.symmetric(
            //     horizontal: isTablet(context)?isLong != null ?100 :200:isLong !=
            //         null ? 10.sw:35.sw,
            //     vertical:isTablet(context)? 20:15),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6.sw))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            widget ?? SizedBox(),
            widget != null ?SizedBox(width: 2.sw):SizedBox() ,
            Text(txt,style: TextStyle(color: Colors.white,fontSize: 4.sw),),
          ],
        ),
      ),
    );
  }
}
