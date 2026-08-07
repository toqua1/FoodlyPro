import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:responsive_builder/responsive_builder.dart';
import '../../view_model/Cart/cart_cubit.dart';

class CartIcon extends StatelessWidget {
  const CartIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartCubit, CartState>(
      buildWhen: (previous, current) =>
      current is CartLoaded || current is CartError,
      builder: (context, state) {
        if (state is CartLoaded) {
          return Stack(
            clipBehavior: Clip.none,
            children: [
              IconButton(
                icon: Icon(Icons.shopping_cart_rounded,size: 7.sw,),
                onPressed: () => context.push('/cart'),
              ),
              if (state.cart.itemsCount > 0)
                Positioned(
                  right: 4,
                  top: 4,
                  child: CircleAvatar(
                    radius: 2.sw,
                    backgroundColor: Colors.red,
                    child: Text(
                      state.cart.itemsCount.toString(),
                      style: TextStyle(fontSize: 3.sw, color: Colors
                          .white),
                    ),
                  ),
                )
            ],
          );
        }
        return IconButton(
          icon: Icon(Icons.shopping_cart_rounded,size: 7.sw,),
          onPressed: () => context.push('/cart'),
        );
      },
    );
  }
}
