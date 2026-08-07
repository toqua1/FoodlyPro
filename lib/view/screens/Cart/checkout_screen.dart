import 'dart:developer';

import 'package:elmaleka_kitchen_project/core/Utils/is_tablet_service.dart';
import 'package:elmaleka_kitchen_project/core/theme/colors.dart';
import 'package:elmaleka_kitchen_project/view/Widgets/snack_bar.dart';
import 'package:elmaleka_kitchen_project/view/Widgets/total_checkout_section.dart';
import 'package:elmaleka_kitchen_project/view/screens/Cart/webview_screen.dart';
import 'package:elmaleka_kitchen_project/view_model/Cart/cart_cubit.dart';
import 'package:elmaleka_kitchen_project/view_model/Payment/payment_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../../view_model/Address/address_cubit.dart';
import '../../../view_model/Order/order_cubit.dart';
import '../../Widgets/order_success_dialog.dart';

class CheckoutScreen extends StatelessWidget {
  const CheckoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<PaymentCubit, PaymentState>(
      listener: (context, state) {
        // if (state is PaymentLoaded) {
        //   // Launch the link in the browser after the API call is successful
        //   launchUrl(Uri.parse(state.link));
        // }
        if (state is PaymentLoaded) {
          final url = state.link;
          log('payment link:$url');
          final localOrderId = state.orderId;
          // push to WebViewPaymentScreen
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) =>
                  WebViewPaymentScreen(url: url, localOrderId: localOrderId),
            ),
          );
        } else if (state is PaymentError) {
          // Handle payment link generation error
          showSnackBar(context, 'خطأ', state.message, 'failure');
        }
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text(
            'تحقق من',
            style: TextStyle(fontSize: 5.5.sw),
          ),
          actions: [
            IconButton(
                onPressed: () => context.pop(),
                icon: Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 5.sw,
                ))
          ],
        ),
        body: Padding(
          padding: EdgeInsets.all(4.sw),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// ----------- Address Section -----------
              Expanded(
                flex: 3,
                child: BlocBuilder<AddressCubit, AddressState>(
                  builder: (context, state) {
                    if (state is AddressLoading) {
                      return SkeletonizerMultiText();
                    }
                    if (state is AddressLoaded) {
                      final defaultAddress = state.addresses.firstWhere(
                        (a) => a.isDefault,
                        orElse: () => state.addresses.first,
                      );
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "عنوان التسليم",
                                style: TextStyle(
                                    fontSize: 4.5.sw,
                                    fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 2.sh),
                              Text(
                                "مدينة ${defaultAddress.city} - "
                                "شارع ${defaultAddress.street}",
                                style: TextStyle(fontSize: 4.sw),
                              ),
                              Text(
                                  "مبنى ${defaultAddress.building} - "
                                  "طابق ${defaultAddress.floor} - "
                                  "شقة ${defaultAddress.apartment}",
                                  style: TextStyle(fontSize: 4.sw)),
                              Text('ملاحظة: ${defaultAddress.note}',
                                  style: TextStyle(fontSize: 4.sw))
                            ],
                          ),
                          TextButton(
                            onPressed: () => context.push('/address'),
                            child: Text("تعديل",
                                style: TextStyle(
                                    color: AppColors.secondaryColor,
                                    fontSize: 4.sw)),
                          ),
                        ],
                      );
                    }
                    if (state is AddressError) {
                      return Text(state.message,
                          style: TextStyle(
                              color: AppColors.secondaryColor, fontSize: 4.sw));
                    }
                    return const SizedBox();
                  },
                ),
              ),

              // SizedBox(height: 5.sh),

              /// ----------- Payment Section -----------
              Expanded(
                flex: 4,
                child: BlocBuilder<OrderCubit, OrderState>(
                  builder: (context, orderState) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("طريقة الدفع",
                            style: TextStyle(
                                fontSize: 4.5.sw, fontWeight: FontWeight.bold)),
                        SizedBox(
                          height: 1.5.sh,
                        ),
                        _paymentOption(
                            "CASH",
                            orderState.selectedPayment,
                            () => context
                                .read<OrderCubit>()
                                .changePayment("CASH")),
                        _paymentOption(
                            "CREDIT_CARD",
                            orderState.selectedPayment,
                            () => context
                                .read<OrderCubit>()
                                .changePayment("CREDIT_CARD")),
                      ],
                    );
                  },
                ),
              ),

              /// ----------- Create Checkout section -----------
              // SizedBox(
              //   height: 5.sh,
              // ),

              Expanded(
                flex: 3,
                child: BlocBuilder<CartCubit, CartState>(builder: (context, state) {
                  if (state is CartLoading) {
                    return SkeletonizerMultiText();
                  } else if (state is CartLoaded) {
                    final cart = state.cart;
                    return BuildTotalCheckoutSection(
                        totalPrice: cart.totalPrice,
                        shipping: cart.shipping,
                        grandTotal: cart.grandTotal);
                  } else if (state is CartError) {
                    return Center(child: Text("حدث خطأ: ${state.message}"));
                  } else {
                    return const Center(child: Text("لا توجد بيانات"));
                  }
                }),
              ),
              const Spacer(),

              /// ----------- Create Order Button -----------
              Expanded(
                flex: 1,
                child: BlocConsumer<OrderCubit, OrderState>(
                  listener: (context, state) {
                    if (state is OrderSuccess) {
                      // Check if the payment was for a credit card
                      if (state.selectedPayment == 'CREDIT_CARD') {
                        // Call the payment cubit to generate the link
                        context
                            .read<PaymentCubit>()
                            .generateAndLaunchPaymentLink(state.orderId);
                      } else {
                        // For CASH orders, show the success dialog directly
                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (_) => const OrderSuccessDialog(),
                        );
                      }
                    } else if (state is OrderError) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(state.message)),
                      );
                    }
                  },
                  builder: (context, state) {
                    final buttonText = "ارسال";

                    return Center(
                      child: SizedBox(
                        width: isTablet(context) ? 60.sw : 80.sw,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.secondaryColor,
                            padding: EdgeInsets.all(1.5.sh),
                          ),
                          onPressed: () {
                            final addressState =
                                context.read<AddressCubit>().state;
                            if (addressState is AddressLoaded) {
                              final defaultAddress =
                                  addressState.addresses.firstWhere(
                                (a) => a.isDefault,
                                orElse: () => addressState.addresses.first,
                              );
                              context
                                  .read<OrderCubit>()
                                  .createOrder(defaultAddress.id);
                            }
                          },
                          child: state is OrderLoading
                              ? const CircularProgressIndicator(
                                  color: Colors.white)
                              : Text(
                                  buttonText,
                                  style: TextStyle(
                                      fontSize: 5.sw, color: Colors.white),
                                ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _paymentOption(
    String method,
    String selected,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 1.sh),
        padding: EdgeInsets.all(4.sw),
        decoration: BoxDecoration(
          border: Border.all(
            color: selected == method ? AppColors.secondaryColor : Colors.grey,
          ),
          borderRadius: BorderRadius.circular(4.sw),
        ),
        child: Row(
          children: [
            Icon(
              selected == method
                  ? Icons.radio_button_checked
                  : Icons.radio_button_off,
              color: AppColors.secondaryColor,
              size: 5.5.sw,
            ),
            SizedBox(width: 4.sw),
            Text(
              method == "CASH" ? "الدفع عند الاستلام" : "بطاقة الائتمان",
              style: TextStyle(fontSize: 4.sw),
            ),
          ],
        ),
      ),
    );
  }
}

