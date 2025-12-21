class AboutModel {
  final String vision;
  final String mission;

  AboutModel({
    required this.vision,
    required this.mission,
  });

  factory AboutModel.fromJson(Map<String, dynamic> json) {
    return AboutModel(
      vision: json['vision'] ?? '',
      mission: json['mission'] ?? '',
    );
  }
}
