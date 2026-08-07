import 'package:elmaleka_kitchen_project/data/models/product_model.dart';
import 'package:equatable/equatable.dart';

import '../../core/Utils/parsing.dart';
import 'category_model.dart';

class AddonDetail extends Equatable {
  final int id;
  final int productId;
  final String name;
  final double price;

  AddonDetail({
    required this.id,
    required this.productId,
    required this.name,
    required this.price,
  });

  factory AddonDetail.fromJson(Map<String, dynamic> json) {
    return AddonDetail(
      id: parseInt(json['id']),
      productId: parseInt(json['productId']),
      name: json['name']?.toString() ?? '',
      price: parseDouble(json['price']),
    );
  }

  factory AddonDetail.empty() => AddonDetail(id: 0, productId: 0, name: '', price: 0.0);

  @override
  List<Object?> get props => [id, productId, name, price];
}

class AddonModel extends Equatable {
  final int id;
  final int cartItemId;
  final int addonId;
  final AddonDetail addon;

  AddonModel({
    required this.id,
    required this.cartItemId,
    required this.addonId,
    required this.addon,
  });

  factory AddonModel.fromJson(Map<String, dynamic> json) {
    final addonJson = json['addon'];
    return AddonModel(
      id: parseInt(json['id']),
      cartItemId: parseInt(json['cartItemId']),
      addonId: parseInt(json['addonId']),
      addon: (addonJson is Map) ? AddonDetail.fromJson(addonJson as Map<String, dynamic>) : AddonDetail.empty(),
    );
  }

  @override
  List<Object?> get props => [id, cartItemId, addonId, addon];
}

class SizeModel extends Equatable {
  final int id;
  final int productId;
  final String name;
  final double price;

  SizeModel({
    required this.id,
    required this.productId,
    required this.name,
    required this.price,
  });

  factory SizeModel.fromJson(Map<String, dynamic> json) {
    return SizeModel(
      id: parseInt(json['id']),
      productId: parseInt(json['productId']),
      name: json['name']?.toString() ?? '',
      price: parseDouble(json['price']),
    );
  }

  factory SizeModel.empty() => SizeModel(id: 0, productId: 0, name: '', price: 0.0);

  @override
  List<Object?> get props => [id, productId, name, price];
}

class CartItem extends Equatable {
  final int id;
  final int userId;
  final int productId;
  final int sizeId;
  final int quantity;
  final ProductModel product;
  final SizeModel size;
  final List<AddonModel> addons;
  final double addonsTotal;
  final double itemTotal;

  CartItem({
    required this.id,
    required this.userId,
    required this.productId,
    required this.sizeId,
    required this.quantity,
    required this.product,
    required this.size,
    required this.addons,
    required this.addonsTotal,
    required this.itemTotal,
  });

  factory CartItem.fromJson(Map<String, dynamic> json) {
    final productJson = json['product'];
    final sizeJson = json['size'];
    final addonsJson = json['addons'];

    final product = (productJson is Map) ? ProductModel.fromJson(productJson as Map<String, dynamic>) : ProductModel(
        id: 0, name: '', description: '', price: 0.0, isAvailable: false, categoryId: 0,
        foodType: '', createdAt: DateTime.fromMillisecondsSinceEpoch(0), category: CategoryModel.empty()
    );

    final size = (sizeJson is Map) ? SizeModel.fromJson(sizeJson as Map<String, dynamic>) : SizeModel.empty();

    final addons = (addonsJson is List) ? (addonsJson as List).map((a) {
      try {
        return AddonModel.fromJson(a as Map<String, dynamic>);
      } catch (_) {
        return AddonModel(id: 0, cartItemId: 0, addonId: 0, addon: AddonDetail.empty());
      }
    }).toList() : <AddonModel>[];

    return CartItem(
      id: parseInt(json['id']),
      userId: parseInt(json['userId']),
      productId: parseInt(json['productId']),
      sizeId: parseInt(json['sizeId']),
      quantity: parseInt(json['quantity']),
      product: product,
      size: size,
      addons: addons,
      addonsTotal: parseDouble(json['addonsTotal']),
      itemTotal: parseDouble(json['itemTotal']),
    );
  }

  @override
  List<Object?> get props => [id, userId, productId, sizeId, quantity, product, size, addons, addonsTotal, itemTotal];
}

class CartResponse extends Equatable {
  final List<CartItem> items;
  final int itemsCount;
  final double totalPrice;
  final double shipping;
  final double grandTotal;

  CartResponse({
    required this.items,
    required this.itemsCount,
    required this.totalPrice,
    required this.shipping,
    required this.grandTotal,
  });

  factory CartResponse.fromJson(Map<String, dynamic> json) {
    final itemsList = (json['items'] is List) ? (json['items'] as List).map((i) {
      try {
        return CartItem.fromJson(i as Map<String, dynamic>);
      } catch (e) {
        // skip or return an empty fallback
        return CartItem.fromJson({}); // not ideal, but avoids crash — prefer logging & inspecting server data
      }
    }).toList() : <CartItem>[];

    return CartResponse(
      items: itemsList,
      itemsCount: parseInt(json['itemsCount']),
      totalPrice: parseDouble(json['totalPrice']),
      shipping: parseDouble(json['shipping']),
      grandTotal: parseDouble(json['grandTotal']),
    );
  }

