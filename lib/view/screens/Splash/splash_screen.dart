import 'dart:async';
import 'dart:developer';
import 'package:elmaleka_kitchen_project/Services/Storage/secure_storage_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../view_model/Auth/auth_cubit.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin
{
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    );

    _controller.forward();

    _navigateToNextScreen();
  }

  Future<void> _navigateToNextScreen() async {
    final prefs = await SharedPreferences.getInstance();
    final introSeen = prefs.getBool('introSeen') ?? false;

    // Wait for the splash screen to be visible for a minimum duration
    await Future.delayed(const Duration(seconds: 3));

    try {
      final tokenExists = await SecureStorageService().getToken() != null;
      log('Token exists: $tokenExists');

      if (tokenExists) {
        // await _loadUserData();
        if (!mounted) return;
        // If data loading is successful, navigate to the main part of the app.
        context.go('/navbar');
      } else {
        // No token, so navigate to the onboarding or login screen.
        if (!mounted) return;
        introSeen ? context.go('/firstAuth') : context.go('/boarding');
      }
    } catch (err) {
      log('Error during startup: $err');
      // Check for a 401 Unauthorized error specifically
      final isAuthError = err.toString().contains('401') || err is TimeoutException;

      if (isAuthError) {
        await context.read<AuthCubit>().logout();
        if (!mounted) return;
        context.go('/firstAuth');
      } else {
        // For any other error, still navigate to the main screen but the UI
        // will be in an empty or error state, which each page must handle.
        if (!mounted) return;
        context.go('/navbar');
      }
    }
  }

  // Future<void> _loadUserData() async {
  //   try {
  //     // await Future.wait([
  //       await context.read<AddressCubit>().fetchAddresses();
  //      await context.read<CartCubit>().fetchCart();
  //     // ]).timeout(const Duration(seconds: 6));
  //   }catch(e) {
  //     throw Exception(e);
  //   }
  // }

//   Future<void> _navigateToNextScreen() async {
//     final prefs = await SharedPreferences.getInstance();
//     final introSeen = prefs.getBool('introSeen') ?? false;
//     final tokenExists =await SecureStorageService().getToken() != null;
// log('token exists: $tokenExists');
//     // keep splash visible for at least N seconds
//     await Future.delayed(const Duration(seconds: 1));
//
//     // if not logged in go straight
//     if (!tokenExists) {
//       await Future.delayed(const Duration(seconds: 3)); // decorative splash time
//       if (!mounted) return;
//       return introSeen ? context.go('/firstAuth') : context.go('/boarding');
//     }
//
//     // We have a token -> try to prefetch protected data safely
//     try {
//       // run prefetches in parallel with a global timeout
//       await Future.any([
//         Future.wait([
//           context.read<AddressCubit>().fetchAddresses(),
//           context.read<CartCubit>().fetchCart(),
//         ]),
//         Future.delayed(const Duration(seconds: 6), () => throw TimeoutException('prefetch timeout')),
//       ]);
//
//       if (!mounted) return;
//       context.go('/navbar');
//     } catch (err) {
//       // If unauthorized -> clear token & go to login
//       final isAuthError = err is TimeoutException
//           ? false
//           : err.toString().toLowerCase().contains('401') ||
//           err.toString().toLowerCase().contains('unauthorized');
//
//       if (isAuthError) {
//         // clear token (and any saved user info)
//         await context.read<AuthCubit>().logout(); // must clear shared prefs
//         if (!mounted) return;
//         context.go('/firstAuth');
//         return;
//       }
//
//       // fallback: if prefetch failed but not auth error, still let user in
//       if (!mounted) return;
//       context.go('/navbar');
//     }
//   }


  @override
  void dispose() {
    _controller.dispose();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: SystemUiOverlay.values);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double logoWidth = MediaQuery.of(context).size.width ;

    return Scaffold(
      backgroundColor: Colors.white ,
      body: Center(
        child: FadeTransition(
          opacity: _animation,
          child:
          SvgPicture.asset('lib/assets/images/Black Queen Beauty Salon Logo.svg',
            width: logoWidth,
          ),
        ),
      ),
    );
  }
}