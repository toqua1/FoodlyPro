
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:elmaleka_kitchen_project/Services/Storage/secure_storage_service.dart';
import 'package:elmaleka_kitchen_project/Services/Storage/shared_preferences_service.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import '../../core/errors/error_handler.dart';
import '../../core/errors/app_error.dart';
import '../../data/datasources/auth_remote_datasource.dart';
import '../../data/models/user_model.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRemoteDatasource remote;
  AuthCubit(this.remote) : super(AuthInitial());
  String? _resetEmail;

  // set email
  void setResetEmail(String email) {
    _resetEmail = email;
  }

  // get email
  String? get resetEmail => _resetEmail;

  /// Login with email/password
  Future<void> login(String email, String password) async {
    emit(AuthLoading());
    try {
      final resp = await remote.loginUser(email, password);
      emit(AuthAuthenticated());
    } catch (e) {
      final appErr = e is AppError ? e : ErrorHandler.handle(e);
      log(appErr.toString());
      emit(AuthError(appErr.message));
      emit(AuthUnauthenticated());
    }
  }

  Future<void> register(UserModel user,String pass) async {
    emit(AuthLoading());
    try {
      final resp = await remote.registerUser(user,pass);
      emit(AuthRegisterSuccess());
    } catch (e) {
      final appErr = e is AppError ? e : ErrorHandler.handle(e);
      emit(AuthError(appErr.message));
      emit(AuthUnauthenticated());
    }
  }

  /// Logout: clear token + user
  Future<void> logout() async {
    emit(AuthLoading());
    try {
      await SecureStorageService().clearToken();
      await UserData().clearUserPrefsData();
      emit(AuthUnauthenticated());
    } catch (e) {
      final appErr = e is AppError ? e : ErrorHandler.handle(e);
      emit(AuthError(appErr.message));
    }
  }

  Future<void> requestOtp(String email) async {
    emit(AuthOtpRequestLoading());
    try {
       final token = await remote.otpRequest(email);
       setResetEmail(email);
      emit(AuthOtpRequestSuccess(token));
    } catch (e) {
      final appErr = e is AppError ? e : ErrorHandler.handle(e);
      emit(AuthOtpRequestError(appErr.message));
    }
  }

  Future<void> verifyOtp(String otp,String verifyToken) async {
    emit(AuthOtpVerifyLoading());
    try {
      final token = await remote.otpVerify(otp,verifyToken);
      // final message = res[0];
      emit(AuthOtpVerifySuccess(token));
    } catch (e) {
      final appErr = e is AppError ? e : ErrorHandler.handle(e);
      emit(AuthOtpVerifyError(appErr.message));
    }
  }

  Future<void> resetPassword(String newPassword,String token) async {
    emit(AuthResetLoading());
    try {
       await remote.resetPassword(newPassword,token);
      emit(AuthResetSuccess());
    } catch (e) {
      final appErr = e is AppError ? e : ErrorHandler.handle(e);
      emit(AuthResetError(appErr.message));
    }
  }
}
