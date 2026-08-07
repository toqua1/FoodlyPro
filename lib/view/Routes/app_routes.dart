import 'package:elmaleka_kitchen_project/data/datasources/payment_datasource.dart';
import 'package:elmaleka_kitchen_project/data/models/address_model.dart';
import 'package:elmaleka_kitchen_project/data/models/product_model.dart';
import 'package:elmaleka_kitchen_project/view/screens/Auth/create_new_pass_screen.dart';
import 'package:elmaleka_kitchen_project/view/screens/Auth/first_auth_screen.dart';
import 'package:elmaleka_kitchen_project/view/screens/Auth/forget_pass_screen.dart';
import 'package:elmaleka_kitchen_project/view/screens/Auth/signup_screen.dart';
import 'package:elmaleka_kitchen_project/view/screens/Auth/verify_otp_screen.dart';
import 'package:elmaleka_kitchen_project/view/screens/Cart/cart_screen.dart';
import 'package:elmaleka_kitchen_project/view/screens/Cart/checkout_screen.dart';
import 'package:elmaleka_kitchen_project/view/screens/FoodMenue/food_menu_item_screen.dart';
import 'package:elmaleka_kitchen_project/view/screens/FoodMenue/product_detailed_screen.dart';
import 'package:elmaleka_kitchen_project/view/screens/Home/home_screen.dart';
import 'package:elmaleka_kitchen_project/view/screens/Home/nav_bar.dart';
import 'package:elmaleka_kitchen_project/view/screens/More%20Section/about_us.dart';
import 'package:elmaleka_kitchen_project/view/screens/More%20Section/favourite_screen.dart';
import 'package:elmaleka_kitchen_project/view/screens/Profile/address_details_screen.dart';
import 'package:elmaleka_kitchen_project/view/screens/Profile/address_screen.dart';
import 'package:elmaleka_kitchen_project/view/screens/Profile/profile_screen.dart';
import 'package:elmaleka_kitchen_project/view/screens/Splash/splash_screen.dart';
import 'package:elmaleka_kitchen_project/view/screens/onBoarding/onboarding_screen.dart';
import 'package:elmaleka_kitchen_project/view_model/Payment/payment_cubit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../Services/api_services.dart';
import '../../data/datasources/order_remote_datasource.dart';
import '../../data/datasources/products_remote_datasource.dart';
import '../../data/datasources/review_data_source.dart';
import '../../view_model/Order/order_cubit.dart';
import '../../view_model/Product Details/product_details_cubit.dart';
import '../../view_model/Review/review_cubit.dart';
import '../screens/Auth/login_screen.dart';
import '../screens/Home/search_screen.dart';

final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();
final GoRouter appRouter =
    GoRouter(navigatorKey: rootNavigatorKey, initialLocation: '/', routes: [
  // GoRoute(path: '/', builder: (context, state) => HomeScreen()),
  GoRoute(path: '/', builder: (context, state) => SplashScreen()),
  // GoRoute(path: '/',builder: (context,state) => ProductDetailScreen()),
  GoRoute(path: '/boarding', builder: (context, state) => OnBoardingScreen()),
  GoRoute(
    path: '/firstAuth',
    builder: (context, state) => FirstAuthScreen(),
  ),
  GoRoute(
    path: '/login',
    builder: (context, state) => LoginScreen(),
  ),
  GoRoute(path: '/signup', builder: (context, state) => SignupScreen()),
  GoRoute(
      path: '/forgetPass', builder: (context, state) => ForgotPasswordScreen()),
  GoRoute(
      path: '/verifyOtp',
      builder: (context, state) {
        final extra = state.extra as String?;
        return VerifyOtpScreen(
          token: extra ?? "",
        );
      }),
  GoRoute(
      path: '/resetPassword',
      builder: (context, state) {
        final extra = state.extra as String? ;
        return ResetPasswordScreen(
          token: extra ?? "",
        );
      }),
  GoRoute(path: '/home', builder: (context, state) => HomeScreen()),
  GoRoute(path: '/navbar', builder: (context, state) => CustomBottomNavBar()),
      GoRoute(path: '/fav', builder: (context, state) => FavouriteScreen()),
  GoRoute(
    name: 'foodMenuItem',
    path: '/foodMenuItem',
    builder: (context, state) {
      final extra = state.extra as Map<String, dynamic>?; // single read
      final title = extra?['title'] as String? ?? 'عنوان';
      final isFoodType = extra?['isFoodType'] as bool? ?? false;
      final categoryId = extra?['categoryId'] as int? ?? 1;
      return FoodMenuItemScreen(
        title: title,
        isFoodType: isFoodType,
        categoryId: categoryId,
      );
    },
  ),
  GoRoute(path: '/cart', builder: (context, state) => CartScreen()),

  GoRoute(
      path: '/checkout',
      builder: (context, state) => MultiBlocProvider(providers: [
            BlocProvider(
              create: (_) =>
                  OrderCubit(OrderRemoteDataSource(ApiServices().dio)),
            ),
            BlocProvider(
              create: (_) => PaymentCubit(PaymentDataSource(ApiServices().dio)),
            ),
          ], child: CheckoutScreen())),

  GoRoute(path: '/about', builder: (context, state) => AboutUsScreen()),
  GoRoute(
      path: '/productItem',
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>?;
        final product = extra?['product'] as ProductModel;
        return MultiBlocProvider(
          providers: [
            BlocProvider(
                create: (_) =>
                    ReviewCubit(ReviewDataSource(ApiServices().dio))),
            BlocProvider(
                create: (_) =>
                    ProductDetailsCubit(ProductsDataSource(ApiServices().dio))),
          ],
          child: ProductDetailScreen(
            product: product,
          ),
        );
      }),
  GoRoute(path: '/profile', builder: (context, state) => ProfileScreen()),
  GoRoute(path: '/address', builder: (context, state) => AddressScreen()),
  GoRoute(
    path: '/address-details',
    builder: (context, state) {
      final address = state.extra as AddressModel?;
      return AddressDetailsScreen(address: address);
    },
  ),
  GoRoute(
    path: '/search',
    builder: (context, state) {
      return const SearchScreen();
    },
  ),
]);
