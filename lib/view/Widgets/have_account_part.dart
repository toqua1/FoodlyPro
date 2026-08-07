
import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';

import '../../core/theme/colors.dart';

class HaveAccountPart extends StatelessWidget {
  const HaveAccountPart({
    super.key, required this.method, required this.txt1, required this.txt2,
  });
  final VoidCallback method ;
  final String txt1;
  final String txt2;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: method,
      child: RichText(text: TextSpan(text: txt1,style: TextStyle(
          color: AppColors.textLightColor,fontSize: 4.sw
      ),
          children: [
            TextSpan(text: txt2,style: TextStyle(color: AppColors
                .secondaryColor,fontSize: 4.sw))
          ]
      ),
      ),
    );
  }
}
