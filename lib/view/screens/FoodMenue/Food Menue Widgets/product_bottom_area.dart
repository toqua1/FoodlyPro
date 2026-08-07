import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:responsive_builder/responsive_builder.dart';
import '../../../../core/theme/colors.dart';
import '../../../../data/models/cart_model.dart';
import '../../../../data/models/product_model.dart';
import '../../../../view_model/Cart/cart_cubit.dart';

class BottomProductArea extends StatelessWidget {
  const BottomProductArea({
    super.key,
    required this.sidePadding,
    required this.cardHeight,
    required this.redWidth,
    required this.circleSize,
    required this.productPrice,
    required this.qty,
    required this.selectedSize,
    required this.selectedAddons,
    required this.product, required this.sizePrice, required this.addonsPrice,
  });

  final double sidePadding;
  final double cardHeight;
  final double redWidth;
  final double circleSize;
  final double productPrice;
  final int qty;
  final SizeModel? selectedSize;
  final List<AddonDetail> selectedAddons;
  final ProductModel product;
  final double sizePrice;
  final double addonsPrice;
  @override
  Widget build(BuildContext context) {
    final double totalPrice = (sizePrice * qty)+addonsPrice;

    return Padding(
      padding: EdgeInsets.only(right: sidePadding),
      child: SizedBox(
        height: cardHeight,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            // Red rounded shape on left
            Positioned(
              left: 0,
              top: 0,
              bottom: 0,
              child: Container(
                height: cardHeight,
                width: redWidth,
                decoration: BoxDecoration(
                  color: AppColors.secondaryColor,
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(6.sw),
                      bottomRight: Radius.circular(6.sw)
                  ),
                ),
              ),
            ),

            // White elevated card
            Positioned(
              left: redWidth * 0.25,
              right: circleSize * 0.6,
              top: cardHeight * 0.15,
              // bottom: 0,
              child: Material(
                elevation: 8,
                borderRadius: BorderRadius.circular(4.sw),
                clipBehavior: Clip.antiAlias,
                child: Container(
                  height: cardHeight * 0.7,
                  padding: EdgeInsets.symmetric(
                      horizontal: 5.sw,
                      vertical: 2.sh * 0.35),
                  color: Colors.white,
                  child: Row(
                    children: [
                      // totals column
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment
                              .start,
                          mainAxisAlignment: MainAxisAlignment
                              .center,
                          children: [
                            Text('السعر الإجمالي',
                                style: TextStyle(
                                    fontSize: 3.5.sw,
                                    color: Colors.grey)),
                            SizedBox(height: 0.6.sh * 0.06),
                            Text(
                              '$totalPrice جنية',
                              style: TextStyle(fontSize: 5
                                  .sw,
                                  fontWeight: FontWeight
                                      .bold),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(width: 3.sw),

                      // Add to cart button
                      BlocBuilder<CartCubit,CartState>(
                          builder: (context,cartState) {
                            final isLoading = cartState is CartLoading;
                            return ElevatedButton.icon(
                              onPressed: isLoading || qty < 1 || selectedSize == null ? null : () {
                                final selectedAddonIds = selectedAddons.map(
                                        (e) => e.id).toList();
                                log(selectedAddonIds.toString());
                                context.read<CartCubit>().addToCart(
                                  product.id,
                                  selectedSize!.id,
                                  qty,
                                  selectedAddonIds,
                                );
                              },
                              icon: Icon(Icons.shopping_cart, size: 4.5.sw, color: Colors.white),
                              label: Text('أضف للسلة', style: TextStyle(fontSize: 4.sw, color: Colors.white)),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.secondaryColor,
                                padding: EdgeInsets.symmetric(horizontal: 4.sw, vertical: 1.2.sh),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                              ),
                            );
                          }
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // circular cart badge overlapping right edge of white card
            Positioned(
              right: 0,
              top: (cardHeight / 2) - (circleSize / 2),
              child: InkWell(
                onTap: () => context.push('/cart'),
                child: Material(
                  elevation: 6,
                  shape: const CircleBorder(),
                  color: Colors.white,
                  child: Container(
                    width: circleSize,
                    height: circleSize,
                    decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white),
                    child: Center(
                      child: Icon(Icons.shopping_cart,
                          color: AppColors.secondaryColor,
                          size: 6.sw),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
