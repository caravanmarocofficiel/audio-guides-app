class Country {
  final String id;
  final String name;
  final String nameAr;
  final String description;
  final String descriptionAr;
  final String flagUrl;
  final String imageUrl;
  final int locationsCount;
  final double rating;
  final DateTime createdAt;

  Country({
    required this.id,
    required this.name,
    required this.nameAr,
    required this.description,
    required this.descriptionAr,
    required this.flagUrl,
    required this.imageUrl,
    required this.locationsCount,
    required this.rating,
    required this.createdAt,
  });

  factory Country.fromJson(Map<String, dynamic> json) {
    return Country(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      nameAr: json['nameAr'] ?? '',
      description: json['description'] ?? '',
      descriptionAr: json['descriptionAr'] ?? '',
      flagUrl: json['flagUrl'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      locationsCount: json['locationsCount'] ?? 0,
      rating: (json['rating'] ?? 0).toDouble(),
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toString()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'nameAr': nameAr,
      'description': description,
      'descriptionAr': descriptionAr,
      'flagUrl': flagUrl,
      'imageUrl': imageUrl,
      'locationsCount': locationsCount,
      'rating': rating,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