class SkeletonizerMultiText extends StatelessWidget {
  const SkeletonizerMultiText({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      justifyMultiLineText: true,
      textBoneBorderRadius: TextBoneBorderRadius.fromHeightFactor(.5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("عنوان التسليم",
              style: TextStyle(fontSize: 5.sw, fontWeight: FontWeight.bold)),
          SizedBox(height: 2.sh),
          Text("Loading city - Loading street"),
          TextButton(
            onPressed: () {},
            child: const Text("تعديل", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
// import 'package:elmaleka_kitchen_project/core/Utils/is_tablet_service.dart';
// import 'package:elmaleka_kitchen_project/core/theme/colors.dart';
// import 'package:elmaleka_kitchen_project/view/Widgets/snack_bar.dart';
// import 'package:elmaleka_kitchen_project/view/Widgets/total_checkout_section.dart';
// import 'package:elmaleka_kitchen_project/view_model/Cart/cart_cubit.dart';
// import 'package:elmaleka_kitchen_project/view_model/Payment/payment_cubit.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:go_router/go_router.dart';
// import 'package:responsive_builder/responsive_builder.dart';
// import 'package:skeletonizer/skeletonizer.dart';
// import 'package:url_launcher/url_launcher.dart';
// import '../../../Services/api_services.dart';
// import '../../../data/datasources/order_remote_datasource.dart';
// import '../../../view_model/Address/address_cubit.dart';
// import '../../../view_model/Order/order_cubit.dart';
// import '../../Widgets/order_success_dialog.dart';
//
// class CheckoutScreen extends StatelessWidget {
//   const CheckoutScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//       create: (_) => OrderCubit(OrderRemoteDataSource(ApiServices().dio)),
//       child: BlocListener<PaymentCubit,PaymentState>(
//         listener: (context,state) {
//           if (state is PaymentLoaded) {
//             // Launch the link in the browser after the API call is successful
//             launchUrl(Uri.parse(state.link));
//           } else if (state is PaymentError) {
//             // Handle payment link generation error
//             showSnackBar(context, 'خطأ',state.message, 'failure');
//           }
//         },
//           child: Scaffold(
//             appBar: AppBar(
//               automaticallyImplyLeading: false,
//               title: Text(
//                 'تحقق من',
//                 style: TextStyle(fontSize: 5.5.sw),
//               ),
//               actions: [
//                 IconButton(
//                     onPressed: () => context.pop(),
//                     icon: Icon(
//                       Icons.arrow_forward_ios_rounded,
//                       size: 5.sw,
//                     ))
//               ],
//             ),
//             body: Padding(
//               padding: EdgeInsets.all(4.sw),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   /// ----------- Address Section -----------
//                   BlocBuilder<AddressCubit, AddressState>(
//                     builder: (context, state) {
//                       if (state is AddressLoading) {
//                         return SkeletonizerMultiText();
//                       }
//                       if (state is AddressLoaded) {
//                         final defaultAddress = state.addresses.firstWhere(
//                           (a) => a.isDefault,
//                           orElse: () => state.addresses.first,
//                         );
//                         return Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text(
//                                   "عنوان التسليم",
//                                   style: TextStyle(
//                                       fontSize: 4.5.sw,
//                                       fontWeight: FontWeight.bold),
//                                 ),
//                                 SizedBox(height: 2.sh),
//                                 Text(
//                                   "${defaultAddress.city} - ${defaultAddress.street}",
//                                   style: TextStyle(fontSize: 4.sw),
//                                 ),
//                                 Text(
//                                     "${defaultAddress.building} - "
//                                     "${defaultAddress.floor} - ${defaultAddress.apartment}",
//                                     style: TextStyle(fontSize: 4.sw)),
//                                 Text('ملاحظة: ${defaultAddress.note}',
//                                     style: TextStyle(fontSize: 4.sw))
//                               ],
//                             ),
//                             TextButton(
//                               onPressed: () => context.push('/address'),
//                               child: Text("تعديل",
//                                   style: TextStyle(
//                                       color: AppColors.secondaryColor,
//                                       fontSize: 4.sw)),
//                             ),
//                           ],
//                         );
//                       }
//                       if (state is AddressError) {
//                         return Text(state.message,
//                             style: TextStyle(
//                                 color: AppColors.secondaryColor, fontSize: 4.sw));
//                       }
//                       return const SizedBox();
//                     },
//                   ),
//
//                   SizedBox(height: 5.sh),
//
//                   /// ----------- Payment Section -----------
//                   BlocBuilder<OrderCubit, OrderState>(
//                     builder: (context, orderState) {
//                       return Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text("طريقة الدفع",
//                               style: TextStyle(
//                                   fontSize: 4.5.sw, fontWeight: FontWeight.bold)),
//                           SizedBox(
//                             height: 1.5.sh,
//                           ),
//                           _paymentOption(
//                               "CASH",
//                               orderState.selectedPayment,
//                               () =>
//                                   context.read<OrderCubit>().changePayment("CASH")),
//                           _paymentOption(
//                               "CREDIT_CARD",
//                               orderState.selectedPayment,
//                               () => context
//                                   .read<OrderCubit>()
//                                   .changePayment("CREDIT_CARD")),
//                         ],
//                       );
//                     },
//                   ),
//
//                   /// ----------- Create Checkout section -----------
//
//                   SizedBox(
//                     height: 5.sh,
//                   ),
//
//                   BlocBuilder<CartCubit, CartState>(builder: (context, state) {
//                     if (state is CartLoading) {
//                       return SkeletonizerMultiText();
//                     } else if (state is CartLoaded) {
//                       final cart = state.cart;
//                       return BuildTotalCheckoutSection(
//                           totalPrice: cart.totalPrice,
//                           shipping: cart.shipping,
//                           grandTotal: cart.grandTotal);
//                     } else if (state is CartError) {
//                       return Center(child: Text("حدث خطأ: ${state.message}"));
//                     } else {
//                       return const Center(child: Text("لا توجد بيانات"));
//                     }
//                   }),
//                   const Spacer(),
//
//                   /// ----------- Create Order Button -----------
//                   BlocConsumer<OrderCubit, OrderState>(
//                     listener: (context, state) {
//                       if (state is OrderSuccess) {
//                         // show modal dialog
//                         showDialog(
//                           context: context,
//                           barrierDismissible: false,
//                           builder: (_) => const OrderSuccessDialog(),
//                         );
//                       } else if (state is OrderError) {
//                         ScaffoldMessenger.of(context).showSnackBar(
//                           SnackBar(content: Text(state.message)),
//                         );
//                       }
//                     },
//                     builder: (context, state) {
//                       return Center(
//                         child: SizedBox(
//                           width: isTablet(context) ? 60.sw : 80.sw,
//                           child: ElevatedButton(
//                             style: ElevatedButton.styleFrom(
//                               backgroundColor: AppColors.secondaryColor,
//                               padding: EdgeInsets.all(1.5.sh),
//                             ),
//                             onPressed: () {
//                               final addressState =
//                                   context.read<AddressCubit>().state;
//                               if (addressState is AddressLoaded) {
//                                 final defaultAddress =
//                                     addressState.addresses.firstWhere(
//                                   (a) => a.isDefault,
//                                   orElse: () => addressState.addresses.first,
//                                 );
//
//                                 context
//                                     .read<OrderCubit>()
//                                     .createOrder(defaultAddress.id);
//                               }
//                             },
//                             child: state is OrderLoading
//                                 ? const CircularProgressIndicator(
//                                     color: Colors.white)
//                                 : Text("ارسال",
//                                     style: TextStyle(
//                                         fontSize: 5.sw, color: Colors.white)),
//                           ),
//                         ),
//                       );
//                     },
//                   ),
//                 ],
//               ),
//             ),
//           ),
//       ),
//     );
//   }
//
//   Widget _paymentOption(
//     String method,
//     String selected,
//     VoidCallback onTap,
//   ) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         margin: EdgeInsets.symmetric(vertical: 1.sh),
//         padding: EdgeInsets.all(4.sw),
//         decoration: BoxDecoration(
//           border: Border.all(
//             color: selected == method ? AppColors.secondaryColor : Colors.grey,
//           ),
//           borderRadius: BorderRadius.circular(4.sw),
//         ),
//         child: Row(
//           children: [
//             Icon(
//               selected == method
//                   ? Icons.radio_button_checked
//                   : Icons.radio_button_off,
//               color: AppColors.secondaryColor,
//               size: 5.5.sw,
//             ),
//             SizedBox(width: 4.sw),
//             Text(
//               method == "CASH" ? "الدفع عند الاستلام" : "بطاقة الائتمان",
//               style: TextStyle(fontSize: 4.sw),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// class SkeletonizerMultiText extends StatelessWidget {
//   const SkeletonizerMultiText({
//     super.key,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Skeletonizer(
//       justifyMultiLineText: true,
//       textBoneBorderRadius: TextBoneBorderRadius.fromHeightFactor(.5),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text("عنوان التسليم",
//               style: TextStyle(fontSize: 5.sw, fontWeight: FontWeight.bold)),
//           SizedBox(height: 2.sh),
//           Text("Loading city - Loading street"),
//           TextButton(
//             onPressed: () {},
//             child: const Text("تعديل", style: TextStyle(color: Colors.red)),
//           ),
//         ],
//       ),
//     );
//   }
// }
