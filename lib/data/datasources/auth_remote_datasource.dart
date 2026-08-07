import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:elmaleka_kitchen_project/Services/Storage/secure_storage_service.dart';
import 'package:elmaleka_kitchen_project/core/errors/error_handler.dart';
import 'package:elmaleka_kitchen_project/data/datasources/endpoints.dart';
import 'package:elmaleka_kitchen_project/data/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/errors/app_error.dart';

class AuthRemoteDatasource {
  final Dio dio;
  const AuthRemoteDatasource(this.dio);

  Future<void> setUserName(String name)async{
    final prefs=await SharedPreferences.getInstance();
    await prefs.setString('userName', name);
  }

  Future<String?> getStoredName() async{
    final prefs=await SharedPreferences.getInstance();
    return prefs.getString('userName');
  }

  Future<void> setUserEmail(String email)async{
    final prefs=await SharedPreferences.getInstance();
    await prefs.setString('userEmail', email);
  }

  Future<String?> getStoredEmail() async{
    final prefs=await SharedPreferences.getInstance();
    return prefs.getString('userEmail');
  }

  Future<void> setUserPhone(String phone)async{
    final prefs=await SharedPreferences.getInstance();
    await prefs.setString('userPhone', phone);
  }

  Future<String?> getStoredPhone() async{
    final prefs=await SharedPreferences.getInstance();
    return prefs.getString('userPhone');
  }

  // Check if logged in
  Future<bool> isLoggedIn() async {
    final token = await SecureStorageService().getToken();
    return token != null && token.isNotEmpty;
  }

  Future<void> loginUser(String email, String pass) async {
    try{
     final res=
     await dio.post(ApiEndpoints.authLogin, data: {
          "email" : email,
          "password" : pass
      });

      final token = res.data['accessToken'];
     await SecureStorageService().saveToken(token);
     await SecureStorageService().savePassword(pass);
     await setUserEmail(res.data['user']['email']);
     await setUserName(res.data['user']['name']);
     await setUserPhone(res.data['user']['phone']);
      // return UserResponse.fromJson(res.data);
    }catch(e){
      if (e is DioError) {
        if (e.error is AppError) throw e.error as AppError;
        throw ErrorHandler.handle(e);
      }
      throw ErrorHandler.handle(e);
    }
  }

  Future<void> registerUser(UserModel user,String pass) async {
    try {
      // final res =
          await dio.post(ApiEndpoints.authRegister, data: user.toJson(pass));
      // return UserResponse.fromJson(res.data);

    } catch (e) {
      if (e is DioError) {
        if (e.error is AppError) throw e.error as AppError;
        throw ErrorHandler.handle(e);
      }
      throw ErrorHandler.handle(e);
    }
  }

  Future<void> resetPassword(String newPass,String token) async {
    /*return message*/
    try {
       await dio.post(ApiEndpoints.authResetPass, data: {
          "newPassword" : newPass
      },options: Options(
        headers: {
          'Authorization': 'Bearer $token'
        }
      ));
      // return res.data['message'];
    } catch (e) {
      if (e is DioError) {
        if (e.error is AppError) throw e.error as AppError;
        throw ErrorHandler.handle(e);
      }
      throw ErrorHandler.handle(e);
    }
  }

  Future<String> otpRequest(String email) async {
    try {
      final res =await dio.post(ApiEndpoints.authOtpRequest,data: {
        "email": email
      });
      return res.data['token'];
    } catch (e) {
      if (e is DioError) {
        if (e.error is AppError) throw e.error as AppError;
        throw ErrorHandler.handle(e);
      }
      throw ErrorHandler.handle(e);
    }
  }

  Future<String> otpVerify(String otp,String token) async {
    /*return message*/
    try {
      final res = await dio.post(ApiEndpoints.authOtpVerify,data: {
          "otp" : otp
      },
      options: Options(headers: {
        'Authorization': 'Bearer $token'
      }));
      return res.data['token'];
    } catch (e) {
      if (e is DioError) {
        if (e.error is AppError) throw e.error as AppError;
        throw ErrorHandler.handle(e);
      }
      throw ErrorHandler.handle(e);
    }
  }
}
