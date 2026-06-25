import 'package:flutter/material.dart';
import '../services/payment_service.dart';
import '../models/user_model.dart';

class PaymentProvider extends ChangeNotifier {
  final PaymentService _paymentService = PaymentService();
  
  bool _isPremium = false;
  DateTime? _premiumExpiryDate;
  bool _isProcessing = false;
  String? _error;
  List<String> _purchasedGuides = [];

  bool get isPremium => _isPremium;
  DateTime? get premiumExpiryDate => _premiumExpiryDate;
  bool get isProcessing => _isProcessing;
  String? get error => _error;
  List<String> get purchasedGuides => _purchasedGuides;

  // ==================== Check Trial Eligibility ====================
  bool get canUseTrial => !_purchasedGuides.isEmpty || !_isPremium;

  // ==================== Purchase Premium Monthly ====================
  Future<bool> purchasePremiumMonthly() async {
    _isProcessing = true;
    _error = null;
    notifyListeners();

    try {
      bool success = await _paymentService.purchasePremiumMonthly();
      if (success) {
        _isPremium = true;
        _premiumExpiryDate = DateTime.now().add(const Duration(days: 30));
        _error = null;
      } else {
        _error = 'Purchase failed';
      }
      return success;
    } catch (e) {
      _error = 'Payment error: $e';
      return false;
    } finally {
      _isProcessing = false;
      notifyListeners();
    }
  }

  // ==================== Purchase Premium Annual ====================
  Future<bool> purchasePremiumAnnual() async {
    _isProcessing = true;
    _error = null;
    notifyListeners();

    try {
      bool success = await _paymentService.purchasePremiumAnnual();
      if (success) {
        _isPremium = true;
        _premiumExpiryDate = DateTime.now().add(const Duration(days: 365));
        _error = null;
      } else {
        _error = 'Purchase failed';
      }
      return success;
    } catch (e) {
      _error = 'Payment error: $e';
      return false;
    } finally {
      _isProcessing = false;
      notifyListeners();
    }
  }

  // ==================== Purchase Single Guide ====================
  Future<bool> purchaseSingleGuide(String locationId, double price) async {
    _isProcessing = true;
    _error = null;
    notifyListeners();

    try {
      bool success = await _paymentService.purchaseSingleGuide(locationId, price);
      if (success) {
        if (!_purchasedGuides.contains(locationId)) {
          _purchasedGuides.add(locationId);
        }
        _error = null;
      } else {
        _error = 'Purchase failed';
      }
      return success;
    } catch (e) {
      _error = 'Payment error: $e';
      return false;
    } finally {
      _isProcessing = false;
      notifyListeners();
    }
  }

  // ==================== Check if Guide is Purchased ====================
  bool isGuidePurchased(String locationId) {
    return _isPremium || _purchasedGuides.contains(locationId);
  }

  // ==================== Update User Subscription ====================
  void updateFromUser(User user) {
    _isPremium = user.isPremium;
    _premiumExpiryDate = user.premiumExpiryDate;
    _purchasedGuides = user.purchasedGuides;
    notifyListeners();
  }
}
