import 'dart:developer';
import 'package:elmaleka_kitchen_project/core/theme/colors.dart';
import 'package:elmaleka_kitchen_project/view/Widgets/primary_button.dart';
import 'package:elmaleka_kitchen_project/view/Widgets/try_again_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../../core/Utils/build_image_error_general.dart';
import '../../../data/models/cart_model.dart';
import '../../../view_model/Cart/cart_cubit.dart';
import '../../Widgets/total_checkout_row.dart';
import '../../Widgets/total_checkout_section.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("طلبي", style: TextStyle(fontSize: 5.sw)),
        elevation: 0,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        actions: [
          IconButton(
              onPressed: () => context.pop(),
              icon: Icon(
                Icons.arrow_forward_ios_rounded,
                size: 5.sw,
              ))
        ],
      ),
      body: BlocBuilder<CartCubit, CartState>(
        builder: (context, state) {
          if (state is CartError) {
            return TryAgainSection(
                message: state.message,
                method: () => context.read<CartCubit>().fetchCart());
          }
          final isCartLoading = state is CartLoading;
          final cartData = state is CartLoaded ? state.cart : null;

          return Skeletonizer(
            enabled: isCartLoading,
            child: _buildCartView(cartData, context),
          );
          // return const Center(child: Text("لا توجد بيانات"));
        },
      ),
    );
  }

  Widget _buildCartView(CartResponse? cart, BuildContext context) {
    if (cart == null || cart.items.isEmpty) {
      return Center(
          child: Column(
            children: [
              SizedBox(height: 10.sh),
              Image.asset('lib/assets/images/cart-removebg-preview.png', width: 70.sw),
              Text('السلة فارغة', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 5.sw)),
              SizedBox(height: 1.sh),
              Text(
                'يبدو أنك لم تُضِف أي شيء إلى سلة التسوق الخاصة بك. تفضل '
                    'باستكشاف أفضل فئات المنتجات المميزة.',
                style: TextStyle(fontSize: 4.sw),
                textAlign: TextAlign.center,
              )
            ],
          ));
    }

    return RefreshIndicator(
      onRefresh: () => context.read<CartCubit>().fetchCart(),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 4.sw, vertical: 2.sh),
        child: Column(
          children: [
            ...cart.items.map((item) {
              return _buildCartItemCard(item, context);
            }).toList(),
            SizedBox(height: 2.sh),
            _buildTotalsSection(cart),
            SizedBox(height: 1.sh),
            PrimaryButton(
                color: AppColors.secondaryColor,
                txt: 'تحقق من',
                method: () => context.push('/checkout')),
            SizedBox(height: 1.sh),
            TextButton(
                onPressed: () => context.read<CartCubit>().clearCart(),
                child: Text('مسح محتويات السلة', style: TextStyle(fontSize: 4.sw, color: AppColors.secondaryColor))
            ),
            SizedBox(height: 2.sh),
          ],
        ),
      ),
    );
  }

  Widget _buildCartItemCard(CartItem item, BuildContext context) {
    return Card(
      color: Colors.grey.shade100,
      elevation: 2,
      margin: EdgeInsets.symmetric(vertical: 1.sh),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.sw)),
      child: Padding(
        padding: EdgeInsets.all(4.sw),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(2.sw),
                  child: buildErrorImageGeneral(item: item.product,
                      size:25.sw)
                ),
                SizedBox(width: 4.sw),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              item.product.name,
                              style: TextStyle(fontSize: 4.5.sw, fontWeight: FontWeight.bold),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          IconButton(
                            onPressed: () => context.read<CartCubit>().removeItem(item.id),
                            icon: Icon(Icons.delete_outline, color: Colors.red, size: 6.sw),
                          ),
                        ],
                      ),
                      SizedBox(height: 0.5.sh),
                      Text("الحجم: ${item.size.name} - ${item.size.price} جنية",
                          style: TextStyle(fontSize: 4.sw, color: Colors.grey[700])),
                      SizedBox(height: 0.5.sh),
                      _buildQuantityControls(item, context),
                      SizedBox(height: 1.sh),
                    ],
                  ),
                ),
              ],
            ),
            if (item.addons.isNotEmpty)
              _buildAddonsSection(item),
            SizedBox(height: 1.sh),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  "الإجمالي: ${item.itemTotal} جنية",
                  style: TextStyle(fontSize: 4.5.sw, fontWeight: FontWeight.bold, color: AppColors.secondaryColor),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuantityControls(CartItem item, BuildContext context) {
    return Row(
      children: [
        InkWell(
          onTap: () {
            if (item.quantity > 1) {
              context.read<CartCubit>().updateItem(item.id, item.quantity - 1);
            }else if(item.quantity == 1){
              context.read<CartCubit>().removeItem(item.id);
            }
          },
          child: Container(
            padding: EdgeInsets.all(1.sw),
            decoration: BoxDecoration(
              color: AppColors.secondaryColor,
              borderRadius: BorderRadius.circular(2.sw),
            ),
            child: Icon(Icons.remove, color: Colors.white, size: 4.sw),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 2.sw),
          child: Text(
            item.quantity.toString(),
            style: TextStyle(fontSize: 4.sw, fontWeight: FontWeight.bold),
          ),
        ),
        InkWell(
          onTap: () {
            context.read<CartCubit>().updateItem(item.id, item.quantity + 1);
          },
          child: Container(
            padding: EdgeInsets.all(1.sw),
            decoration: BoxDecoration(
              color: AppColors.secondaryColor,
              borderRadius: BorderRadius.circular(2.sw),
            ),
            child: Icon(Icons.add, color: Colors.white, size: 4.sw),
          ),
        ),
      ],
    );
  }

  Widget _buildAddonsSection(CartItem item) {
    return Container(
      padding: EdgeInsets.only(top: 2.sh),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("الإضافات:", style: TextStyle(fontSize: 4.sw, fontWeight: FontWeight.w600)),
          SizedBox(height: 1.sh),
          ...item.addons.map((addon) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(addon.addon.name, style: TextStyle(fontSize: 4.sw, color: Colors.black87)),
                Text("${addon.addon.price} جنية", style: TextStyle(fontSize: 4.sw, color: Colors.black87)),
              ],
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildTotalsSection(CartResponse cart) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 5.sw, vertical: 2.sh),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TotalCheckoutRow(label: "عدد العناصر", value: cart.itemsCount),
          Divider(),
          BuildTotalCheckoutSection(
            totalPrice: cart.totalPrice,
            grandTotal: cart.grandTotal,
            shipping: cart.shipping,
          ),
        ],
      ),
    );
  }
}


