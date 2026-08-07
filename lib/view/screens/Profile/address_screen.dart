import 'dart:developer';
import 'package:elmaleka_kitchen_project/Services/Storage/shared_preferences_service.dart';
import 'package:elmaleka_kitchen_project/core/Utils/dummy_products.dart';
import 'package:elmaleka_kitchen_project/core/theme/colors.dart';
import 'package:elmaleka_kitchen_project/data/models/address_model.dart';
import 'package:elmaleka_kitchen_project/view/Widgets/try_again_section.dart';
import 'package:elmaleka_kitchen_project/view/screens/Home/Home%20Widgets/new_food_section.dart';
import 'package:elmaleka_kitchen_project/view_model/Address/address_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:skeletonizer/skeletonizer.dart';

class AddressScreen extends StatelessWidget {
  const AddressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title:   Text(
          'العناوين الخاصة بك',
          style: TextStyle(fontSize: 6.sw, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(onPressed:()=> context.pop(), icon: Icon(Icons
            .arrow_back_ios_rounded,size: 6.sw,)),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 2.sw, vertical: 2.sh),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 2.sh),
              Expanded(
                child: BlocConsumer<AddressCubit, AddressState>(
                  listener: (context, state) {
                    if (state is AddressLoaded) {
                      final defaultAddress = state.addresses.firstWhere(
                            (address) => address.isDefault,
                        orElse: () => AddressModel(
                          id: -1,
                          city: '', street: '', building: '',
                          floor: '', apartment: '', note: '', isDefault: false,
                        ),
                      );
                      if (defaultAddress.id != -1) {
                        UserData().saveDefaultAddressToPrefs(defaultAddress);
                      } else {
                        UserData().clearDefaultInPrefs();
                      }
                    }
                  },
                  builder: (context, state) {
                    if (state is AddressLoading) {
                      return SingleChildScrollView(
                        child: Skeletonizer(enabled: true,child: TodayDishSection
                          (itemsFamous: getDummyProducts(5))),
                      );
                    } else if (state is AddressLoaded) {
                      if (state.addresses.isEmpty) {
                        return Center(
                          child: Text(
                            'لا يوجد عناويين محفوظة',
                            style: TextStyle(fontSize: 4.sw),
                          ),
                        );
                      } else {
                        final defaultAddress = state.addresses.firstWhere(
                              (address) => address.isDefault,
                          orElse: () => AddressModel(
                            id: -1, city: '', street: '', building: '',
                            floor: '', apartment: '', note: '', isDefault: false,
                          ),
                        );

                        return ListView.separated(
                          itemBuilder: (context, index) {
                            final item = state.addresses[index];
                            return Card(
                              color: Colors.grey.shade100,
                              shadowColor: Colors.grey,
                              child: ListTile(
                                leading: Icon(
                                  Icons.location_on_rounded,
                                  size: 6.sw,
                                ),
                                title: Text(
                                  'مدينة ${item.city}, شارع ${item.street}, '
                                      'مبنى ${item.building}, '
                                      ' طابق ${item.floor}, شقة ${item.apartment}',
                                  style: TextStyle(fontSize: 4.sw),
                                ),
                                subtitle: Text(
                                  'Note: ${item.note}',
                                  style: TextStyle(
                                      fontSize: 4.sw,
                                      color: AppColors.textLightColor),
                                ),
                                // Pass the default address directly from the state
                                trailing: TrailingButtons(
                                  defAdd: defaultAddress,
                                  item: item, addressesCount: state.addresses.length,
                                ),
                              ),
                            );
                          },
                          separatorBuilder: (_, __) => SizedBox(height: 1.sh),
                          itemCount: state.addresses.length,
                        );
                      }
                    } else if (state is AddressError) {
                      log(state.message);
                      return TryAgainSection(message: state.message, method:
                          ()=>context.read<AddressCubit>().fetchAddresses());
                    } else {
                      return SizedBox();
                    }
                  },
                ),
              ),
              SizedBox(height: 1.sh),
              SizedBox(
                width: 70.sw,
                height: 6.sh,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey.shade100,
                        foregroundColor: AppColors.secondaryColor),
                    onPressed: () => context.push('/address-details'),
                    child: Text(
                      'أضف '
                          'عنوان',
                      style: TextStyle(fontSize: 4.sw, fontWeight: FontWeight.bold),
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TrailingButtons extends StatelessWidget {
  const TrailingButtons({
    super.key,
    required this.defAdd,
    required this.item, required this.addressesCount,
  });

  final AddressModel? defAdd;
  final AddressModel item;
  final int addressesCount; // The total number of addresses

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          defAdd!.id == item.id
              ? Text(
            'العنوان الافتراضي',
            style: TextStyle(
                fontSize: 3.sw,
                fontWeight: FontWeight.bold,
                color: Colors.green),
          )
              : SizedBox(),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                  onPressed: () =>
                      context.push('/address-details', extra: item),
                  icon: Icon(
                    Icons.edit_rounded,
                    size: 6.sw,
                  )),
              defAdd!.id != item.id
                  ? IconButton(
                  onPressed: (){
                    context.read<AddressCubit>().updateAddress(AddressModel(
                        id: item.id,
                        city: item.city,
                        street: item.street,
                        isDefault: !item.isDefault,
                        // isDefault: true,
                        apartment: item.apartment,
                        building: item.building,
                        floor: item.floor,
                        note: item.note));
                    // context.read<AddressCubit>().fetchAddresses();
                  },
                  icon: Icon(
                    Icons.add,
                    size: 6.sw,
                    color: Colors.green,
                  ))
                  : SizedBox(),
              // Only show the delete icon if there is more than one address
              if (addressesCount > 1)
                IconButton(
                    onPressed: () {
                      context.read<AddressCubit>().deleteAddress(item.id);
                    },
                    icon: Icon(
                      Icons.delete_rounded,
                      size: 6.sw,
                      color: Colors.red,
                    )),
            ],
          ),
        ],
      ),
    );
  }
}
