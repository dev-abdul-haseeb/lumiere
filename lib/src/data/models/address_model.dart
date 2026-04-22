import '../../domain/entities/address.dart';

class AddressModel extends Address {
  AddressModel({
    required super.address_id,
    required super.house,
    required super.street,
    required super.city,
    required super.country,
  });

  AddressModel copyWith({
    String? address_id,
    String? house,
    String? street,
    String? city,
    String? country,
  }) {
    return AddressModel(
      address_id: address_id ?? this.address_id,
      house: house ?? this.house,
      street: street ?? this.street,
      city: city ?? this.city,
      country: country ?? this.country,
    );
  }
}