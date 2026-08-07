// import 'dart:ui';
//
// import 'package:flutter/cupertino.dart';
// import 'package:flutter_svg/svg.dart';
//
// class DialogContent extends StatelessWidget {
//   const DialogContent(
//       {super.key,
//         required this.goal,
//         required this.content,
//         required this.title,
//         required this.onConfirm});
//   final String goal;
//   final String content;
//   final String title;
//   final VoidCallback onConfirm;
//   final String confirmText = 'OK';
//
//   @override
//   Widget build(BuildContext context) {
//     return ScreenTypeLayout.builder(
//       mobile: (context) => _buildContent(context, isTablet: false),
//       tablet: (context) => _buildContent(context, isTablet: true),
//     );
//   }
//
//   Widget _buildContent(BuildContext context, {required bool isTablet}) {
//     return SingleChildScrollView(
//       child: Container(
//         width: isTablet ? 60.sw : double.infinity,
//         color: NeumorphicTheme.baseColor(context),
//         padding: EdgeInsets.symmetric(
//           horizontal: isTablet
//               ? 32.0
//               : goal == 'newPass'
//               ? 16.0
//               : 0,
//           vertical: isTablet
//               ? 48.0
//               : goal == 'newPass'
//               ? 24.0
//               : 0,
//         ),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             goal == 'newPass'
//                 ? SvgPicture.asset(
//               'lib/assets/success.svg',
//               width: isTablet ? 350 : 120, // Adjust size based on device
//             )
//                 : goal == 'error'
//                 ? Lottie.asset('lib/assets/errorAnimation.json',
//                 width: isTablet ? 350 : 120)
//                 : Lottie.asset('lib/assets/successAnimation.json',
//                 width: isTablet ? 350 : 120),
//             const SizedBox(height: 16),
//             Text(
//               title,
//               style: AppFonts.boldTextForgetColor.copyWith(
//                   fontSize: 5.sw, color: goal == 'error' ? Colors.red
//                   :goal=='success'?Colors.green: null),
//             ),
//             const SizedBox(height: 16),
//             Text(
//               content,
//               style: AppFonts.bodyTextRegularBlack.copyWith(fontSize: 4.sw),
//               textAlign: TextAlign.center,
//             ),
//             SizedBox(height: isTablet ? 100 : 50),
//             Row(
//               children: [
//                 Spacer(),
//                 TextButton(
//                   onPressed: onConfirm,
//                   child: Text(
//                     confirmText,
//                     style: AppFonts.primaryTextThin,
//                   ),
//                 )
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
