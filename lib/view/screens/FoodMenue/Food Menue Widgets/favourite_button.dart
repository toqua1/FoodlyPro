
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';

class FavouriteButton extends StatelessWidget {
  const FavouriteButton({super.key, required this.isFavorite});
  final bool isFavorite;

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 10,
      shape: const CircleBorder(),
      clipBehavior: Clip.antiAlias,
      child: Container(
        width: 12.sw,
        height: 12.sw,
        decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.white),
        child: Center(
          child: Icon(isFavorite ? Icons.favorite : Icons.favorite_border,
              color: isFavorite ? Colors.red : Colors.black54, size: 6.5.sw),
        ),
      ),
    );
  }
}
