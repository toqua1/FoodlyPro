import 'package:elmaleka_kitchen_project/core/Utils/is_tablet_service.dart';
import 'package:elmaleka_kitchen_project/core/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:responsive_builder/responsive_builder.dart';

class HeaderWithCutout extends StatelessWidget {
  const HeaderWithCutout({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return SizedBox(
      height: screenHeight * 0.35,
      width: double.infinity,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Stack(
            children:[
      ClipPath(
      clipper: BottomCenterCircleClipper(),
      clipBehavior: Clip.antiAlias,
      child: Container(
        decoration: BoxDecoration(
          // borderRadius: BorderRadius.circular(16),
          color: AppColors.primaryColor,
        ),
      ),
    ),
              Positioned(
                  right: 0,
                  top: 12.sh,
                  child: SvgPicture.asset(
                    'lib/assets/images/Path 2987.svg',
                    height: 13.sh,
                    color: Colors.white.withOpacity(0.2),
                  )),
              Positioned(
                  left: -15.sw,
                  top: -12.sh,
                  child: CircleAvatar(
                    backgroundColor: Colors.white.withOpacity(0.2),
                    radius:isTablet(context)? 20.sw:30.sw,
                    child: Container(),
                  )),
              Positioned(
                  left: 0,
                  right: 0,
                  top:isTablet(context)? 10.sh:20.sh,
                  child: CircleAvatar(
                    backgroundColor: Colors.white.withOpacity(0.2),
                    radius:5.sw,
                    child: Container(),
                  )),
              Positioned(
                  right: 10.sw,
                  top:30.sh ,
                  child: CircleAvatar(
                    backgroundColor: Colors.white.withOpacity(0.2),
                    radius: 2.sw,
                    child: Container(),
                  )),
              Positioned(
                  left: 20.sw,
                  top:18.sh ,
                  child: CircleAvatar(
                    backgroundColor: Colors.white.withOpacity(0.2),
                    radius: 2.sw,
                    child: Container(),
                  )),
              Positioned(
                  left: 0,
                  top: 25.sh,
                  child: CircleAvatar(
                    backgroundColor: Colors.white.withOpacity(0.2),
                    radius: 15.sw,
                    child: Container(),
                  )),
              Positioned(
                  right:-10.sw,
                  top: -27.sw,
                  child: CircleAvatar(
                    backgroundColor: Colors.white.withOpacity(0.2),
                    radius: 20.sw,
                    child: Container(),
                  )),
              Positioned(
                  right:0,
                  left: 30.sw,
                  top:5.sh,
                  child: CircleAvatar(
                    backgroundColor: Colors.white.withOpacity(0.2),
                    radius: 7.sw,
                    child: Container(),
                  )),
            ]
          ),
          // Place your logo overlapping the cut‑out
          Transform.translate(
            offset: const Offset(0, 60),
            child: SvgPicture.asset(
              'lib/assets/images/Black Queen Beauty Salon Logo.svg',
              width: 40.sw,
            ),
          ),
        ],
      ),
    );
  }
}

/// Clips its child to a rectangle with a half‑circle cut‑out at the bottom center.
class BottomCenterCircleClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    // 1) Full-rect path
    final rect = Path()..addRect(Rect.fromLTWH(0, 0, size.width, size.height));

    // 2) Circle path (we’ll subtract this)
    final radius = size.width * 0.20; // 20% of width—tweak as needed
    final center = Offset(size.width / 2, size.height);
    final circle = Path()
      ..addOval(Rect.fromCircle(center: center, radius: radius));

    // 3) Subtract the circle from the rect
    return Path.combine(PathOperation.difference, rect, circle);
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> old) => false;
}
