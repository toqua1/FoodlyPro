
import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';

import '../../core/theme/colors.dart';

class TryAgainSection extends StatelessWidget {
  const TryAgainSection({
    super.key, required this.message, required this.method,
  });
  final String message;
  final VoidCallback method ;
  @override
  Widget build(BuildContext context) {
    return Center(child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(message,style: TextStyle(fontSize: 4.sw),),
        SizedBox(
          height: 1.sh,
        ),
        ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: AppColors.secondaryColor),
            onPressed:method,
            child: Text(
              'محاولة اخرى',
              style: TextStyle(fontSize: 4.sw),
            )
        ),
      ],
    ));
  }
}