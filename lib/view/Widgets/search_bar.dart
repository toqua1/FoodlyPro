import 'package:elmaleka_kitchen_project/view_model/Home/Search/search_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_builder/responsive_builder.dart';
import '../../core/theme/colors.dart';

class CustomSearchBar extends StatelessWidget {
  const CustomSearchBar({
    super.key, required this.controller,
  });
final TextEditingController controller ;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.symmetric(horizontal: 3.sw,vertical: 2.sh),
      child: TextField(
        style: TextStyle(fontSize: 4.sw),
        controller: controller,
        autofocus: true,
        onChanged: (text) => context.read<SearchCubit>().queryChanged(text),
        decoration: InputDecoration(
            hintText: 'البحث عن الطعام',
            hintStyle: TextStyle(
                color: AppColors.loginGreyColor,
                fontSize: 4.sw
            ),
            prefixIcon: Icon(Icons.search,size: 5.sw,color: AppColors.loginGreyColor,),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.sw),
              borderSide: BorderSide.none,
            ),
            filled: true,
            fillColor: AppColors.textFieldFillColor
        ),
      ),
    );
  }
}
