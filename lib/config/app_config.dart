class AppConfig {
  // API Configuration
  static const String apiBaseUrl = 'https://api.audioguides.app';
  static const String apiVersion = '/v1';
  
  // Payment Configuration
  static const String appleBundleId = 'com.audioguides.app.ios';
  static const String googlePackageName = 'com.audioguides.app';
  
  // In-App Purchase Product IDs
  static const String premiumMonthlyProductId = 'premium_monthly';
  static const String premiumAnnualProductId = 'premium_annual';
  static const String singleGuideProductId = 'single_guide';
  
  // Trial Configuration
  static const int freeTrialSeconds = 60; // 60 ثانية مجانية
  
  // Firebase Configuration
  static const String firebaseProjectId = 'audio-guides-production';
  
  // Admin Configuration
  static const String adminEmail = 'admin@audioguides.app';
  static const String adminPassword = 'CHANGE_ME_IN_PRODUCTION'; // غيّر هذا!
  
  // Supported Countries (يمكن إضافة المزيد)
  static const List<String> supportedCountries = [
    'morocco',
    'egypt',
    'saudi_arabia',
    'dubai',
    'turkey',
    'france',
    'italy',
    'spain',
  ];
}
