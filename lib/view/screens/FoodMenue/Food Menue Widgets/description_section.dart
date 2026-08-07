import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';

/// Small widgets used above
class DescriptionSection extends StatelessWidget {
  const DescriptionSection({super.key, required this.description});
  final String description;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.sw),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('الوصف', style: TextStyle(fontSize: 4.sw, fontWeight: FontWeight.w600)),
          SizedBox(height: 1.sh * 0.01),
          Text(description, style: TextStyle(fontSize: 3.8.sw, color: Colors.black87, height: 1.6), textAlign: TextAlign.justify),
        ],
      ),
    );
  }
}
