class SubscriptionPackage {
  final int id;
  final String name;
  final double price;
  final List<String> features;

  SubscriptionPackage({
    required this.id,
    required this.name,
    required this.price,
    required this.features,
  });

  factory SubscriptionPackage.fromJson(Map<String, dynamic> json) {
    return SubscriptionPackage(
      id: json['id'] is int ? json['id'] : int.parse(json['id'].toString()),
      name: json['title'] ?? json['name'] ?? '',
      price: json['price'] != null ? double.parse(json['price'].toString()) : 0.0,
      features: json['features'] != null ? List<String>.from(json['features']) : [],
    );
  }
}
