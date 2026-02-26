class UserModel {
  final int id;
  final String fullName;
  final String email;
  final String? birthday;
  final String? gender;
  final String? phoneNumber;
  final String? address;

  UserModel({
    required this.id,
    required this.fullName,
    required this.email,
    this.birthday,
    this.gender,
    this.phoneNumber,
    this.address,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: int.tryParse(json['id']?.toString() ?? '') ?? 0,
      fullName: json['full_name'] as String? ?? '',
      email: json['email'] as String? ?? '',
      birthday: json['birthday'] as String?,
      gender: json['gender'] as String?,
      phoneNumber: json['phone_number'] as String?,
      address: json['address'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'full_name': fullName,
      'email': email,
      'birthday': birthday,
      'gender': gender,
      'phone_number': phoneNumber,
      'address': address,
    };
  }
}


