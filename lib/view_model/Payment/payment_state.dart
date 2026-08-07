part of 'payment_cubit.dart';

@immutable
sealed class PaymentState {}

final class PaymentInitial extends PaymentState {}
final class PaymentLoading extends PaymentState {}
final class PaymentLoaded extends PaymentState {
  final String link;
  final int orderId; // <-- include order id
  PaymentLoaded(this.link, this.orderId);
}
final class PaymentError extends PaymentState {
  final String message;
  PaymentError(this.message);
}
