part of 'order_cubit.dart';

@immutable
sealed class OrderState extends Equatable {
  final String selectedPayment;
  const OrderState({this.selectedPayment = 'CASH'});

  @override
  List<Object?> get props => [selectedPayment];
}

final class OrderInitial extends OrderState {
  const OrderInitial({super.selectedPayment});
}
final class OrderLoading extends OrderState {
  const OrderLoading({super.selectedPayment});
}
// Add the orderId to the OrderSuccess state
final class OrderSuccess extends OrderState {
  final int orderId;
  const OrderSuccess({required this.orderId, super.selectedPayment});

  @override
  List<Object?> get props => [orderId, selectedPayment];
}
final class OrderError extends OrderState {
  final String message;
  const OrderError(this.message, {super.selectedPayment});

  @override
  List<Object?> get props => [message, selectedPayment];
}