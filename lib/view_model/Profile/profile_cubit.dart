import 'package:bloc/bloc.dart';
import 'package:elmaleka_kitchen_project/data/datasources/profile_datasource.dart';
import 'package:elmaleka_kitchen_project/data/models/user_model.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';

import '../../core/errors/app_error.dart';
import '../../core/errors/error_handler.dart';
import '../../view/Widgets/snack_bar.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final ProfileDataSource remote;
  ProfileCubit(this.remote) : super(ProfileInitial());

  Future<void> getProfile() async {

    emit(ProfileLoading());
    try {
      final user = await remote.getProfile();
      emit(ProfileLoaded(user));
    } catch (e) {
      final appErr = e is AppError ? e : ErrorHandler.handle(e);
      emit(ProfileError(appErr.message));
    }
  }

  Future<void> editProfile(UserModel user,BuildContext context)async{
    emit(ProfileLoading());
    try{
      final userModel = await remote.editProfile(user);
      showSnackBar(context, 'تم تحديث البيانات بنجاح', '', 'success');
      emit(ProfileLoaded(userModel));
    }catch(e){
      final appErr = e is AppError ? e : ErrorHandler.handle(e);
      emit(ProfileError(appErr.message));
    }
  }

  Future<void> deleteProfile()async{
    emit(ProfileLoading());
    try{
      await remote.deleteAccount();
      // On successful deletion, you might want to log the user out
      // or emit a special state to trigger navigation to login screen.
    }catch(e){
      final appErr = e is AppError ? e : ErrorHandler.handle(e);
      emit(ProfileError(appErr.message));
    }
  }

  Future<void> changePass(String oldPass, String newPass )async{
    emit(ProfileLoading());
    try{
      await remote.changePass(oldPass, newPass);
      // emit(ProfileLoaded(res));
    }catch(e){
      final appErr = e is AppError ? e : ErrorHandler.handle(e);
      emit(ProfileError(appErr.message));
    }
  }
}
