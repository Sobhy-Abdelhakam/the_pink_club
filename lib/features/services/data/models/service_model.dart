class ServiceModel {
  final int id;
  final String title;
  final String description;
  final String icon;
  final String color;
  final String? image;
  final List<String> features;

  ServiceModel({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    this.image,
    required this.features,
  });

  factory ServiceModel.fromJson(Map<String, dynamic> json) {
    return ServiceModel(
      id: int.parse(json['id'].toString()),
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      icon: json['icon'] ?? '',
      color: json['color'] ?? '#000000',
      image: json['image'],
      features: List<String>.from(json['features'] ?? []),
    );
  }
}
