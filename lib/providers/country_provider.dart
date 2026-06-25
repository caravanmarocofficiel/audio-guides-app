import 'package:flutter/material.dart';
import '../models/country_model.dart';
import '../services/api_service.dart';

class CountryProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  
  List<Country> _countries = [];
  bool _isLoading = false;
  String? _error;

  List<Country> get countries => _countries;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // ==================== Fetch Countries ====================
  Future<void> fetchCountries() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _countries = await _apiService.getCountries();
      _error = null;
    } catch (e) {
      _error = 'Failed to load countries: $e';
      _countries = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // ==================== Get Single Country ====================
  Future<Country?> getCountryById(String id) async {
    try {
      return await _apiService.getCountryById(id);
    } catch (e) {
      _error = 'Failed to load country: $e';
      notifyListeners();
      return null;
    }
  }

  // ==================== Add Country (Admin) ====================
  Future<bool> addCountry(Country country) async {
    try {
      bool success = await _apiService.addCountry(country);
      if (success) {
        _countries.add(country);
        notifyListeners();
      }
      return success;
    } catch (e) {
      _error = 'Failed to add country: $e';
      notifyListeners();
      return false;
    }
  }

  // ==================== Update Country (Admin) ====================
  Future<bool> updateCountry(Country country) async {
    try {
      bool success = await _apiService.updateCountry(country);
      if (success) {
        int index = _countries.indexWhere((c) => c.id == country.id);
        if (index != -1) {
          _countries[index] = country;
          notifyListeners();
        }
      }
      return success;
    } catch (e) {
      _error = 'Failed to update country: $e';
      notifyListeners();
      return false;
    }
  }

  // ==================== Delete Country (Admin) ====================
  Future<bool> deleteCountry(String countryId) async {
    try {
      bool success = await _apiService.deleteCountry(countryId);
      if (success) {
        _countries.removeWhere((c) => c.id == countryId);
        notifyListeners();
      }
      return success;
    } catch (e) {
      _error = 'Failed to delete country: $e';
      notifyListeners();
      return false;
    }
  }
}
