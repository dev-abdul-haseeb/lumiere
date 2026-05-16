import 'package:equatable/equatable.dart';

class Address extends Equatable   {
  final String address_id;
  final String house;
  final String street;
  final String city;
  final String country;
  Address ({
    required this.address_id,
    required this.house,
    required this.street,
    required this.city,
    required this.country,
  });

  Address copyWith({
    String? address_id,
    String? house,
    String? street,
    String? city,
    String? country,
  }) {
    return Address(
      address_id: address_id ?? this.address_id,
      house: house ?? this.house,
      street: street ?? this.street,
      city: city ?? this.city,
      country: country ?? this.country,
    );
  }


  @override
  List<Object?> get props => [address_id, house, street, city, country];
}