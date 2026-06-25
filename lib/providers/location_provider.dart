import 'package:flutter/material.dart';
import '../models/location_model.dart';
import '../services/api_service.dart';

class LocationProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  
  List<Location> _locations = [];
  Location? _currentLocation;
  bool _isLoading = false;
  String? _error;

  List<Location> get locations => _locations;
  Location? get currentLocation => _currentLocation;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // ==================== Fetch Locations by Country ====================
  Future<void> fetchLocationsByCountry(String countryId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _locations = await _apiService.getLocationsByCountry(countryId);
      _error = null;
    } catch (e) {
      _error = 'Failed to load locations: $e';
      _locations = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // ==================== Get Single Location ====================
  Future<void> getLocationById(String locationId) async {
    try {
      _currentLocation = await _apiService.getLocationById(locationId);
      notifyListeners();
    } catch (e) {
      _error = 'Failed to load location: $e';
      notifyListeners();
    }
  }

  // ==================== Get Audio Stream URL ====================
  Future<String?> getAudioStreamUrl(String locationId, {int? limitSeconds}) async {
    try {
      return await _apiService.getAudioStreamUrl(locationId, limitSeconds: limitSeconds);
    } catch (e) {
      _error = 'Failed to get audio stream: $e';
      notifyListeners();
      return null;
    }
  }

  // ==================== Add Location (Admin) ====================
  Future<bool> addLocation(Location location) async {
    try {
      bool success = await _apiService.addLocation(location);
      if (success) {
        _locations.add(location);
        notifyListeners();
      }
      return success;
    } catch (e) {
      _error = 'Failed to add location: $e';
      notifyListeners();
      return false;
    }
  }

  // ==================== Update Location (Admin) ====================
  Future<bool> updateLocation(Location location) async {
    try {
      bool success = await _apiService.updateLocation(location);
      if (success) {
        int index = _locations.indexWhere((l) => l.id == location.id);
        if (index != -1) {
          _locations[index] = location;
          notifyListeners();
        }
      }
      return success;
    } catch (e) {
      _error = 'Failed to update location: $e';
      notifyListeners();
      return false;
    }
  }

  // ==================== Delete Location (Admin) ====================
  Future<bool> deleteLocation(String locationId) async {
    try {
      bool success = await _apiService.deleteLocation(locationId);
      if (success) {
        _locations.removeWhere((l) => l.id == locationId);
        notifyListeners();
      }
      return success;
    } catch (e) {
      _error = 'Failed to delete location: $e';
      notifyListeners();
      return false;
    }
  }
}
