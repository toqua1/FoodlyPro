import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:elmaleka_kitchen_project/Services/api_services.dart';
import 'package:elmaleka_kitchen_project/core/errors/error_handler.dart';
import 'package:elmaleka_kitchen_project/data/datasources/auth_remote_datasource.dart';
import 'package:elmaleka_kitchen_project/data/datasources/endpoints.dart';
import 'package:elmaleka_kitchen_project/data/models/user_model.dart';

import '../../core/errors/app_error.dart';

class ProfileDataSource {
  final Dio dio;
  ProfileDataSource(this.dio);
  final AuthRemoteDatasource authRemoteDatasource =
      AuthRemoteDatasource(ApiServices().dio);

  Future<UserModel> getProfile() async {
    try {
      final res = await dio.get(ApiEndpoints.userProfile);
      log("Get Profile : ${res.data}");
      await authRemoteDatasource.setUserEmail(res.data['email']);
      await authRemoteDatasource.setUserName(res.data['name']);
      await authRemoteDatasource.setUserPhone(res.data['phone']);
      return UserModel.fromJson(res.data);
    } catch (e) {
      if (e is DioError) {
        if (e.error is AppError) throw e.error as AppError;
        throw ErrorHandler.handle(e);
      }
      throw ErrorHandler.handle(e);
    }
  }

  Future<UserModel> editProfile(UserModel user) async {
    try {
      final res = await dio.patch(ApiEndpoints.userProfile,
          data: {'name': user.name, 'phone': user.phone ,'email':user.email},
          options: Options(contentType: Headers.formUrlEncodedContentType));
      log("Profile updated: ${res.data}");

      await authRemoteDatasource.setUserEmail(res.data['email']);
      await authRemoteDatasource.setUserName(res.data['name']);
      await authRemoteDatasource.setUserPhone(res.data['phone']);
    return UserModel.fromJson(res.data);
    } catch (e) {
      if (e is DioError) {
        if (e.error is AppError) throw e.error as AppError;
        throw ErrorHandler.handle(e);
      }
      throw ErrorHandler.handle(e);
    }
  }

  Future<String> changePass(String oldPass, String newPass) async {
    try {
      final res = await dio.patch(ApiEndpoints.userChangePass, data: {
        {"oldPassword": oldPass, "newPassword": newPass}
      });
      log(res.data['message']);
      return res.data['message'];
    } catch (e) {
      if (e is DioError) {
        if (e.error is AppError) throw e.error as AppError;
        throw ErrorHandler.handle(e);
      }
      throw ErrorHandler.handle(e);
    }
  }

  Future<String> deleteAccount() async {
    try {
      final res = await dio.delete(ApiEndpoints.userProfile);
      log(res.data['message']);
      return res.data['message'];
    } catch (e) {
      if (e is DioError) {
        if (e.error is AppError) throw e.error as AppError;
        throw ErrorHandler.handle(e);
      }
      throw ErrorHandler.handle(e);
    }
  }
}
