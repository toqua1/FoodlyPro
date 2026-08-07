
import 'package:flutter/cupertino.dart';
import 'package:responsive_builder/responsive_builder.dart';

import '../../../../core/theme/colors.dart';

class BoardingDots extends StatelessWidget {
  const BoardingDots({
    super.key,
    required this.pagesNumber,
    required this.currentPage,
  });

  final int pagesNumber;
  final int currentPage;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(pagesNumber, (i) {
        final isActive = i == currentPage;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: EdgeInsetsDirectional.symmetric(horizontal: 1.sw),
          width: isActive ? 3.sw : 2.sw,
          height: isActive ? 3.sw : 2.sw,
          decoration: BoxDecoration(
            color: isActive
                ? AppColors.primaryColor // your active color
                : AppColors.textLightColor, // your inactive color
            shape: BoxShape.circle,
          ),
        );
      }),
    );
  }
}
