import 'package:equatable/equatable.dart';
import 'package:elmaleka_kitchen_project/data/models/product_model.dart';
import 'package:elmaleka_kitchen_project/data/models/cart_model.dart'; // Import to use SizeModel and AddonDetail

class ProductDetailModel extends Equatable {
  final ProductModel product;
  final List<SizeModel> sizes;
  final List<AddonDetail> addons;

  const ProductDetailModel({
    required this.product,
    required this.sizes,
    required this.addons,
  });

  factory ProductDetailModel.fromJson(Map<String, dynamic> json) {
    return ProductDetailModel(
      product: ProductModel.fromJson(json),
      sizes: (json['sizes'] as List)
          .map((item) => SizeModel.fromJson(item))
          .toList(),
      addons: (json['addons'] as List)
          .map((item) => AddonDetail.fromJson(item))
          .toList(),
    );
  }

  @override
  List<Object?> get props => [product, sizes, addons];
}