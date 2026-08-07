import 'package:bloc/bloc.dart';
import 'package:elmaleka_kitchen_project/data/datasources/address_remote_datasource.dart';
import 'package:elmaleka_kitchen_project/data/models/address_model.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import '../../Services/Storage/shared_preferences_service.dart';
import '../../core/errors/app_error.dart';
import '../../core/errors/error_handler.dart';

part 'address_state.dart';

class AddressCubit extends Cubit<AddressState> {
  final AddressRemoteDataSource addressRemoteDataSource;
  AddressCubit(this.addressRemoteDataSource) : super(AddressInitial());

  Future<void> fetchAddresses() async {
    if (state is AddressLoaded) {
      final loadedState = state as AddressLoaded;
      if (loadedState.addresses.isNotEmpty) {
        return;
      }
    }
    emit(AddressLoading());
    try {
      final addresses = await addressRemoteDataSource.getAddresses();
      emit(AddressLoaded(addresses));
    } catch (e) {
      final appErr = e is AppError ? e : ErrorHandler.handle(e);
      emit(AddressError(appErr.message));
    }
  }

  Future<void> createAddress(AddressModel model) async {
    emit(AddressLoading());
    try {
      await addressRemoteDataSource.createAddress(model);
      await fetchAddresses(); // This correctly emits AddressLoaded
    } catch (e) {
      final appErr = e is AppError ? e : ErrorHandler.handle(e);
      emit(AddressError(appErr.message));
    }
  }

  Future<void> updateAddress(AddressModel model) async {
    emit(AddressLoading());
    try {
      await addressRemoteDataSource.updateAddress(model);
      await fetchAddresses(); // This correctly emits AddressLoaded
    } catch (e) {
      final appErr = e is AppError ? e : ErrorHandler.handle(e);
      emit(AddressError(appErr.message));
    }
  }

  Future<void> deleteAddress(int addressId) async {
    emit(AddressLoading());
    try {
      final defaultFromPrefs = await UserData().readDefaultAddressFromPrefs();
      if (defaultFromPrefs != null && defaultFromPrefs.id == addressId) {
        await UserData().clearDefaultInPrefs();
      }

      await addressRemoteDataSource.deleteAddress(addressId);
      await fetchAddresses(); // This correctly emits AddressLoaded
    } catch (e) {
      final appErr = e is AppError ? e : ErrorHandler.handle(e);
      emit(AddressError(appErr.message));
    }
  }
}
