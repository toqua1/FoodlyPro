import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:responsive_builder/responsive_builder.dart'; // optional, you use sw/sh

class OrderSuccessDialog extends StatelessWidget {
  const OrderSuccessDialog({super.key});

  @override
  Widget build(BuildContext context) {

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      insetPadding: EdgeInsets.symmetric(horizontal: 8.sw, vertical: 2.sh),
      backgroundColor: Colors.white,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 6.sw, vertical: 4.sh),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 50.sw,
                  child: SvgPicture.asset('lib/assets/images/Group 8168.svg'),
                ),
                Text(
                  'شكراً! \n لطلبك',
                  style: TextStyle(fontSize: 6.sw, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 1.5.sh),
                Text('تتم معالجة طلبك الآن. سنخبرك بمجرد انتقاء الطلب من المنفذ. تحقق من حالة طلبك'
                  ,textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 4.sw, color: Colors.grey[700]),
                ),
                SizedBox(height: 3.sh),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFc91f1f), // your red
                      padding: EdgeInsets.symmetric(vertical: 2.sh),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                        context.go('/navbar');
                    },
                    child: Text(
                      'العودة إلى المنزل',
                      style: TextStyle(fontSize: 4.5.sw, color: Colors.white),
                    ),
                  ),
                ),
                SizedBox(height: 1.sh),
              ],
            ),
          ),

          // Close button top-right
          Positioned(
            right: 6.sw,
            top: 4.sh,
            child: GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
                ),
                child: const Icon(Icons.close, color: Colors.black),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
