part of 'auth_cubit.dart';

@immutable
sealed class AuthState extends Equatable {
  const AuthState();
  @override
  List<Object?> get props => [];
}

// Generic states (existing)
final class AuthInitial extends AuthState {}
final class AuthLoading extends AuthState {}
final class AuthAuthenticated extends AuthState{}
final class AuthRegisterSuccess extends AuthState{}
final class AuthUnauthenticated extends AuthState {}
final class AuthError extends AuthState {
  final String message;
  const AuthError(this.message);
  @override
  List<Object?> get props => [message];
}

// Request OTP
final class AuthOtpRequestLoading extends AuthState {}
final class AuthOtpRequestSuccess extends AuthState {
  final String message;
  final String token;
  const AuthOtpRequestSuccess( this.token, [this.message = 'تم إرسال '
      'رمز التحقق']);
  @override
  List<Object?> get props => [token,message];
}
final class AuthOtpRequestError extends AuthState {
  final String message;
  const AuthOtpRequestError(this.message);
  @override
  List<Object?> get props => [message];
}

// Verify OTP
final class AuthOtpVerifyLoading extends AuthState {}
final class AuthOtpVerifySuccess extends AuthState {
  final String message;
  final String token;
  const AuthOtpVerifySuccess(this.token, [this.message='رمز التحقق صحيح'] );
  @override
  List<Object?> get props => [message,token];
}
final class AuthOtpVerifyError extends AuthState {
  final String message;
  const AuthOtpVerifyError(this.message);
  @override
  List<Object?> get props => [message];
}

// Reset password
final class AuthResetLoading extends AuthState {}
final class AuthResetSuccess extends AuthState {
  final String message;

  const AuthResetSuccess([this.message='تم تغيير رقم المرور بنجاح']);
  @override
  List<Object?> get props => [message];
}
final class AuthResetError extends AuthState {
  final String message;
  const AuthResetError(this.message);
  @override
  List<Object?> get props => [message];
}
