import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:elmaleka_kitchen_project/data/datasources/endpoints.dart';
import 'package:elmaleka_kitchen_project/data/models/address_model.dart';
import '../../Services/Storage/shared_preferences_service.dart';
import '../../core/errors/app_error.dart';
import '../../core/errors/error_handler.dart';

class AddressRemoteDataSource{
  final Dio dio;
  const AddressRemoteDataSource(this.dio);
 Future<List<AddressModel>> getAddresses() async {
   try {
     final response = await dio.get(ApiEndpoints.handleAddressesEndpoint);
     final addresses = (response.data as List).map((e) =>
         AddressModel.fromJson(e)
     ).toList();

     if (addresses.isNotEmpty) {
       final defaultAddr = addresses.firstWhere(
             (a) => a.isDefault == true,
         orElse: () => addresses.first,
       );

       await UserData().saveDefaultAddressToPrefs(defaultAddr);
       log('Saved default address to prefs: ${defaultAddr.toJson()}',
           name: 'AddressRemoteDataSource');
     } else {
       log('No addresses returned from API', name: 'AddressRemoteDataSource');
     }
     return addresses;
   } catch (e) {
     if (e is DioError) {
       if (e.error is AppError) throw e.error as AppError;
       throw ErrorHandler.handle(e);
     }
     throw ErrorHandler.handle(e);
   }
 }
 Future<void> createAddress(AddressModel model) async{
   try{
     await dio.post(ApiEndpoints.handleAddressesEndpoint,
         data: model.toJson(),
     );
   }catch(e){
     if (e is DioError) {
       if (e.error is AppError) throw e.error as AppError;
       throw ErrorHandler.handle(e);
     }
     throw ErrorHandler.handle(e);
   }
 }

  Future<void> updateAddress(AddressModel model) async{
    try{
      await dio.patch('${ApiEndpoints.handleAddressesEndpoint}/${model.id}',
        data: model.toJson(),
      );
    }catch(e){
      if (e is DioError) {
        if (e.error is AppError) throw e.error as AppError;
        throw ErrorHandler.handle(e);
      }
      throw ErrorHandler.handle(e);
    }
  }

  Future<void> deleteAddress(int addressId) async{
    try{
      await dio.delete('${ApiEndpoints.handleAddressesEndpoint}/$addressId',
      );
    }catch(e){
      if (e is DioError) {
        if (e.error is AppError) throw e.error as AppError;
        throw ErrorHandler.handle(e);
      }
      throw ErrorHandler.handle(e);
    }
  }
  
}