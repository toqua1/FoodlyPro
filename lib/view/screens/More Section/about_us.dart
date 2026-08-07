import 'package:elmaleka_kitchen_project/view/Widgets/cart_icon.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:responsive_builder/responsive_builder.dart';
import '../../../core/Utils/is_tablet_service.dart';
import '../../../core/theme/colors.dart';

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "من نحن",
          style: TextStyle(
            fontSize: isTablet(context) ? 6.sw : 5.sw,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        // backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, size: 5.sw, color: Colors.black),
          onPressed: () => context.pop(),
        ),
        actions: [
          CartIcon(),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 5.sw, vertical: 5.sh),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildParagraph(
                context,
                "نحن في مطعم السدة نقدم لكم تجربة طعام مميزة تصل إلى باب منزلك بكل سهولة وسرعة من خلال تطبيقنا الخاص لتوصيل الطلبات. نفتخر بكوننا وجهتكم المفضلة لأشهى الأطباق التي تُحضّر بعناية فائقة باستخدام أفضل المكونات الطازجة.",
              ),
              SizedBox(height: 3.sh),
              _buildSectionTitle(context, "رسالتنا:"),
              _buildParagraph(
                context,
                "نسعى لتوفير وجبات لذيذة وصحية تلبي جميع الأذواق، مع الحفاظ على جودة عالية وخدمة عملاء ممتازة.",
              ),
              SizedBox(height: 3.sh),
              _buildSectionTitle(context, "رؤيتنا:"),
              _buildParagraph(
                context,
                "أن نكون الخيار الأول لعشاق الطعام في منطقتنا، من خلال تقديم تجربة توصيل سلسة وموثوقة.",
              ),
              SizedBox(height: 3.sh),
              _buildSectionTitle(context, "لماذا نحن؟"),
              _buildBulletPoint(context, "تنوع في القائمة: لدينا تشكيلة واسعة من الأطباق تناسب جميع الأذواق."),
              _buildBulletPoint(context, "جودة عالية: نستخدم مكونات طازجة وطبيعية."),
              _buildBulletPoint(context, "سرعة التوصيل: الطلبات تصل إليك في أسرع وقت."),
              _buildBulletPoint(context, "خدمة عملاء مميزة: فريقنا متاح دائماً لمساعدتك."),
              SizedBox(height: 3.sh),
              _buildParagraph(
                context,
                "انضم إلينا واستمتع بتجربة طعام لا تُنسى مع مطعم السدة!",
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildParagraph(BuildContext context, String text) {
    return Text(
      text,
      textAlign: TextAlign.justify,
      style: TextStyle(
        fontSize: isTablet(context) ? 4.sw : 4.sw,
        color: Colors.black87,
        height: 1.5,
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Row(
      children: [
        Icon(Icons.circle, size: 2.sw, color: Colors.red),
        SizedBox(width: 2.sw),
        Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: isTablet(context) ? 4.5.sw : 4.5.sw,
            color: Colors.black,
          ),
        ),
      ],
    );
  }

  Widget _buildBulletPoint(BuildContext context, String text) {
    return Padding(
      padding: EdgeInsets.only(right: 5.sw, top: 1.sh),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("• ", style: TextStyle(fontSize: 4.sw, color: Colors.black)),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 4.sw,
                color: Colors.black87,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
