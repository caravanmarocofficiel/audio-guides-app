import 'package:dio/dio.dart';
import '../config/app_config.dart';
import '../models/country_model.dart';
import '../models/location_model.dart';

class ApiService {
  late final Dio _dio;
  
  static final ApiService _instance = ApiService._internal();

  ApiService._internal() {
    _dio = Dio(
      BaseOptions(
        baseUrl: AppConfig.apiBaseUrl + AppConfig.apiVersion,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    // Add interceptors for logging
    _dio.interceptors.add(
      LogInterceptor(
        requestBody: true,
        responseBody: true,
      ),
    );
  }

  factory ApiService() {
    return _instance;
  }

  // ==================== Countries ====================
  Future<List<Country>> getCountries() async {
    try {
      final response = await _dio.get('/countries');
      List<Country> countries = (response.data as List)
          .map((json) => Country.fromJson(json))
          .toList();
      return countries;
    } catch (e) {
      rethrow;
    }
  }

  Future<Country?> getCountryById(String countryId) async {
    try {
      final response = await _dio.get('/countries/$countryId');
      return Country.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  // ==================== Locations ====================
  Future<List<Location>> getLocationsByCountry(String countryId) async {
    try {
      final response = await _dio.get('/locations', queryParameters: {
        'countryId': countryId,
      });
      List<Location> locations = (response.data as List)
          .map((json) => Location.fromJson(json))
          .toList();
      return locations;
    } catch (e) {
      rethrow;
    }
  }

  Future<Location?> getLocationById(String locationId) async {
    try {
      final response = await _dio.get('/locations/$locationId');
      return Location.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  Future<String> getAudioStreamUrl(String locationId, {int? limitSeconds}) async {
    try {
      final response = await _dio.get(
        '/locations/$locationId/audio-stream',
        queryParameters: {
          if (limitSeconds != null) 'limit_seconds': limitSeconds,
        },
      );
      return response.data['url'] ?? '';
    } catch (e) {
      rethrow;
    }
  }

  // ==================== User Data ====================
  Future<Map<String, dynamic>> getUserProfile(String userId) async {
    try {
      final response = await _dio.get('/users/$userId/profile');
      return response.data ?? {};
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> recordListeningSession(
    String userId,
    String locationId,
    int secondsListened,
  ) async {
    try {
      await _dio.post('/users/$userId/listening-sessions', data: {
        'locationId': locationId,
        'secondsListened': secondsListened,
        'timestamp': DateTime.now().toIso8601String(),
      });
      return true;
    } catch (e) {
      rethrow;
    }
  }

  // ==================== Admin Endpoints ====================
  Future<bool> addCountry(Country country) async {
    try {
      await _dio.post('/admin/countries', data: country.toJson());
      return true;
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> addLocation(Location location) async {
    try {
      await _dio.post('/admin/locations', data: location.toJson());
      return true;
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> updateCountry(Country country) async {
    try {
      await _dio.put('/admin/countries/${country.id}', data: country.toJson());
      return true;
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> updateLocation(Location location) async {
    try {
      await _dio.put('/admin/locations/${location.id}', data: location.toJson());
      return true;
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> deleteCountry(String countryId) async {
    try {
      await _dio.delete('/admin/countries/$countryId');
      return true;
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> deleteLocation(String locationId) async {
    try {
      await _dio.delete('/admin/locations/$locationId');
      return true;
    } catch (e) {
      rethrow;
    }
  }
}
