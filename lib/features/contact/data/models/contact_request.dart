class ContactRequest {
  final String name;
  final String email;
  final String phone;
  final String message;

  ContactRequest({
    required this.name,
    required this.email,
    required this.phone,
    required this.message,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'phone': phone,
      'message': message,
    };
  }
}
