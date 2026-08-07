import 'package:elmaleka_kitchen_project/core/theme/colors.dart';
import 'package:elmaleka_kitchen_project/data/models/address_model.dart';
import 'package:elmaleka_kitchen_project/view/Widgets/snack_bar.dart';
import 'package:elmaleka_kitchen_project/view_model/Address/address_cubit.dart';
import 'package:elmaleka_kitchen_project/view_model/Profile/profile_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:responsive_builder/responsive_builder.dart';
import '../../../core/Utils/is_tablet_service.dart';
import '../../Widgets/primary_button.dart';

class AddressDetailsScreen extends StatefulWidget {
  final AddressModel? address;
  const AddressDetailsScreen({super.key, this.address});

  @override
  State<AddressDetailsScreen> createState() => _AddressDetailsScreenState();
}

class _AddressDetailsScreenState extends State<AddressDetailsScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController cityCtrl = TextEditingController();
  final TextEditingController streetCtrl = TextEditingController();
  final TextEditingController buildingCtrl = TextEditingController();
  final TextEditingController floorCtrl = TextEditingController();
  final TextEditingController apartmentCtrl = TextEditingController();
  final TextEditingController noteCtrl = TextEditingController();

  late bool isEditing;

  @override
  void initState() {
    super.initState();
    isEditing = widget.address != null;
    if (isEditing) {
      // Pre-fill TextFields if editing an existing address
      cityCtrl.text = widget.address!.city;
      streetCtrl.text = widget.address!.street;
      buildingCtrl.text = widget.address!.building;
      floorCtrl.text = widget.address!.floor;
      apartmentCtrl.text = widget.address!.apartment;
      noteCtrl.text = widget.address!.note;
    }
  }

  @override
  void dispose() {
    cityCtrl.dispose();
    streetCtrl.dispose();
    buildingCtrl.dispose();
    floorCtrl.dispose();
    apartmentCtrl.dispose();
    noteCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    final newAddress = AddressModel(
      id: isEditing ? widget.address!.id : 0, // Use existing ID or 0 for new
      city: cityCtrl.text.trim(),
      street: streetCtrl.text.trim(),
      building: buildingCtrl.text.trim(),
      floor: floorCtrl.text.trim(),
      apartment: apartmentCtrl.text.trim(),
      note: noteCtrl.text.trim(),
      isDefault: isEditing ? widget.address!.isDefault : false,
    );

    if (isEditing) {
      context.read<AddressCubit>().updateAddress(newAddress);
    } else {
      context.read<AddressCubit>().createAddress(newAddress);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: Icon(Icons.arrow_back_ios, size: 5.sw, color: Colors.black),
        ),
        title: Text(
          isEditing ? "تعديل العنوان" : "إضافة عنوان جديد",
          style: TextStyle(fontSize: 5.5.sw, fontWeight: FontWeight.bold),
        ),
      ),
      body: BlocListener<AddressCubit, AddressState>(
        listener: (context, state) {
          if (state is AddressLoaded) {
            context.pop();
            // context.read<AddressCubit>().fetchAddresses();
          } else if (state is AddressError) {
            showSnackBar(context, 'خطأ', state.message, 'failure');
          }
        },
        child: SingleChildScrollView(
          padding: EdgeInsets.all(4.sw),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildAddressTextField(
                  controller: cityCtrl,
                  label: "المدينة",
                  icon: Icons.location_city_rounded,
                  validator: (v) => v!.isEmpty ? 'المدينة مطلوبة' : null,
                ),
                _buildAddressTextField(
                  controller: streetCtrl,
                  label: "الشارع",
                  icon: Icons.streetview_rounded,
                  validator: (v) => v!.isEmpty ? 'الشارع مطلوب' : null,
                ),
                _buildAddressTextField(
                  controller: buildingCtrl,
                  label: "رقم المبني",
                  icon: Icons.home_rounded,
                  keyboard: TextInputType.number,
                  validator: (v) => v!.isEmpty ? 'رقم المبني مطلوب' : null,
                ),
                _buildAddressTextField(
                  controller: floorCtrl,
                  label: "الطابق",
                  icon: Icons.layers_rounded,
                  keyboard: TextInputType.number,
                  validator: (v) => v!.isEmpty ? 'الطابق مطلوب' : null,
                ),
                _buildAddressTextField(
                  controller: apartmentCtrl,
                  label: "الشقة",
                  icon: Icons.apartment_rounded,
                  keyboard: TextInputType.number,
                  validator: (v) => v!.isEmpty ? 'الشقة مطلوبة' : null,
                ),
                _buildAddressTextField(
                  controller: noteCtrl,
                  label: "ملاحظات",
                  icon: Icons.note_rounded,
                  isOptional: true,
                ),
                SizedBox(height: 5.sh),
                BlocBuilder<AddressCubit, AddressState>(
                  builder: (context, state) {
                    final isLoading = state is AddressLoading;
                    return PrimaryButton(
                      color: AppColors.secondaryColor,
                      txt: isLoading
                          ? 'جاري الحفظ...'
                          : isEditing
                              ? 'حفظ التعديلات'
                              : 'إضافة العنوان',
                      method: isLoading ? () {} : _submit,
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAddressTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboard = TextInputType.text,
    String? Function(String?)? validator,
    bool isOptional = false,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 1.sh),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboard,
        textAlign: TextAlign.right,
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: AppColors.secondaryColor),
          labelText: label,
          labelStyle: TextStyle(
            fontSize: isTablet(context) ? 3.sw : 4.sw,
            fontWeight: FontWeight.w500,
          ),
          filled: true,
          fillColor: Colors.grey[200],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none,
          ),
          contentPadding: EdgeInsets.symmetric(
            vertical: 2.sh,
            horizontal: 4.sw,
          ),
        ),
        validator: isOptional ? null : validator,
      ),
    );
  }
}