// import 'dart:developer';
// import 'package:elmaleka_kitchen_project/core/theme/colors.dart';
// import 'package:elmaleka_kitchen_project/view/Widgets/primary_button.dart';
// import 'package:elmaleka_kitchen_project/view/Widgets/try_again_section.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:go_router/go_router.dart';
// import 'package:responsive_builder/responsive_builder.dart';
// import '../../../view_model/Cart/cart_cubit.dart';
// import '../../Widgets/total_checkout_row.dart';
// import '../../Widgets/total_checkout_section.dart';
//
// class CartScreen extends StatelessWidget {
//   const CartScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         title: Text("طلبي", style: TextStyle(fontSize: 5.sw)),
//         elevation: 0,
//         automaticallyImplyLeading: false,
//         backgroundColor: Colors.white,
//         actions: [
//           IconButton(
//               onPressed: () => context.pop(),
//               icon: Icon(
//                 Icons.arrow_forward_ios_rounded,
//                 size: 5.sw,
//               ))
//         ],
//       ),
//       body: BlocBuilder<CartCubit, CartState>(
//         builder: (context, state) {
//           if (state is CartLoading) {
//             return Center(
//                 child: CircularProgressIndicator(
//               color: AppColors.secondaryColor,
//             ));
//           } else if (state is CartLoaded) {
//             final cart = state.cart;
//             return _buildCartView(cart, context);
//           } else if (state is CartError) {
//             return TryAgainSection(
//                 message: state.message,
//                 method: () => context.read<CartCubit>().fetchCart());
//           }
//           return const Center(child: Text("لا توجد بيانات"));
//         },
//       ),
//     );
//   }
//
//   Widget _buildCartView(cart, BuildContext context) {
//     return cart.items.isEmpty
//         ? Center(
//             child: Column(
//             children: [
//               SizedBox(
//                 height: 10.sh,
//               ),
//               Image.asset(
//                 'lib/assets/images/cart-removebg-preview.png',
//                 width: 70.sw,
//               ),
//               Text('السلة فارغة',
//                   style:
//                       TextStyle(fontWeight: FontWeight.bold, fontSize: 5.sw)),
//               SizedBox(
//                 height: 1.sh,
//               ),
//               Text(
//                 'يبدو أنك لم تُضِف أي شيء إلى سلة التسوق الخاصة بك. تفضل '
//                 'باستكشاف أفضل فئات المنتجات المميزة.',
//                 style: TextStyle(fontSize: 4.sw),
//                 textAlign: TextAlign.center,
//               )
//             ],
//           ))
//         : RefreshIndicator(
//             onRefresh: () => context.read<CartCubit>().fetchCart(),
//             child: SingleChildScrollView(
//               physics:
//                   const AlwaysScrollableScrollPhysics(), // Ensure it's always scrollable
//               child: Column(
//                 children: [
//                   ...cart.items.map((item) {
//                     log(item.addons.toString());
//                     return Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         _buildProductSection(item),
//                         if (item.addons.isNotEmpty) _buildAddonsSection(item),
//                         SizedBox(height: 1.sh),
//                       ],
//                     );
//                   }).toList(),
//                   _buildTotalsSection(cart),
//                   SizedBox(
//                     height: 1.sh,
//                   ),
//                   PrimaryButton(
//                       color: AppColors.secondaryColor,
//                       txt: 'تحقق من ',
//                       method: () => context.push('/checkout')),
//                   SizedBox(
//                     height: 1.sh,
//                   ),
//                   cart.items.isNotEmpty
//                       ? TextButton(
//                           onPressed: () =>
//                               context.read<CartCubit>().clearCart(),
//                           child: Text(
//                             'مسح محتويات السلة',
//                             style: TextStyle(fontSize: 4.sw,color: AppColors.secondaryColor),
//                           ))
//                       : SizedBox(),
//                   SizedBox(
//                     height: 2.sh,
//                   ),
//
//                   // _buildCheckoutButton(),
//                 ],
//               ),
//             ),
//           );
//   }
//
//   Widget _buildProductSection(item) {
//     return Container(
//       color: Colors.white,
//       padding: EdgeInsets.all(4.sw),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           ClipRRect(
//             borderRadius: BorderRadius.circular(2.sw),
//             child: Image.network(
//               item.product.imageUrl ??
//                   "https://upload.wikimedia.org/wikipedia/commons/a/a3/Image-not-found.png",
//               width: 25.sw,
//               height: 25.sw,
//               fit: BoxFit.cover,
//             ),
//           ),
//           SizedBox(width: 4.sw),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Text(item.product.name,
//                         style: TextStyle(
//                             fontSize: 4.5.sw, fontWeight: FontWeight.bold)),
//                     Text(item.product.price.toString(),
//                         style: TextStyle(
//                             fontSize: 4.5.sw, fontWeight: FontWeight.bold)),
//                   ],
//                 ),
//                 SizedBox(height: 0.5.sh),
//                 Text("الحجم: ${item.size.name} - ${item.size.price} جنية",
//                     style: TextStyle(fontSize: 4.sw, color: Colors.grey[700])),
//                 SizedBox(height: 0.5.sh),
//                 Text("الكمية: ${item.quantity}",
//                     style: TextStyle(fontSize: 4.sw, color: Colors.grey[700])),
//                 SizedBox(height: 0.5.sh),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildAddonsSection(item) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Container(
//           color: Colors.grey.shade200,
//           child: ListView.separated(
//             physics: const NeverScrollableScrollPhysics(),
//             shrinkWrap: true,
//             itemCount: item.addons.length,
//             separatorBuilder: (_, __) =>
//                 Divider(height: 0, color: Colors.grey.shade400),
//             itemBuilder: (context, index) {
//               final addon = item.addons[index].addon;
//               return Padding(
//                 padding:
//                     EdgeInsets.symmetric(horizontal: 5.sw, vertical: 1.5.sh),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Text(addon.name,
//                         style:
//                             TextStyle(fontSize: 4.sw, color: Colors.black87)),
//                     Text("${addon.price} جنية",
//                         style:
//                             TextStyle(fontSize: 4.sw, color: Colors.black87)),
//                   ],
//                 ),
//               );
//             },
//           ),
//         ),
//         SizedBox(
//           height: 1.sh,
//         ),
//         Text("الإجمالي: ${item.itemTotal} جنية",
//             style: TextStyle(
//                 fontSize: 4.sw,
//                 fontWeight: FontWeight.bold,
//                 color: AppColors.secondaryColor)),
//       ],
//     );
//   }
//
//   Widget _buildTotalsSection(cart) {
//     return Padding(
//       padding: EdgeInsets.symmetric(horizontal: 5.sw, vertical: 2.sh),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           TotalCheckoutRow(label: "عدد العناصر", value: cart.itemsCount),
//           Divider(),
//           BuildTotalCheckoutSection(
//             totalPrice: cart.totalPrice,
//             grandTotal: cart.grandTotal,
//             shipping: cart.shipping,
//           ),
//         ],
//       ),
//     );
//   }
// }
