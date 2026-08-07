import 'package:equatable/equatable.dart';

class CategoryModel extends Equatable {
  final int id;
  final String name;
  final String imageUrl;
  final DateTime createdAt;

  CategoryModel({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.createdAt,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'],
      name: json['name'],
      imageUrl: json['imageUrl'] ?? '',
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
  factory CategoryModel.empty() => CategoryModel(id: 0, name: '', imageUrl: ''
      '', createdAt: DateTime.now());

  @override
  // TODO: implement props
  List<Object?> get props => [id,imageUrl,name,createdAt];
}
