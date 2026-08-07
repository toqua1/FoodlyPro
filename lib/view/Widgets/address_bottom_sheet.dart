import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../../../Services/Storage/shared_preferences_service.dart';
import '../../../../core/theme/colors.dart';
import '../../../../data/models/address_model.dart';

class AddressBottomSheet extends StatelessWidget {
  const AddressBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    // استخدم FutureBuilder لقراءة العنوان من SharedPreferences بشكل غير متزامن
    return FutureBuilder<AddressModel?>(
      future: UserData().readDefaultAddressFromPrefs(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox(
            height: 200,
            child: Center(child: Skeletonizer(enabled: true,child: Text('c,,vzd,'
                'vm'))),
          );
        }

        if (snapshot.hasError || !snapshot.hasData || snapshot.data == null) {
          return SizedBox(
            height: 200,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'لا يوجد عنوان افتراضي.',
                      style: TextStyle(fontSize: 4.sw, color: AppColors.textColor),
                    ),
                    SizedBox(height: 4.sw),
                    ElevatedButton(
                      onPressed: () {
                        context.pop();
                        context.push('/address');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.secondaryColor,
                      ),
                      child: Text('إضافة عنوان', style: TextStyle(color: Colors.white, fontSize: 3.5.sw)),
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        final address = snapshot.data!;
        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'العنوان الافتراضي',
                      style: TextStyle(
                        fontSize: 5.sw,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textColor,
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.edit, color: AppColors.primaryColor, size: 4.5.sw),
                      onPressed: () {
                        context.pop();
                        context.push('/address');
                      },
                    ),
                  ],
                ),
                 Divider(color: Colors.grey.shade300,radius: BorderRadius.circular(16),),
                SizedBox(height: 2.sw),
                Text(
                  'مدينة ${address.city}, شارع ${address.street}, '
                      'مبنى ${address.building}, '
                      ' طابق ${address.floor}, شقة ${address.apartment}',
                  style: TextStyle(fontSize: 4.sw, color: AppColors.textLightColor),
                ),
                Text(
                  address.city,
                  style: TextStyle(fontSize: 4.sw, color: AppColors.textLightColor),
                ),
                SizedBox(height: 4.sw),
              ],
            ),
          ),
        );
      },
    );
  }
}