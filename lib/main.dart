import 'package:elmaleka_kitchen_project/Services/api_services.dart';
import 'package:elmaleka_kitchen_project/core/theme/app_theme.dart';
import 'package:elmaleka_kitchen_project/data/datasources/address_remote_datasource.dart';
import 'package:elmaleka_kitchen_project/data/datasources/auth_remote_datasource.dart';
import 'package:elmaleka_kitchen_project/data/datasources/cart_remote_data_source.dart';
import 'package:elmaleka_kitchen_project/data/datasources/favourite_datasource.dart';
import 'package:elmaleka_kitchen_project/data/datasources/order_remote_datasource.dart';
import 'package:elmaleka_kitchen_project/data/datasources/profile_datasource.dart';
import 'package:elmaleka_kitchen_project/view/Routes/app_routes.dart';
import 'package:elmaleka_kitchen_project/view_model/Address/address_cubit.dart';
import 'package:elmaleka_kitchen_project/view_model/Auth/auth_cubit.dart';
import 'package:elmaleka_kitchen_project/view_model/Cart/cart_cubit.dart';
import 'package:elmaleka_kitchen_project/view_model/Favourite/favourite_cubit.dart';
import 'package:elmaleka_kitchen_project/view_model/Food%20Menu%20List/food_menu_list_cubit.dart';
import 'package:elmaleka_kitchen_project/view_model/Home/Navigation/navigation_cubit.dart';
import 'package:elmaleka_kitchen_project/view_model/Order%20Details/order_details_cubit.dart';
import 'package:elmaleka_kitchen_project/view_model/Products/products_cubit.dart';
import 'package:elmaleka_kitchen_project/view_model/Profile/profile_cubit.dart';
import 'package:flutter/material.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'data/datasources/products_remote_datasource.dart';

final di = GetIt.instance;

void main() async{
  // FIX: This must be the first line in main() to initialize the binding
  WidgetsFlutterBinding.ensureInitialized();

  final dio = ApiServices().dio; // creates singleton
  final authRemote = AuthRemoteDatasource(dio);
  final authCubit = AuthCubit(authRemote);

  // register the cubit so ApiServices can call logout if needed
  di.registerSingleton<AuthCubit>(authCubit);
  di.registerSingleton<ProductsDataSource>(ProductsDataSource(dio));

  runApp(DevicePreview(
      enabled: false,
      builder: (context) => MultiBlocProvider(providers: [
            BlocProvider(create: (_) => NavigationCubit()),
            BlocProvider(
                create: (_) =>
                    CartCubit(CartRemoteDataSource(ApiServices().dio))),
            BlocProvider(
                create: (_) =>
                    AddressCubit(AddressRemoteDataSource(ApiServices().dio))),
            BlocProvider(
                create: (_) =>
                    ProductsCubit(di<ProductsDataSource>())),
        BlocProvider(
            create: (_) =>
                ProfileCubit(ProfileDataSource(ApiServices().dio))),
        BlocProvider(
            create: (_) =>
                OrderDetailsCubit(OrderRemoteDataSource(ApiServices().dio))),
        BlocProvider(
            create: (_) => FoodMenuCubit(ProductsDataSource(ApiServices().dio))),
        BlocProvider(
            create: (_) => FavouriteCubit(favouriteDataSource: FavouriteDataSource(ApiServices
              ().dio))),
            BlocProvider(
                create: (_) =>authCubit)
          ], child: const MyApp())));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit,AuthState>(
      listener: (context,state) {
        if (state is AuthUnauthenticated) {
          // Use the navigatorKey's context, which is guaranteed to be from GoRouter
          appRouter.routerDelegate.navigatorKey.currentContext?.go('/firstAuth');
        }
      },
        child: ResponsiveApp(
          builder: (context) => Directionality(
            textDirection: TextDirection.rtl,
            child: MaterialApp.router(
              routerConfig: appRouter,
              locale: const Locale('ar'),
              supportedLocales: const [Locale('ar')],
              localizationsDelegates: [
                GlobalMaterialLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
              ],
              title: 'مطبخ الملكة ',
              theme: AppTheme.lightTheme,
              debugShowCheckedModeBanner: false,
              // home: context.push('/'),
            ),
          ),
        )
    );
  }
}
