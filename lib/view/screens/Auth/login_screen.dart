import 'dart:developer';

import 'package:elmaleka_kitchen_project/core/theme/colors.dart';
import 'package:elmaleka_kitchen_project/view/Widgets/custom_textfield.dart';
import 'package:elmaleka_kitchen_project/view/Widgets/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:responsive_builder/responsive_builder.dart';
import '../../../core/Utils/is_tablet_service.dart';
import '../../../view_model/Auth/auth_cubit.dart';
import '../../Widgets/have_account_part.dart';
import '../../Widgets/snack_bar.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailCtrl = TextEditingController();
  final TextEditingController passCtrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    emailCtrl.dispose();
    passCtrl.dispose();
    super.dispose();
  }


  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    final email = emailCtrl.text.trim();
    final password = passCtrl.text;

    context.read<AuthCubit>().login(email,password);
  }

  String? _validateEmail(String? v) {
    if (v == null || v.trim().isEmpty) return 'حقل البريد الإلكتروني مطلوب';
    final email = v.trim();
    final regex = RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$");
    if (!regex.hasMatch(email)) return 'رجاءً أدخل بريدًا إلكترونيًا صالحًا';
    return null;
  }

  String? _validateNotEmpty(String? v, String fieldName) {
    if (v == null || v.trim().isEmpty) return 'حقل $fieldName مطلوب';
    return null;
  }

  String? _validatePassword(String? v) {
    if (v == null || v.isEmpty) return 'حقل كلمة المرور مطلوب';
    if (v.length < 6) return 'يجب أن تكون كلمة المرور 6 أحرف على الأقل';
    return null;
  }

  @override
  Widget build(BuildContext context) {

    var height = MediaQuery.of(context).size.height;
    return BlocListener<AuthCubit,AuthState>(
      listener: (context,state) {
        if (state is AuthAuthenticated) {
          showSnackBar(context,'تم التسجيل بنجاح', '', 'success');
          context.go('/navbar');
        } else if (state is AuthError) {
          showSnackBar(context,'خطأ', state.message, 'failure');
        }
      },
       child: SafeArea(
         child: Scaffold(
            // appBar: AppBar(
            //   automaticallyImplyLeading: false,
            // ),
            body: Center(
              child: Padding(
                padding: EdgeInsetsDirectional.symmetric(horizontal: 5.sw),
                child: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        Text(
                          'تسجيل الدخول',
                          style: TextStyle(fontSize: 3.6.sh),
                        ),
                        SizedBox(
                          height: 0.5.sh,
                        ),
                        Text(
                          'أضف التفاصيل الخاصة بك لتسجيل الدخول',
                          style: TextStyle(
                              color: AppColors.textLightColor, fontSize: 2.sh),
                        ),
                        SizedBox(
                          height: 3.sh,
                        ),
                        CustomTextField(
                          hintText: 'بريدك الإلكتروني',
                          height: height,
                          controller: emailCtrl,
                          validator: (value)=>_validateEmail(value),
                        ),
                        SizedBox(
                          height: 2.sh,
                        ),
                        CustomTextField(
                          hintText: 'كلمة المرور',
                          height: height,
                          controller: passCtrl,
                          obscureText: true,
                          validator: (v)=>_validatePassword(v),
                        ),
                        SizedBox(
                          height: 3.sh,
                        ),
                        BlocBuilder<AuthCubit, AuthState>(
                          builder: (context, state) {
                            final isLoading = state is AuthLoading;
                            return SizedBox(
                              height: isTablet(context) ? 9.sh : 7.sh,
                              width: isTablet(context) ? 70.sw : 85.sw,
                              child: isLoading
                              // show disabled-looking button with spinner
                                  ? ElevatedButton(
                                onPressed: null,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primaryColor,
                                ),
                                child: const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                        color: Colors.black87, strokeWidth: 2)),
                              )
                              // normal PrimaryButton
                                  : PrimaryButton(
                                color: AppColors.primaryColor,
                                txt: 'تسجيل',
                                method: _submit,
                              ),
                            );
                          },
                        ),
                        SizedBox(
                          height: 0,
                        ),
                        TextButton(
                            onPressed: () => context.push('/forgetPass'),
                            child: Text(
                              'هل نسيت كلمة المرور الخاصة بك؟ انقر هنا',
                              style: TextStyle(
                                  color: AppColors.textLightColor, fontSize: 4.sw),
                            )),
                        // SizedBox(
                        //   height: 5.sh,
                        // ),
                        // Text(
                        //   'أو تسجيل الدخول باستخدام',
                        //   style: TextStyle(
                        //       color: AppColors.textLightColor, fontSize: 4.sw),
                        // ),
                        // SizedBox(
                        //   height: 3.sh,
                        // ),
                        // PrimaryButton(
                        //     isLong: true,
                        //     color: AppColors.facebookColor,
                        //     txt: 'تسجيل الدخول باستخدام فيسبوك',
                        //     widget: SvgPicture.asset(
                        //       'lib/assets/images/facebook-letter-logo.svg',
                        //       width: 2.sw,
                        //     ),
                        //     method: () {}),
                        // SizedBox(
                        //   height: 2.sh,
                        // ),
                        // PrimaryButton(
                        //     isLong: true,
                        //     color: Colors.red,
                        //     txt: 'تسجيل الدخول باستخدام جوجل ',
                        //     widget: SvgPicture.asset(
                        //       'lib/assets/images/google-plus-logo.svg',
                        //       width: 5.sw,
                        //     ),
                        //     method: () {}),
                        SizedBox(
                          height: 6.sh,
                        ),
                        HaveAccountPart(
                            method: () => context.push('/signup'),
                            txt1: 'ليس لديك حساب؟ ',
                            txt2: ' تسجيل'),
                        SizedBox(
                          height: 2.sh,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
       ),
    );
  }
}
