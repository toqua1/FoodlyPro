import 'package:elmaleka_kitchen_project/view/Widgets/snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_builder/responsive_builder.dart';
import '../../../core/Utils/is_tablet_service.dart';
import '../../../core/theme/colors.dart';
import '../../Widgets/custom_textfield.dart';
import '../../Widgets/primary_button.dart';
import '../../../view_model/Auth/auth_cubit.dart';
import 'package:go_router/go_router.dart';

class VerifyOtpScreen extends StatefulWidget {
  const VerifyOtpScreen({super.key, required this.token});
final String token;
  @override
  State<VerifyOtpScreen> createState() => _VerifyOtpScreenState();
}

class _VerifyOtpScreenState extends State<VerifyOtpScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController otpCtrl = TextEditingController();
  String? emailFromArgs;

  @override
  void dispose() {
    otpCtrl.dispose();
    super.dispose();
  }

  String? _validateOtp(String? v) {
    if (v == null || v.trim().isEmpty) return 'حقل الرمز مطلوب';
    if (v.trim().length < 6) return 'رمز غير صالح';
    return null;
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    final otp = otpCtrl.text.trim();
    context.read<AuthCubit>().verifyOtp(otp,widget.token);
  }

  @override
  Widget build(BuildContext context) {
    emailFromArgs = context.read<AuthCubit>().resetEmail;

    final height = MediaQuery.of(context).size.height;
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthOtpVerifySuccess) {
          showSnackBar(context,state.message, '', 'success');
          context.push('/resetPassword',extra: state.token);
        } else if (state is AuthOtpVerifyError) {
          showSnackBar(context,state.message, '', 'failure');
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text('تحقق من الرمز',
              style: TextStyle(fontSize: 5.sw, color: Colors.black)),
          centerTitle: true,
          elevation: 0,
          backgroundColor: Colors.white,
          leading: IconButton(
              icon: Icon(Icons.arrow_back_ios, size: 5.sw, color: Colors.black),
              onPressed: () => context.pop()),
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 5.sw, vertical: 4.sh),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Text('أدخل رمز التحقق المرسل إلى بريدك الإلكتروني',
                      style: TextStyle(
                          fontSize: 4.sw, color: AppColors.textLightColor),
                      textAlign: TextAlign.center),
                  SizedBox(height: 4.sh),
                  CustomTextField(
                    hintText: 'رمز التحقق',
                    controller: otpCtrl,
                    validator: _validateOtp,
                    height: height,
                  ),
                  SizedBox(height: 3.sh),
                  BlocBuilder<AuthCubit, AuthState>(
                    builder: (context, state) {
                      final isLoading = state is AuthOtpVerifyLoading;
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
                                color: AppColors.secondaryColor,
                                txt: 'تحقق',
                                method: _submit,
                              ),
                      );
                    },
                  ),
                  SizedBox(height: 2.sh),
                  TextButton(
                      onPressed: () {
                        // allow re-send OTP
                        final email = emailFromArgs;
                        if (email != null && email.isNotEmpty) {
                          context.read<AuthCubit>().requestOtp(email);
                        } else {
                          showSnackBar(context,
                              'البريد الإلكتروني غير متوفر لإعادة الإرسال',
                              '',
                              'failure');
                        }
                      },
                      child: Text('إعادة إرسال الرمز',
                          style: TextStyle(color: AppColors.secondaryColor))),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
