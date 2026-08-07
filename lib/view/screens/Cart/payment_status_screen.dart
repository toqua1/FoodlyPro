
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/colors.dart';
import '../../../view_model/Cart/cart_cubit.dart';

class PaymentStatusScreen extends StatefulWidget {
  final bool isSuccess;
  final int? orderId;

  const PaymentStatusScreen({
    super.key,
    required this.isSuccess,
    this.orderId,
  });

  @override
  State<PaymentStatusScreen> createState() => _PaymentStatusScreenState();
}

class _PaymentStatusScreenState extends State<PaymentStatusScreen> {
  bool _isClearing = false;

  Future<void> _onGoHomeAndClearCart() async {
    setState(() => _isClearing = true);
    try {
      // Clear cart via CartCubit
      await context.read<CartCubit>().clearCart();
    } catch (_) {
      // ignore errors on clear, but you may show toast/snackbar
    } finally {
      if (!mounted) return;
      setState(() => _isClearing = false);
      // navigate to home (GoRouter)
      context.go('/navbar');
    }
  }

  @override
  Widget build(BuildContext context) {
    final success = widget.isSuccess;
    return Scaffold(
      appBar: AppBar(
        title: Text(success ? 'تم الدفع' : 'فشل الدفع'),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                success ? Icons.check_circle_outline : Icons.error_outline,
                color: success ? Colors.green : Colors.red,
                size: 110,
              ),
              const SizedBox(height: 24),
              Text(
                success ? 'تم الدفع بنجاح!' : 'فشل الدفع',
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              if (widget.orderId != null) ...[
                const SizedBox(height: 8),
                Text('Order ID: ${widget.orderId}', style: const TextStyle(fontSize: 14)),
              ],
              const SizedBox(height: 28),
              if (success) ...[
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: AppColors.secondaryColor),
                    onPressed: _isClearing ? null : _onGoHomeAndClearCart,
                    child: _isClearing
                        ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                        : const Text('العودة للرئيسية', style: TextStyle(color: Colors.white)),
                  ),
                ),
              ] else ...[
                // Failure actions
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: AppColors.secondaryColor),
                    onPressed: () {
                      // go back to checkout or allow retry
                      context.pop(); // or pop
                    },
                    child: const Text('حاول مرة أخرى', style: TextStyle(color: Colors.white)),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () {
                      context.go('/navbar');
                    },
                    child: const Text('العودة للرئيسية'),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
