class User {
  final String id;
  final String email;
  final String firstName;
  final String lastName;
  final String? phoneNumber;
  final String? profileImageUrl;
  final bool isPremium;
  final DateTime premiumExpiryDate;
  final List<String> purchasedGuides;
  final int totalListeningMinutes;
  final DateTime createdAt;
  final DateTime lastLoginAt;

  User({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    this.phoneNumber,
    this.profileImageUrl,
    required this.isPremium,
    required this.premiumExpiryDate,
    required this.purchasedGuides,
    required this.totalListeningMinutes,
    required this.createdAt,
    required this.lastLoginAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? '',
      email: json['email'] ?? '',
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      phoneNumber: json['phoneNumber'],
      profileImageUrl: json['profileImageUrl'],
      isPremium: json['isPremium'] ?? false,
      premiumExpiryDate: DateTime.parse(json['premiumExpiryDate'] ?? DateTime.now().toString()),
      purchasedGuides: List<String>.from(json['purchasedGuides'] ?? []),
      totalListeningMinutes: json['totalListeningMinutes'] ?? 0,
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toString()),
      lastLoginAt: DateTime.parse(json['lastLoginAt'] ?? DateTime.now().toString()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'phoneNumber': phoneNumber,
      'profileImageUrl': profileImageUrl,
      'isPremium': isPremium,
      'premiumExpiryDate': premiumExpiryDate.toIso8601String(),
      'purchasedGuides': purchasedGuides,
      'totalListeningMinutes': totalListeningMinutes,
      'createdAt': createdAt.toIso8601String(),
      'lastLoginAt': lastLoginAt.toIso8601String(),
    };
  }

  String get fullName => '$firstName $lastName';
}
