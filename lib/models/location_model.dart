class Location {
  final String id;
  final String countryId;
  final String name;
  final String nameAr;
  final String description;
  final String descriptionAr;
  final String imageUrl;
  final double latitude;
  final double longitude;
  final String audioUrl;
  final int audioDuration; // بالثواني
  final double rating;
  final bool isPremium;
  final DateTime createdAt;

  Location({
    required this.id,
    required this.countryId,
    required this.name,
    required this.nameAr,
    required this.description,
    required this.descriptionAr,
    required this.imageUrl,
    required this.latitude,
    required this.longitude,
    required this.audioUrl,
    required this.audioDuration,
    required this.rating,
    required this.isPremium,
    required this.createdAt,
  });

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      id: json['id'] ?? '',
      countryId: json['countryId'] ?? '',
      name: json['name'] ?? '',
      nameAr: json['nameAr'] ?? '',
      description: json['description'] ?? '',
      descriptionAr: json['descriptionAr'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      latitude: (json['latitude'] ?? 0).toDouble(),
      longitude: (json['longitude'] ?? 0).toDouble(),
      audioUrl: json['audioUrl'] ?? '',
      audioDuration: json['audioDuration'] ?? 0,
      rating: (json['rating'] ?? 0).toDouble(),
      isPremium: json['isPremium'] ?? false,
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toString()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'countryId': countryId,
      'name': name,
      'nameAr': nameAr,
      'description': description,
      'descriptionAr': descriptionAr,
      'imageUrl': imageUrl,
      'latitude': latitude,
      'longitude': longitude,
      'audioUrl': audioUrl,
      'audioDuration': audioDuration,
      'rating': rating,
      'isPremium': isPremium,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
