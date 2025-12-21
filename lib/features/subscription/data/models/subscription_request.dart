class SubscriptionRequest {
  final String fullName;
  final String birthday;
  final String gender;
  final String phone;
  final String address;
  final String carBrand;
  final String carModel;
  final String carMadeYear;
  final String carChassis;
  final String carPlate;
  final String packageId;
  final String paymentMethod;

  SubscriptionRequest({
    required this.fullName,
    required this.birthday,
    required this.gender,
    required this.phone,
    required this.address,
    required this.carBrand,
    required this.carModel,
    required this.carMadeYear,
    required this.carChassis,
    required this.carPlate,
    required this.packageId,
    required this.paymentMethod,
  });

  Map<String, dynamic> toJson() {
    return {
      'full_name': fullName,
      'birthday': birthday,
      'gender': gender,
      'phone': phone,
      'address': address,
      'car_brand': carBrand,
      'car_model': carModel,
      'car_made_year': carMadeYear,
      'car_chassis': carChassis,
      'car_plate': carPlate,
      'package_id': packageId,
      'payment_method': paymentMethod,
    };
  }
}
