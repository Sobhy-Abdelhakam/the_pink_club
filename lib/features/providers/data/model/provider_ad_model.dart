class ProviderAdModel {
  final int id;
  final String name;
  final String nameEn;
  final String shortDesc;
  final String shortDescEn;
  final String details;
  final String detailsEn;
  final String image;

  ProviderAdModel({
    required this.id,
    required this.name,
    required this.nameEn,
    required this.shortDesc,
    required this.shortDescEn,
    required this.details,
    required this.detailsEn,
    required this.image,
  });

  factory ProviderAdModel.fromJson(Map<String, dynamic> json) {
    String imagePath = json['image'] ?? '';
    if (imagePath.isNotEmpty && !imagePath.startsWith('http')) {
      final cleanPath = imagePath.startsWith('/') ? imagePath : '/$imagePath';
      if (cleanPath.startsWith('/admin/')) {
        imagePath = 'https://thepinkclub.net$cleanPath';
      } else {
        imagePath = 'https://thepinkclub.net/admin$cleanPath';
      }
    }

    return ProviderAdModel(
      id: int.parse(json['id'].toString()),
      name: json['name'] ?? '',
      nameEn: json['name_en'] ?? '',
      shortDesc: json['short_desc'] ?? '',
      shortDescEn: json['short_desc_en'] ?? '',
      details: json['details'] ?? '',
      detailsEn: json['details_en'] ?? '',
      image: imagePath,
    );
  }
}