  @override
  List<Object?> get props => [items, itemsCount, totalPrice, shipping, grandTotal];
}

// import 'package:equatable/equatable.dart';
// import 'product_model.dart';
//
// /*
// * here’s how we can make your Cart model, Product model, Category model,
// *  and related nested objects all extend Equatable so equality works deeply across the entire structure.
// * */
// class CartResponse extends Equatable {
//   final List<CartItem> items;
//   final int itemsCount;
//   final double totalPrice;
//   final double shipping;
//   final double grandTotal;
//
//   CartResponse({
//     required this.items,
//     required this.itemsCount,
//     required this.totalPrice,
//     required this.shipping,
//     required this.grandTotal,
//   });
//
//   factory CartResponse.fromJson(Map<String, dynamic> json) {
//     return CartResponse(
//       items: (json['items'] as List)
//           .map((item) => CartItem.fromJson(item))
//           .toList(),
//       itemsCount: json['itemsCount'],
//       totalPrice: (json['totalPrice'] as num).toDouble(),
//       shipping: (json['shipping'] as num).toDouble(),
//       grandTotal: (json['grandTotal'] as num).toDouble(),
//     );
//   }
//
//   @override
//   // TODO: implement props
//   List<Object?> get props =>
//       [items, itemsCount, totalPrice, shipping, grandTotal];
// }
//
// class CartItem extends Equatable {
//   final int id;
//   final int userId;
//   final int productId;
//   final int sizeId;
//   final int quantity;
//   final ProductModel product;
//   final SizeModel size;
//   final List<AddonModel> addons;
//   // final double sizePrice;
//   final double addonsTotal;
//   final double itemTotal;
//
//   CartItem({
//     required this.id,
//     required this.userId,
//     required this.productId,
//     required this.sizeId,
//     required this.quantity,
//     required this.product,
//     required this.size,
//     required this.addons,
//     // required this.sizePrice,
//     required this.addonsTotal,
//     required this.itemTotal,
//   });
//
//   factory CartItem.fromJson(Map<String, dynamic> json) {
//     return CartItem(
//       id: json['id'],
//       userId: json['userId'],
//       productId: json['productId'],
//       sizeId: json['sizeId'],
//       quantity: json['quantity'],
//       product: ProductModel.fromJson(json['product']),
//       size: SizeModel.fromJson(json['size']),
//       addons:
//           (json['addons'] as List).map((a) => AddonModel.fromJson(a)).toList(),
//       // sizePrice: (json['sizePrice'] as num).toDouble(),
//       addonsTotal: (json['addonsTotal'] as num).toDouble(),
//       itemTotal: (json['itemTotal'] as num).toDouble(),
//     );
//   }
//
//   @override
//   // TODO: implement props
//   List<Object?> get props => [
//         id,
//         userId,
//         productId,
//         sizeId,
//         quantity,
//         product,
//         size,
//         addons,
//         // sizePrice,
//         addonsTotal,
//         itemTotal
//       ];
// }
//
// class SizeModel extends Equatable {
//   final int id;
//   final int productId;
//   final String name;
//   final double price;
//
//   SizeModel({
//     required this.id,
//     required this.productId,
//     required this.name,
//     required this.price,
//   });
//
//   factory SizeModel.fromJson(Map<String, dynamic> json) {
//     return SizeModel(
//       id: json['id'],
//       productId: json['productId'],
//       name: json['name'],
//       price: (json['price'] as num).toDouble(),
//     );
//   }
//
//   @override
//   // TODO: implement props
//   List<Object?> get props => [id, productId, name, price];
// }
//
// class AddonModel extends Equatable {
//   final int id;
//   final int cartItemId;
//   final int addonId;
//   final AddonDetail addon;
//
//   AddonModel({
//     required this.id,
//     required this.cartItemId,
//     required this.addonId,
//     required this.addon,
//   });
//
//   factory AddonModel.fromJson(Map<String, dynamic> json) {
//     return AddonModel(
//       id: json['id'],
//       cartItemId: json['cartItemId'],
//       addonId: json['addonId'],
//       addon: AddonDetail.fromJson(json['addon']),
//     );
//   }
//
//   @override
//   // TODO: implement props
//   List<Object?> get props => [id, cartItemId, addonId, addon];
// }
//
// class AddonDetail extends Equatable {
//   final int id;
//   final int productId;
//   final String name;
//   final double price;
//
//   AddonDetail({
//     required this.id,
//     required this.productId,
//     required this.name,
//     required this.price,
//   });
//
//   factory AddonDetail.fromJson(Map<String, dynamic> json) {
//     return AddonDetail(
//       id: json['id'],
//       productId: json['productId'],
//       name: json['name'],
//       price: (json['price'] as num).toDouble(),
//     );
//   }
//
//   @override
//   // TODO: implement props
//   List<Object?> get props => [id, productId, name, price];
// }
