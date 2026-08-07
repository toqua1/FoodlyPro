import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';
import '../../core/Utils/is_tablet_service.dart';
import '../../core/theme/colors.dart';

class CustomTextField extends StatefulWidget {
  final String hintText;
  final double height;
  final TextEditingController? controller;
  final IconData? icon;
  final bool obscureText;
  final String? Function(String?)? validator;
  final void Function(String)? onChangedCallback;

  const CustomTextField({
    this.controller,
    this.icon,
    this.validator,
    this.onChangedCallback,
    super.key,
    this.obscureText = false,
    required this.hintText,
    required this.height,
  });

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _obscureText = false;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      textDirection: TextDirection.rtl,
      // onChanged: widget.onChangedCallback,
      // onTapOutside: (event) {
      //   FocusManager.instance.primaryFocus?.unfocus();
      // },
      onEditingComplete: () {
        FocusScope.of(context).nextFocus();
      },
      controller: widget.controller,
      obscureText: widget.obscureText && !_obscureText,
      validator: widget.validator,
      decoration: InputDecoration(
        hintText: widget.hintText,
        fillColor: AppColors.textFieldFillColor,
        filled: true,
        hintStyle: TextStyle(
          fontSize: isTablet(context) ? widget.height * 0.025 : null,
          color: AppColors.loginGreyColor
        ),
        prefixIcon: widget.icon != null ? Icon(widget.icon) : null,
        prefixIconColor: Colors.grey,
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.sw),
            borderSide: BorderSide.none),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.sw),
            borderSide: BorderSide.none),
        suffixIcon: widget.obscureText
            ? IconButton(
          icon: Icon(
            _obscureText ? Icons.visibility_rounded : Icons.visibility_off_rounded,
            color: Colors.grey,
            size: isTablet(context)? 5.sw:null,
          ),
          onPressed: () {
            setState(() {
              _obscureText = !_obscureText;
            });
          },
        )
            : null,
      ),
    );
  }
}