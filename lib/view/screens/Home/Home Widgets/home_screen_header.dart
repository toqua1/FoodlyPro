import 'package:elmaleka_kitchen_project/view/Widgets/cart_icon.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:responsive_builder/responsive_builder.dart';
import '../../../../Services/Storage/shared_preferences_service.dart';
import '../../../../core/Utils/Time Format/arabic_greating_method.dart';
import '../../../../core/theme/colors.dart';
import '../../../Widgets/address_bottom_sheet.dart';

class HomeScreenHeader extends StatelessWidget {
  const HomeScreenHeader({
    super.key, this.title, this.isMain,
  });
final String? title ;
final bool? isMain ;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            isMain != null ?
            IconButton(icon:Icon(Icons.arrow_back_ios_rounded,size: 4.sw),
                onPressed: ()=> context.pop())
                :SizedBox(),
            title != null?
            Text(title!,style: TextStyle(
              color: AppColors.textColor,
              fontSize: 6.2.sw,
            ),)
                :HomeGreetingHeader(),
          ],
        ),
        CartIcon()
      ],
    );
  }
}

class HomeGreetingHeader extends StatelessWidget {
  const HomeGreetingHeader({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final Future<String?> name= UserData().getStoredName();
    return FutureBuilder(future: name, builder: (context,snapshot){
      final name =  (snapshot.connectionState == ConnectionState.done && snapshot.data != null && snapshot.data!.isNotEmpty)
          ? snapshot.data!
          : 'ضيف';
     return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${getGreetingMessage()} $name !',
            style: TextStyle(
              color: AppColors.textColor,
              fontSize: 5.sw,
            ),
          ),
          Text(
            'التوصيل إلى',
            style: TextStyle(color: AppColors.textLightColor, fontSize: 3.5.sw),
          ),
          InkWell(
            onTap: () {
              showModalBottomSheet(
                context: context,
                backgroundColor: Colors.white,
                isScrollControlled: true,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
                ),
                builder: (BuildContext context) {
                  return const AddressBottomSheet();
                },
              );
            },
            child: Row(
              children: [
                Text(
                  'الموقع الحالي',
                  style: TextStyle(
                      color: AppColors.textLightColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 4.sw),
                ),
                SizedBox(
                  width: 3.sw,
                ),
                Transform.rotate(
                    angle: -3.14 / 2,
                    child: Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 4.sw,
                      color: AppColors.textLightColor,
                    ))
              ],
            ),
          )
        ],
      );
    });
  }
}
