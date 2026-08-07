import 'package:elmaleka_kitchen_project/data/models/address_model.dart'; // assuming you have this
import 'package:elmaleka_kitchen_project/data/models/product_model.dart'; // assuming you have this

class OrderModel {
  final int id;
  final String merchantOrderId;
  final int userId;
  final int addressId;
  final String status;
  final double totalPrice;
  final String paymentMethod;
  final String paymentStatus;
  final int paymobOrderId;
  final DateTime createdAt;
  final List<OrderItemModel> orderItems;
  final AddressModel address;

  OrderModel({
    required this.id,
    required this.merchantOrderId,
    required this.userId,
    required this.addressId,
    required this.status,
    required this.totalPrice,
    required this.paymentMethod,
    required this.paymentStatus,
    required this.paymobOrderId,
    required this.createdAt,
    required this.orderItems,
    required this.address,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'] as int,
      merchantOrderId: json['merchantOrderId'] as String,
      userId: json['userId'] as int,
      addressId: json['addressId'] as int,
      status: json['status'] as String,
      totalPrice: (json['totalPrice'] as num).toDouble(),
      paymentMethod: json['paymentMethod'] as String,
      paymentStatus: json['paymentStatus'] as String,
      paymobOrderId: json['paymobOrderId'] as int,
      createdAt: DateTime.parse(json['createdAt'] as String),
      orderItems: (json['orderItems'] as List<dynamic>)
          .map((item) => OrderItemModel.fromJson(item as Map<String, dynamic>))
          .toList(),
      address: AddressModel.fromJson(json['address'] as Map<String, dynamic>),
    );
  }
}

class OrderItemModel {
  final int id;
  final int orderId;
  final int productId;
  final int sizeId;
  final int quantity;
  final double unitPrice;
  final ProductModel product;
  final SizeModel size;
  final List<AddonItemModel> addons;

  OrderItemModel({
    required this.id,
    required this.orderId,
    required this.productId,
    required this.sizeId,
    required this.quantity,
    required this.unitPrice,
    required this.product,
    required this.size,
    required this.addons,
  });

  factory OrderItemModel.fromJson(Map<String, dynamic> json) {
    return OrderItemModel(
      id: json['id'] as int,
      orderId: json['orderId'] as int,
      productId: json['productId'] as int,
      sizeId: json['sizeId'] as int,
      quantity: json['quantity'] as int,
      unitPrice: (json['unitPrice'] as num).toDouble(),
      product: ProductModel.fromJson(json['product'] as Map<String, dynamic>),
      size: SizeModel.fromJson(json['size'] as Map<String, dynamic>),
      addons: (json['addons'] as List<dynamic>)
          .map((item) => AddonItemModel.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }
}

class SizeModel {
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
      id: json['id'] as int,
      productId: json['productId'] as int,
      name: json['name'] as String,
      price: (json['price'] as num).toDouble(),
    );
  }
}

class AddonItemModel {
  final int id;
  final int orderItemId;
  final int addonId;
  final AddonModel addon;

  AddonItemModel({
    required this.id,
    required this.orderItemId,
    required this.addonId,
    required this.addon,
  });

  factory AddonItemModel.fromJson(Map<String, dynamic> json) {
    return AddonItemModel(
      id: json['id'] as int,
      orderItemId: json['orderItemId'] as int,
      addonId: json['addonId'] as int,
      addon: AddonModel.fromJson(json['addon'] as Map<String, dynamic>),
    );
  }
}

class AddonModel {
  final int id;
  final int productId;
  final String name;
  final double price;

  AddonModel({
    required this.id,
    required this.productId,
    required this.name,
    required this.price,
  });

  factory AddonModel.fromJson(Map<String, dynamic> json) {
    return AddonModel(
      id: json['id'] as int,
      productId: json['productId'] as int,
      name: json['name'] as String,
      price: (json['price'] as num).toDouble(),
    );
  }
}