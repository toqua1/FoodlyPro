

import 'package:flutter/cupertino.dart';
import 'package:responsive_builder/responsive_builder.dart';

import '../../core/theme/colors.dart';

class TotalCheckoutRow extends StatelessWidget {
  const TotalCheckoutRow(
      {super.key,
        required this.label,
        required this.value,
        this.bold = false,
        this.red = false});
  final String label;
  final dynamic value;
  final bool bold;
  final bool red;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label,
            style: TextStyle(
                fontWeight: bold ? FontWeight.bold : FontWeight.normal,
                fontSize: 4.sw)),
        Text(
          "$value",
          style: TextStyle(
              fontWeight: bold ? FontWeight.bold : FontWeight.normal,
              color: red ? AppColors.secondaryColor : null,
              fontSize: 4.sw),
        ),
      ],
    );
  }
}
