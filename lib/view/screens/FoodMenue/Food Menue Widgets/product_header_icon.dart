
import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';

class HeaderIcon extends StatelessWidget {
  const HeaderIcon({super.key, required this.icon});
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(2.sw),
      decoration: BoxDecoration(color: Colors.white.withOpacity(0.9), shape: BoxShape.circle),
      child: Icon(icon, size: 5.sw, color: Colors.black),
    );
  }
}
