
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:responsive_builder/responsive_builder.dart';

import '../../core/theme/colors.dart';

class DummyTextFieldContainer extends StatelessWidget {
  const DummyTextFieldContainer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => context.push('/search'),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 3.sw, vertical: 2.sh),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 3.sw, vertical: 2.sh),
          decoration: BoxDecoration(
            color: AppColors.textFieldFillColor,
            borderRadius: BorderRadius.circular(10.sw),
          ),
          child: Row(
            children: [
              Icon(
                Icons.search,
                size: 5.sw,
                color: AppColors.loginGreyColor,
              ),
              SizedBox(width: 8),
              Text('البحث عن الطعام',
                  style: TextStyle(
                      color: AppColors.loginGreyColor, fontSize: 4.sw)),
            ],
          ),
        ),
      ),
    );
  }
}
