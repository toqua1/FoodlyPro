import 'package:elmaleka_kitchen_project/view/Widgets/total_checkout_row.dart';
import 'package:flutter/material.dart';

class BuildTotalCheckoutSection extends StatelessWidget {
  const BuildTotalCheckoutSection({
    super.key,required this.totalPrice,required this.shipping,required this.grandTotal,
  });
  final dynamic totalPrice ;
  final dynamic  shipping ;
  final dynamic  grandTotal ;
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      TotalCheckoutRow(
          label: "إجمالي سعر الوجبات", value: "$totalPrice جنية"),
      Divider(),
      TotalCheckoutRow(
          label: "سعر التوصيل", value: "$shipping جنية"),
      const Divider(),
      TotalCheckoutRow(
          label: "الإجمالي",
          value: "$grandTotal جنية",
          bold: true,
          red: true),
    ],);
  }
}
