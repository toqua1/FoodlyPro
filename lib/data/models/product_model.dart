// import 'package:equatable/equatable.dart';
// import 'category_model.dart';
//
// class ProductModel extends Equatable {
//   final int id;
//   final String name;
//   final String description;
//   final double price;
//   final String? imageUrl;
//   final bool isAvailable;
//   final int categoryId;
//   final String foodType;
//   final DateTime createdAt;
//   final CategoryModel category;
//
//   // keep only this
//   final bool? isFavorite;
//
//   final double ratingAverage;
//   final int ratingCount;
//
//   ProductModel({
//     required this.id,
//     required this.name,
//     required this.description,
//     required this.price,
//     this.imageUrl,
//     required this.isAvailable,
//     required this.categoryId,
//     required this.foodType,
//     required this.createdAt,
//     required this.category,
//     this.isFavorite,
//     this.ratingAverage = 0.0,
//     this.ratingCount = 0,
//   });
//
//   // Helper to parse booleans tolerant to several formats
//   static bool _parseBool(dynamic v) {
//     if (v == null) return false;
//     if (v is bool) return v;
//     final s = v.toString().toLowerCase().trim();
//     return s == 'true' || s == '1' || s == 'yes';
//   }
//
//   factory ProductModel.fromJson(Map<String, dynamic> json) {
//     final cat = (json['category'] is Map)
//         ? CategoryModel.fromJson(json['category'] as Map<String, dynamic>)
//         : CategoryModel.empty();
//
//     DateTime created;
//     try {
//       created = DateTime.parse(json['createdAt'] ?? json['created_at'] ?? DateTime.now().toIso8601String());
//     } catch (_) {
//       created = DateTime.now();
//     }
//
//     // find favorite-like field (accept many variants)
//     final favRaw = json['favored'] ?? json['favoured'] ?? json['isFavorite'] ?? json['is_favorite'] ?? json['isFavoured'] ?? json['is_favoured'];
//     final isFav = favRaw == null ? null : _parseBool(favRaw);
//
//     return ProductModel(
//       id: json['id'] is int ? json['id'] as int : int.parse('${json['id']}'),
//       name: json['name'] ?? '',
//       description: json['description'] ?? '',
//       price: (json['price'] as num).toDouble(),
//       imageUrl: json['imageUrl'] ?? json['image_url'],
//       isAvailable: json['isAvailable'] ?? json['is_available'] ?? false,
//       categoryId: json['categoryId'] ?? json['category_id'] ?? 0,
//       foodType: json['foodType'] ?? json['food_type'] ?? '',
//       createdAt: created,
//       category: cat,
//       isFavorite: isFav,
//       ratingAverage: (json['ratingAverage'] as num?)?.toDouble() ?? (json['rating_average'] as num?)?.toDouble() ?? 0.0,
//       ratingCount: (json['ratingCount'] as int?) ?? (json['rating_count'] as int?) ?? 0,
//     );
//   }
//
//   ProductModel copyWith({
//     int? id,
//     String? name,
//     String? description,
//     double? price,
//     String? imageUrl,
//     bool? isAvailable,
//     int? categoryId,
//     String? foodType,
//     DateTime? createdAt,
//     CategoryModel? category,
//     bool? isFavorite,
//     double? ratingAverage,
//     int? ratingCount,
//   }) {
//     return ProductModel(
//       id: id ?? this.id,
//       name: name ?? this.name,
//       description: description ?? this.description,
//       price: price ?? this.price,
//       imageUrl: imageUrl ?? this.imageUrl,
//       isAvailable: isAvailable ?? this.isAvailable,
//       categoryId: categoryId ?? this.categoryId,
//       foodType: foodType ?? this.foodType,
//       createdAt: createdAt ?? this.createdAt,
//       category: category ?? this.category,
//       isFavorite: isFavorite ?? this.isFavorite,
//       ratingAverage: ratingAverage ?? this.ratingAverage,
//       ratingCount: ratingCount ?? this.ratingCount,
//     );
//   }
//
//   // Map<String, dynamic> toJson() {
//   //   return {
//   //     'id': id,
//   //     'name': name,
//   //     'description': description,
//   //     'price': price,
//   //     'imageUrl': imageUrl,
//   //     'isAvailable': isAvailable,
//   //     'categoryId': categoryId,
//   //     'foodType': foodType,
//   //     'createdAt': createdAt.toIso8601String(),
//   //     'category': category.toJson(),
//   //     'isFavorite': isFavorite,
//   //     'ratingAverage': ratingAverage,
//   //     'ratingCount': ratingCount,
//   //   };
//   // }
//
//   @override
//   List<Object?> get props => [
//     id,
//     name,
//     description,
//     price,
//     imageUrl,
//     isAvailable,
//     categoryId,
//     foodType,
//     createdAt,
//     category,
//     isFavorite,
//     ratingAverage,
//     ratingCount,
//   ];
// }

import 'package:equatable/equatable.dart';
import 'category_model.dart';

class ProductModel extends Equatable {
  final int id;
  final String name;
  final String description;
  final double price;
  final String? imageUrl;
  final bool isAvailable;
  final int categoryId;
  final String foodType;
  final DateTime createdAt;
  final CategoryModel category;

  final bool? isFavorite;
  final double ratingAverage;
  final int ratingCount;

