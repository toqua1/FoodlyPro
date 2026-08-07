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

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailCtrl = TextEditingController();

  @override
  void dispose() {
    emailCtrl.dispose();
    super.dispose();
  }

  String? _validateEmail(String? v) {
    if (v == null || v.trim().isEmpty) return 'حقل البريد الإلكتروني مطلوب';
    final email = v.trim();
    final regex = RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$");
    if (!regex.hasMatch(email)) return 'رجاءً أدخل بريدًا إلكترونيًا صالحًا';
    return null;
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    final email = emailCtrl.text.trim();
    context.read<AuthCubit>().requestOtp(email);
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;

    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthOtpRequestSuccess) {
          showSnackBar(context,state.message, '', 'success');
          context.push('/verifyOtp', extra: state.token);
        } else if (state is AuthOtpRequestError) {
          showSnackBar(context,state.message, '', 'failure');
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text('نسيت كلمة المرور',
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
                  Text('أدخل بريدك الإلكتروني لإرسال رمز التحقق',
                      style: TextStyle(
                          fontSize: 4.sw, color: AppColors.textLightColor),
                      textAlign: TextAlign.center),
                  SizedBox(height: 4.sh),
                  CustomTextField(
                    hintText: 'البريد الإلكتروني',
                    controller: emailCtrl,
                    validator: _validateEmail,
                    height: height,
                  ),
                  SizedBox(height: 3.sh),
                  BlocBuilder<AuthCubit, AuthState>(
                    builder: (context, state) {
                      final isLoading = state is AuthOtpRequestLoading;
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
                                txt: 'إرسال رمز التحقق',
                                method: _submit,
                              ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
