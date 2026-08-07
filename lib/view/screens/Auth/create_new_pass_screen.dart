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

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key, required this.token});
final String token;
  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController passCtrl = TextEditingController();
  final TextEditingController confirmCtrl = TextEditingController();

  @override
  void dispose() {
    passCtrl.dispose();
    confirmCtrl.dispose();
    super.dispose();
  }

  String? _validatePassword(String? v) {
    if (v == null || v.isEmpty) return 'حقل كلمة المرور مطلوب';
    if (v.length < 6) return 'يجب أن تكون كلمة المرور 6 أحرف على الأقل';
    return null;
  }

  String? _validateConfirm(String? v) {
    if (v == null || v.isEmpty) return 'يرجى تأكيد كلمة المرور';
    if (v != passCtrl.text) return 'كلمتا المرور غير متطابقتين';
    return null;
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    final newPass = passCtrl.text;
    context.read<AuthCubit>().resetPassword(newPass,widget.token);
  }

  @override
  Widget build(BuildContext context) {
    final height= MediaQuery.of(context).size.height;
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthResetSuccess) {
          showSnackBar(context,state.message, '', 'success');
          // after password reset, navigate to login
          context.go('/login');
        } else if (state is AuthResetError) {
          showSnackBar(context,state.message, '', 'failure');
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text('إنشاء كلمة مرور جديدة',
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
                  Text('أدخل كلمة المرور الجديدة',
                      style: TextStyle(
                          fontSize: 4.sw, color: AppColors.textLightColor),
                      textAlign: TextAlign.center),
                  SizedBox(height: 4.sh),
                  CustomTextField(
                    hintText: 'كلمة المرور الجديدة',
                    controller: passCtrl,
                    obscureText: true,
                    validator: _validatePassword, height: height,
                  ),
                  SizedBox(height: 2.sh),
                  CustomTextField(
                    hintText: 'تأكيد كلمة المرور',
                    controller: confirmCtrl,
                    obscureText: true,
                    validator: _validateConfirm,
                    height: height,
                  ),
                  SizedBox(height: 3.sh),
                  BlocBuilder<AuthCubit, AuthState>(
                    builder: (context, state) {
                      final isLoading = state is AuthResetLoading;
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
                                txt: 'حفظ',
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
