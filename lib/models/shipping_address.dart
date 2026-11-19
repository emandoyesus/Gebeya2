class ShippingAddress {
  final String fullName;
  final String phoneNumber;
  final String streetAddress;
  final String city;
  final String subcity; // e.g. Bole, Kazanchis, Kirkos, Yeka, Lideta
  final String postalCode;
  final bool isDefault;

  const ShippingAddress({
    required this.fullName,
    required this.phoneNumber,
    required this.streetAddress,
    required this.city,
    required this.subcity,
    this.postalCode = '1000',
    this.isDefault = true,
  });

  String get formattedAddress => '$streetAddress, $subcity, $city';

  Map<String, dynamic> toJson() {
    return {
      'fullName': fullName,
      'phoneNumber': phoneNumber,
      'streetAddress': streetAddress,
      'city': city,
      'subcity': subcity,
      'postalCode': postalCode,
      'isDefault': isDefault,
    };
  }

  factory ShippingAddress.fromJson(Map<String, dynamic> json) {
    return ShippingAddress(
      fullName: json['fullName'] as String,
      phoneNumber: json['phoneNumber'] as String,
      streetAddress: json['streetAddress'] as String,
      city: json['city'] as String,
      subcity: json['subcity'] as String,
      postalCode: json['postalCode'] as String? ?? '1000',
      isDefault: json['isDefault'] as bool? ?? true,
    );
  }
}
