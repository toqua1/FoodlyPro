import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';
import '../../core/Utils/is_tablet_service.dart';
import '../../core/theme/colors.dart';

class SectionAndTitle extends StatelessWidget {
  final String title;
  final VoidCallback? method;

  SectionAndTitle({
    super.key,
    required this.title,
    this.method,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: TextStyle(
            color:AppColors.textColor,
            fontSize: 5.sw
        )),
            TextButton(
              onPressed: method ?? () {},
              child: Text("عرض الكل",
                  style: TextStyle(
                      color: AppColors.primaryColor,
                      fontSize: 4.sw
                  )),
            ),
      ],
    );
  }
}