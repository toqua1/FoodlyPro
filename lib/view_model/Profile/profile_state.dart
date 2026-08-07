part of 'profile_cubit.dart';

@immutable
sealed class ProfileState extends Equatable{

  List<Object?> get props => [];
}

final class ProfileInitial extends ProfileState {}
final class ProfileLoading extends ProfileState {}
// final class ProfileEditSuccess extends ProfileState {}
final class ProfileLoaded extends ProfileState {
 // final String message;
final UserModel user;
  ProfileLoaded(this.user);
  List<Object?> get props => [user];
}
final class ProfileError extends ProfileState {
  final String message;
  ProfileError(this.message);
  List<Object?> get props => [message];
}
