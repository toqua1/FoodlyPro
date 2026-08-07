import 'package:bloc/bloc.dart';
import 'package:elmaleka_kitchen_project/core/errors/error_handler.dart';
import 'package:elmaleka_kitchen_project/data/datasources/order_remote_datasource.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
part 'order_state.dart';

class OrderCubit extends Cubit<OrderState> {
  final OrderRemoteDataSource orderRemoteDataSource;

  OrderCubit(this.orderRemoteDataSource) : super(const OrderInitial());

  void changePayment(String method) {
    emit(OrderInitial(selectedPayment: method));
  }

  Future<void> createOrder(int addressId) async {
    emit(OrderLoading(selectedPayment: state.selectedPayment));
    try {
      // The API call returns the orderId
      final int orderId = await orderRemoteDataSource.createOrder(addressId, state.selectedPayment);
      // Emit the orderId with the success state
      emit(OrderSuccess(orderId: orderId, selectedPayment: state.selectedPayment));
    } catch (e) {
      final appErr = ErrorHandler.handle(e);
      emit(OrderError(appErr.message, selectedPayment: state.selectedPayment));
    }
  }
}