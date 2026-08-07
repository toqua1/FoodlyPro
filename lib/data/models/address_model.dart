import 'package:equatable/equatable.dart';

class AddressModel extends Equatable{
  final int id;
  final String city;
  final String street;
  final String building;
  final String floor;
  final String apartment;
  final String note;
  final bool isDefault;

  AddressModel({
    required this.id,
    required this.city,
    required this.street,
    required this.isDefault,
    required this.apartment,
    required this.building,
    required this.floor,
    required this.note
  });

  factory AddressModel.fromJson(Map<String, dynamic> json) {
    return AddressModel(
      id: json['id'],
      city: json['city'],
      street: json['street'],
      isDefault: json['isDefault'],
      apartment: json['apartment'],
      building: json['building'],
      floor: json['floor'],
      note: json['note'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'city': city,
      'street': street,
      'building': building,
      'floor': floor,
      'apartment': apartment,
      'note': note,
      'isDefault': isDefault,
    };
  }

  @override
  // TODO: implement props
  List<Object?> get props => [id,building,floor,street,apartment,isDefault,
    note,city];
}
