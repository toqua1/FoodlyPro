import 'package:elmaleka_kitchen_project/view/Widgets/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/Utils/is_tablet_service.dart';
import '../../../core/theme/colors.dart';
import 'Boarding Widgets/boarding_dots.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});

  @override
  OnBoardingScreenState createState() => OnBoardingScreenState();
}

class OnBoardingScreenState extends State<OnBoardingScreen>
    with SingleTickerProviderStateMixin {
  int _currentPage = 0;
  // late AnimationController _controller;
  // late Animation<Offset> _animation;
  final _pageController = PageController(initialPage: 0);

  @override
  void initState() {
    super.initState();
    checkIntroSeenStatus();
    // Initialize the animation controller
    // _controller = AnimationController(
    //   vsync: this,
    //   duration: const Duration(milliseconds: 900), // Animation duration
    // )..repeat(reverse: true); // Repeat the animation in a loop
    //
    // // Define the animation (up and down movement)
    // _animation = Tween<Offset>(
    //   begin: Offset.zero, // Start position
    //   end: const Offset(0, 0.2), // Move down by 20% of the container height
    // ).animate(CurvedAnimation(
    //   parent: _controller,
    //   curve: Curves.easeInOut, // Smooth easing
    // ));
  }

  @override
  void dispose() {
    // _controller.dispose(); // Dispose the controller to avoid memory leaks
_pageController.dispose();
    super.dispose();
  }

  Future<void> checkIntroSeenStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool introSeen = prefs.getBool('introSeen') ?? false;
    if (!mounted) return;

    if (introSeen) {
      context.go('/firstAuth');
    }
  }

  Future<void> markIntroAsSeen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('introSeen', true);
  }

  final pages = [
    PageData(
      title: "ابحث عن الطعام الذي تحبه",
      body:
      "اكتشف أفضل الأطعمة من أكثر من 1,000 مطعم مع توصيل سريع إلى باب منزلك! ",
      pic: 'lib/assets/images/boarding1.svg',
    ),
    PageData(
      title: "توصيل سريع",
      body: "توصيل الوجبات السريعة إلى منزلك ومكتبك أينما كنت",
      pic: 'lib/assets/images/boarding2.svg',
    ),
    PageData(
      title: "التتبع المباشر",
      body: "تتبع طعامك في الوقت الفعلي على التطبيق بمجرد تقديم الطلب",
      pic: 'lib/assets/images/boarding3.svg',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: PageView(
        controller: _pageController,
        physics: NeverScrollableScrollPhysics(),
        onPageChanged: (index) {
          setState(() {
            _currentPage = index;
          });
        },
        children: pages
            .map((p) => SafeArea(
                    child: _Page(
                  page: p,
                  pagesNumber: pages.length,
                  currentPage: _currentPage,
                      onNext: _goToNextPage,
                )))
            .toList(),
      ),
    );
  }
  void _goToNextPage(){
    final next=_currentPage + 1 ;
   if(next < pages.length){
     _pageController.animateToPage(next, duration: const Duration
       (milliseconds: 300), curve: Curves.easeInOut);
   }else{
     markIntroAsSeen();
     context.go('/firstAuth');
   }
  }
}

class PageData {
  final String title;
  final String body;
  final String pic;

  const PageData({
    required this.pic,
    required this.title,
    required this.body,
  });
}

class _Page extends StatelessWidget {
  final PageData page;
  final int pagesNumber;
  final int currentPage;
  final VoidCallback onNext;
  const _Page(
      {Key? key,
      required this.page,
      required this.pagesNumber,
      required this.currentPage, required this.onNext})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          SizedBox(height: screenHeight * 0.05),
          _Image(
            page: page,
            size: isTablet(context) ? screenHeight * 0.4 : screenHeight * 0.36,
            pic: page.pic,
          ),
          SizedBox(height: screenHeight * 0.03),
          BoardingDots(pagesNumber: pagesNumber, currentPage: currentPage),
          SizedBox(height: screenHeight * 0.03),
          _Text(
            page: page,
            style: TextStyle(
                fontSize: 4.sh,
                color: AppColors.textColor,
                fontWeight: FontWeight.w400
            ),
            height: screenHeight,
          ),
          SizedBox(height: screenHeight * 0.1),
          PrimaryButton(
            color: AppColors.primaryColor,
            txt: 'التالي', method:onNext,
          )
        ],
      ),
    );
  }
}

class _Text extends StatelessWidget {
  const _Text({
    Key? key,
    required this.page,
    required this.height,
    this.style,
  }) : super(key: key);

  final PageData page;
  final double height;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          page.title,
          style: style,
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 10),
        Text(
          page.body,
          style: TextStyle(
            fontSize: 2.4.sh,
            color: AppColors.textLightColor,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class _Image extends StatelessWidget {
  const _Image({
    Key? key,
    required this.page,
    required this.size,
    required this.pic,
  }) : super(key: key);

  final PageData page;
  final double size;
  final String pic;

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      pic,
      width: size,
      height: size,
    );
  }
}