  ProductModel({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    this.imageUrl,
    required this.isAvailable,
    required this.categoryId,
    required this.foodType,
    required this.createdAt,
    required this.category,
    this.isFavorite,
    this.ratingAverage = 0.0,
    this.ratingCount = 0,
  });

  // Helper to parse booleans tolerant to several formats
  static bool _parseBool(dynamic v) {
    if (v == null) return false;
    if (v is bool) return v;
    final s = v.toString().toLowerCase().trim();
    return s == 'true' || s == '1' || s == 'yes';
  }

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    final cat = (json['category'] is Map)
        ? CategoryModel.fromJson(json['category'] as Map<String, dynamic>)
        : CategoryModel.empty();

    DateTime created;
    try {
      created = DateTime.parse(json['createdAt'] ?? json['created_at'] ?? DateTime.now().toIso8601String());
    } catch (_) {
      created = DateTime.now();
    }

    // find favorite-like field (accept many variants)
    final favRaw = json['favored'] ?? json['favoured'] ?? json['isFavorite'] ?? json['is_favorite'] ?? json['isFavoured'] ?? json['is_favoured'];
    final isFav = favRaw == null ? null : _parseBool(favRaw);

    // handle imageUrl: if backend sends a relative path starting with '/'
    String? image = json['imageUrl'] ?? json['image_url'];
    if (image != null && image.isNotEmpty) {
      if (image.startsWith('/')) {
        // prepend media base URL
        // Hardcoded base — change this to ApiServices().mediaBaseUrl if you prefer reading from ApiServices.
        const mediaBase = 'https://media.queen.kitchen';
        image = mediaBase + image;
      }
    }

    return ProductModel(
      id: json['id'] is int ? json['id'] as int : int.parse('${json['id']}'),
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      price: (json['price'] as num).toDouble(),
      imageUrl: image,
      isAvailable: json['isAvailable'] ?? json['is_available'] ?? false,
      categoryId: json['categoryId'] ?? json['category_id'] ?? 0,
      foodType: json['foodType'] ?? json['food_type'] ?? '',
      createdAt: created,
      category: cat,
      isFavorite: isFav,
      ratingAverage: (json['ratingAverage'] as num?)?.toDouble() ?? (json['rating_average'] as num?)?.toDouble() ?? 0.0,
      ratingCount: (json['ratingCount'] as int?) ?? (json['rating_count'] as int?) ?? 0,
    );
  }

  ProductModel copyWith({
    int? id,
    String? name,
    String? description,
    double? price,
    String? imageUrl,
    bool? isAvailable,
    int? categoryId,
    String? foodType,
    DateTime? createdAt,
    CategoryModel? category,
    bool? isFavorite,
    double? ratingAverage,
    int? ratingCount,
  }) {
    return ProductModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      imageUrl: imageUrl ?? this.imageUrl,
      isAvailable: isAvailable ?? this.isAvailable,
      categoryId: categoryId ?? this.categoryId,
      foodType: foodType ?? this.foodType,
      createdAt: createdAt ?? this.createdAt,
      category: category ?? this.category,
      isFavorite: isFavorite ?? this.isFavorite,
      ratingAverage: ratingAverage ?? this.ratingAverage,
      ratingCount: ratingCount ?? this.ratingCount,
    );
  }

  @override
  List<Object?> get props => [
    id,
    name,
    description,
    price,
    imageUrl,
    isAvailable,
    categoryId,
    foodType,
    createdAt,
    category,
    isFavorite,
    ratingAverage,
    ratingCount,
  ];
}


// import 'package:equatable/equatable.dart';
// import 'category_model.dart';
//
// class ProductModel extends Equatable {
//   final int id;
//   final String name;
//   final String description;
//   final double price;
//   final String? imageUrl;
//   final bool isAvailable;
//   final int categoryId;
//   final String foodType;
//   final DateTime createdAt;
//   final CategoryModel category;
//
//   final double ratingAverage;
//   final int ratingCount;
//
//   ProductModel({
//     required this.id,
//     required this.name,
//     required this.description,
//     required this.price,
//     this.imageUrl,
//     required this.isAvailable,
//     required this.categoryId,
//     required this.foodType,
//     required this.createdAt,
//    required this.category,
//     this.ratingAverage = 0.0,
//     this.ratingCount = 0,
//   });
//
//   factory ProductModel.fromJson(Map<String, dynamic> json) {
//     final cat = (json['category'] is Map) ? CategoryModel.fromJson(json['category'] as Map<String, dynamic>) : CategoryModel.empty();
//     return ProductModel(
//       id: json['id'],
//       name: json['name'] ?? '',
//       description: json['description'] ?? '',
//       price: (json['price'] as num).toDouble(),
//       imageUrl: json['imageUrl'],
//       isAvailable: json['isAvailable'] ?? false,
//       categoryId: json['categoryId'] ?? 0,
//       foodType: json['foodType'] ?? '',
//       createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
//       category: cat,
//       ratingAverage: (json['ratingAverage'] as num?)?.toDouble() ?? 0.0,
//       ratingCount: json['ratingCount'] as int? ?? 0,
//
//     );
//   }
//
//   @override
//   List<Object?> get props => [
//     id,
//     name,
//     description,
//     price,
//     imageUrl,
//     isAvailable,
//     categoryId,
//     foodType,
//     createdAt,
//     category,
//     ratingAverage,
//     ratingCount,
//   ];
// }
