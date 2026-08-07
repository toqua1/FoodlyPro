import 'package:elmaleka_kitchen_project/view/Widgets/snack_bar.dart';
import 'package:elmaleka_kitchen_project/view_model/Auth/auth_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:responsive_builder/responsive_builder.dart';
import '../../../core/Utils/is_tablet_service.dart';
import '../../../core/theme/colors.dart';
import '../../../data/models/user_model.dart';
import '../../Widgets/custom_textfield.dart';
import '../../Widgets/have_account_part.dart';
import '../../Widgets/primary_button.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();

  // controllers
  final TextEditingController emailCtrl = TextEditingController();
  final TextEditingController passCtrl = TextEditingController();
  // final TextEditingController confirmPassCtrl = TextEditingController();
  final TextEditingController nameCtrl = TextEditingController();
  final TextEditingController phoneCtrl = TextEditingController();

  @override
  void dispose() {
    emailCtrl.dispose();
    passCtrl.dispose();
    // confirmPassCtrl.dispose();
    nameCtrl.dispose();
    phoneCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    final name = nameCtrl.text.trim();
    final email = emailCtrl.text.trim();
    final phone = phoneCtrl.text.trim();
    final password = passCtrl.text;

    final userModel = UserModel(
      id: 0,
      name: name,
      email: email,
      phone: phone,
      createdAt: DateTime.now(),
    );

    context.read<AuthCubit>().register(userModel,password);
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

  String? _validateConfirmPassword(String? v) {
    if (v == null || v.isEmpty) return 'يرجى تأكيد كلمة المرور';
    if (v != passCtrl.text) return 'كلمتا المرور غير متطابقتين';
    return null;
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthRegisterSuccess) {
          showSnackBar(context,'تم التسجيل بنجاح', '', 'success');
          context.go('/login');
        } else if (state is AuthError) {
          showSnackBar(context,'خطأ',state.message, 'failure');
        }
      },
      child: SafeArea(
        child: Scaffold(
          body: Center(
            child: Padding(
              padding: EdgeInsetsDirectional.symmetric(horizontal: 5.sw),
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Text(
                        'التسجيل',
                        style: TextStyle(fontSize: 3.6.sh),
                      ),
                      SizedBox(
                        height: 0.5.sh,
                      ),
                      Text(
                        'أضف التفاصيل الخاصة بك للتسجيل',
                        style: TextStyle(
                            color: AppColors.textLightColor, fontSize: 2.sh),
                      ),
                      SizedBox(
                        height: 3.sh,
                      ),
                      CustomTextField(
                        hintText: 'الاسم ',
                        height: height,
                        controller: nameCtrl,
                        validator: (v) => _validateNotEmpty(v, 'الاسم'),
                      ),
                      SizedBox(
                        height: 2.sh,
                      ),
                      CustomTextField(
                        hintText: 'البريد الالكتروني ',
                        height: height,
                        controller: emailCtrl,
                        validator: (v) => _validateEmail(v),
                      ),
                      SizedBox(
                        height: 2.sh,
                      ),
                      CustomTextField(
                        hintText: 'رقم الجوال ',
                        height: height,
                        controller: phoneCtrl,
                        validator: (v) {
                          final r = _validateNotEmpty(v, 'رقم الجوال');
                          if (r != null) return r; /*return error message*/
                          if (v!.replaceAll(RegExp(r'\D'), '').length < 9) return 'رقم جوال غير صالح'; return null;
                        },
                      ),
                      SizedBox(
                        height: 2.sh,
                      ),
                      // CustomTextField(hintText:'العنوان ', height: height,controller:
                      // addressCtrl,),
                      // SizedBox(
                      //   height: 2.sh,
                      // ),
                      CustomTextField(
                        hintText: 'كلمة المرور',
                        height: height,
                        controller: passCtrl,
                        obscureText: true,
                        validator: (v) => _validatePassword(v),
                      ),
                      SizedBox(
                        height: 2.sh,
                      ),
                      CustomTextField(
                        hintText: 'تاكيد كلمة السر',
                        height: height,
                        obscureText: true,
                        validator: (v) => _validateConfirmPassword(v),
                      ),
                      SizedBox(
                        height: 3.sh,
                      ),
        
                      //sign up button
                      BlocBuilder<AuthCubit, AuthState>(
                        builder: (context, state) {
                          final isLoading = state is AuthLoading;
                          return SizedBox(
                            height:isTablet(context)?9.sh :7.sh,
                            width:isTablet(context)?70.sw : 85.sw,
                            child: isLoading
                                // show disabled-looking button with spinner
                                ? ElevatedButton(
                                    onPressed: null,
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: AppColors.primaryColor,),
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
                        height: 4.sh,
                      ),
                      HaveAccountPart(
                          method: () => context.push('/login'),
                          txt1: 'هل لديك حساب بالفعل؟ ',
                          txt2: ' تسجيل الدخول'),
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
