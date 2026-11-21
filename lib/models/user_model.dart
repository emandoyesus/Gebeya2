class UserModel {
  final String id;
  final String fullName;
  final String email;
  final String phoneNumber;
  final String defaultCity;
  final String defaultSubcity;
  final String defaultStreet;
  final bool isVerified;
  final DateTime createdAt;

  const UserModel({
    required this.id,
    required this.fullName,
    required this.email,
    required this.phoneNumber,
    this.defaultCity = 'Addis Ababa',
    this.defaultSubcity = 'Bole',
    this.defaultStreet = 'Bole Medhanialem, Olympia St.',
    this.isVerified = true,
    required this.createdAt,
  });

  UserModel copyWith({
    String? id,
    String? fullName,
    String? email,
    String? phoneNumber,
    String? defaultCity,
    String? defaultSubcity,
    String? defaultStreet,
    bool? isVerified,
    DateTime? createdAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      defaultCity: defaultCity ?? this.defaultCity,
      defaultSubcity: defaultSubcity ?? this.defaultSubcity,
      defaultStreet: defaultStreet ?? this.defaultStreet,
      isVerified: isVerified ?? this.isVerified,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullName': fullName,
      'email': email,
      'phoneNumber': phoneNumber,
      'defaultCity': defaultCity,
      'defaultSubcity': defaultSubcity,
      'defaultStreet': defaultStreet,
      'isVerified': isVerified,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      fullName: json['fullName'] as String,
      email: json['email'] as String,
      phoneNumber: json['phoneNumber'] as String,
      defaultCity: json['defaultCity'] as String? ?? 'Addis Ababa',
      defaultSubcity: json['defaultSubcity'] as String? ?? 'Bole',
      defaultStreet: json['defaultStreet'] as String? ?? 'Bole Medhanialem, Olympia St.',
      isVerified: json['isVerified'] as bool? ?? true,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : DateTime.now(),
    );
  }
}
