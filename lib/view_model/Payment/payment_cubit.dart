// payment_cubit.dart
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../data/datasources/payment_datasource.dart';

part 'payment_state.dart';

class PaymentCubit extends Cubit<PaymentState> {
  final PaymentDataSource paymentDataSource;

  PaymentCubit(this.paymentDataSource) : super(PaymentInitial());

  Future<void> generateAndLaunchPaymentLink(int orderId) async {
    emit(PaymentLoading());
    try {
      final String link = await paymentDataSource.generatePaymentLink(orderId);
      emit(PaymentLoaded(link, orderId));
    } catch (e) {
      emit(PaymentError(e.toString()));
    }
  }
}