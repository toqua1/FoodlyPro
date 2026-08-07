import 'dart:developer';
import 'package:elmaleka_kitchen_project/core/theme/colors.dart';
import 'package:elmaleka_kitchen_project/view_model/Auth/auth_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../../Services/Storage/shared_preferences_service.dart';
import '../../../core/Utils/is_tablet_service.dart';
import '../../../data/models/address_model.dart';
import '../../../data/models/user_model.dart';
import '../../../view_model/Profile/profile_cubit.dart';
import '../../Widgets/primary_button.dart';
import '../../Widgets/cart_icon.dart';
import '../../Widgets/try_again_section.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  Future<void> _loadDefaultAddress() async {
    try {
      final AddressModel? defAddMod = await UserData().readDefaultAddressFromPrefs();
      if (mounted) {
        if (defAddMod != null) {
          addressCtrl.text =
          '${defAddMod.city}, ${defAddMod.street}, ${defAddMod.building}, ${defAddMod.floor}, ${defAddMod.apartment}';
        } else {
          addressCtrl.text = 'لا يوجد عناوين محفوظة';
        }
      }
    } catch (e) {
      log('Error loading default address: $e');
      if (mounted) {
        addressCtrl.text = 'خطأ في تحميل العنوان';
      }
    }
  }

  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameCtrl = TextEditingController();
  final TextEditingController emailCtrl = TextEditingController();
  final TextEditingController phoneCtrl = TextEditingController();
  final TextEditingController addressCtrl = TextEditingController();
  bool _isEditing = false;

  // Create a dummy user model for the skeleton loading state
  final UserModel _dummyUser = UserModel(
    id: 0,
    name: 'Sample Name',
    email: 'sample@email.com',
    phone: '0123456789', createdAt: DateTime.now(),
  );

  @override
  void initState() {
    super.initState();
    // Fetch profile data when the screen is initialized
    context.read<ProfileCubit>().getProfile();
  }

  @override
  void dispose() {
    nameCtrl.dispose();
    emailCtrl.dispose();
    phoneCtrl.dispose();
    addressCtrl.dispose();
    super.dispose();
  }

  void _submit(UserModel currentUser,BuildContext cont) {
    if (!_formKey.currentState!.validate()) return;

    final updatedUser = currentUser.copyWith(
      name: nameCtrl.text.trim(),
      email: emailCtrl.text.trim(),
      phone: phoneCtrl.text.trim(),
    );

    context.read<ProfileCubit>().editProfile(updatedUser,cont);
  }

  void _toggleEdit(UserModel user) {
    setState(() {
      _isEditing = !_isEditing;
      if (!_isEditing) {
        // If canceling, reset text fields to original values
        nameCtrl.text = user.name ?? '';
        emailCtrl.text = user.email ?? '';
        phoneCtrl.text = user.phone ?? '';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text(
          "معلوماتي",
          style: TextStyle(fontSize: 5.5.sw, fontWeight: FontWeight.bold),
        ),
        actions: const [CartIcon()],
      ),
      body: BlocConsumer<ProfileCubit, ProfileState>(
        listener: (context, state) {
          if (state is ProfileLoaded) {
            // Update text fields when profile data is loaded or updated
            nameCtrl.text = state.user.name ?? '';
            emailCtrl.text = state.user.email ?? '';
            phoneCtrl.text = state.user.phone ?? '';

            _loadDefaultAddress();

            setState(() {
              _isEditing = false;
            });
            // showSnackBar(context, 'تم تحديث البيانات بنجاح', '', 'success');
          } else if (state is ProfileError) {
            // showSnackBar(context, 'خطأ', state.message, 'failure');
          }
        },
        builder: (context, state) {
          if (state is ProfileError) {
            return TryAgainSection(
                message: state.message,
                method: () => context.read<ProfileCubit>().getProfile());
          }

          final bool isLoading = state is ProfileLoading;
          final UserModel user = isLoading ? _dummyUser : (state as ProfileLoaded).user;

          return Skeletonizer(
            enabled: isLoading,
            child: _buildProfileContent(context, user, isLoading),
          );
        },
      ),
    );
  }

  Widget _buildProfileContent(BuildContext context, UserModel user,
      bool isLoading) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 4.sw),
      child: Center(
        child: Column(
          children: [
            SizedBox(height: 2.sh),
            Stack(
              alignment: Alignment.center,
              children: [
                CircleAvatar(
                  backgroundColor: Colors.grey.shade200,
                  foregroundColor: AppColors.secondaryColor,
                  radius: isTablet(context) ? 8.sw : 15.sw,
                  child: Icon(Icons.person_rounded, size: 10.sw),
                ),
              ],
            ),
            SizedBox(height: 1.sh),
            TextButton.icon(
              onPressed: () => _toggleEdit(user),
              icon: Icon(
                _isEditing ? Icons.close : Icons.edit,
                size: 5.sw,
                color: AppColors.secondaryColor,
              ),
              label: Text(
                _isEditing ? "إلغاء" : "تعديل البيانات",
                style: TextStyle(
                  color: AppColors.secondaryColor,
                  fontSize: isTablet(context) ? 3.sw : 4.sw,
                ),
              ),
            ),
            SizedBox(height: 0.5.sh),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  Text(
                    " مرحباً ${user.name}",
                    style: TextStyle(
                        fontSize: isTablet(context) ? 4.sw : 5.sw,
                        fontWeight: FontWeight.w600),
                  ),
                  SizedBox(height: 1.sh),
                  InkWell(
                    onTap: () async {
                      await context.read<AuthCubit>().logout();
                      context.go('/firstAuth');
                    },
                    child: Text("تسجيل الخروج",
                        style: TextStyle(
                            color: AppColors.textLightColor,
                            fontSize: isTablet(context) ? 3.sw : 4.sw)),
                  ),
                  !_isEditing ? SizedBox(height: 7.sh) : SizedBox(height: 2.sh),
                  _buildTextFieldRow("الاسم :", nameCtrl, context, enabled: _isEditing),
                  _buildTextFieldRow("رقم الهاتف :", phoneCtrl, context,
                      keyboard: TextInputType.phone, enabled: _isEditing),
                  _buildTextFieldRow("البريد الالكتروني :", emailCtrl, context,
                      keyboard: TextInputType.emailAddress, enabled:
                      _isEditing,isEmail: true),
                  _buildTextFieldRow("العنوان :", addressCtrl, context,
                      enabled: _isEditing, isAddress: true),
                  SizedBox(height: 5.sh),
                  if (_isEditing)
                    PrimaryButton(
                      color: AppColors.secondaryColor,
                      txt: isLoading ?
                    'جاري الحفظ...' : 'حفظ',
                      method: () => _submit(user,context),
                    ),
                  SizedBox(height: 2.sh),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextFieldRow(String label, TextEditingController controller, BuildContext context,
      {TextInputType? keyboard, bool enabled = false, bool isAddress = false,
        bool isEmail =false
      }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 1.sh),
      child: Row(
        children: [
          Text(label,
              style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: isTablet(context) ? 3.sw : 4.sw)),
          SizedBox(width: 10),
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 1.2.sh, horizontal: 4.sw),
              decoration: BoxDecoration(
                color: (enabled && !isAddress && !isEmail) ? Colors.white : Colors
                    .grey[200],
                borderRadius: BorderRadius.circular(30),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: controller,
                      enabled: enabled && !isAddress && !isEmail,
                      keyboardType: keyboard,
                      textAlign: TextAlign.right,
                      decoration: InputDecoration.collapsed(
                        hintText: '',
                        hintStyle: TextStyle(fontSize: isTablet(context) ? 3.sw : 4.sw),
                      ),
                      // validator: (v) {
                      //   if (isAddress || isEmail) return null;
                      //
                      //   if (label.contains('البريد')) {
                      //     if (v == null || v.trim().isEmpty) {
                      //       return 'حقل البريد الإلكتروني مطلوب';
                      //     }
                      //     final emailRegex = RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$");
                      //     if (!emailRegex.hasMatch(v.trim())) {
                      //       return 'رجاءً أدخل بريدًا إلكترونيًا صالحًا';
                      //     }
                      //   } else {
                      //     if (v == null || v.trim().isEmpty) return 'هذا الحقل مطلوب';
                      //   }
                      //   return null;
                      // },
                      style: TextStyle(fontSize: isTablet(context) ? 3.sw :
              4.sw),
                    ),
                  ),
                  isAddress
                      ? ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: AppColors.secondaryColor),
                    onPressed: () async {
                      // Make the navigation call asynchronous and wait for it to complete.
                      await context.push('/address');
                      // After the user returns, refresh the default address.
                      await _loadDefaultAddress();
                    },
                    icon: Icon(Icons.list_rounded, size: 4.sw),
                    label: Text('العناوين', style: TextStyle(fontSize: 3.sw)),
                  )
                      : SizedBox()
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
