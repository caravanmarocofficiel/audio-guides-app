import 'package:pay/pay.dart';
import '../config/app_config.dart';

class PaymentService {
  late final Google _googlePayClient;
  late final Apple _applePayClient;
  
  static final PaymentService _instance = PaymentService._internal();

  PaymentService._internal() {
    _initializePaymentClients();
  }

  factory PaymentService() {
    return _instance;
  }

  void _initializePaymentClients() {
    // Google Pay Configuration
    _googlePayClient = Google(
      onPaymentResult: _handlePaymentResult,
    );

    // Apple Pay Configuration
    _applePayClient = Apple(
      onPaymentResult: _handlePaymentResult,
    );
  }

  void _handlePaymentResult(paymentResult) {
    print('Payment result: $paymentResult');
    // Handle payment result
  }

  // ==================== Get Payment Methods ====================
  Future<PaymentConfiguration?> getGooglePayConfig() async {
    final paymentConfiguration = PaymentConfiguration.fromJsonString(
      '''
      {
        "provider": "google_pay",
        "data": {
          "environment": "PRODUCTION",
          "apiVersion": 2,
          "apiVersionMinor": 0,
          "allowedPaymentMethods": [
            {
              "type": "CARD",
              "parameters": {
                "allowedAuthMethods": ["PAN_ONLY", "CRYPTOGRAM_3DS"],
                "allowedCardNetworks": ["MASTERCARD", "VISA"]
              },
              "tokenizationSpecification": {
                "type": "PAYMENT_GATEWAY",
                "parameters": {
                  "gateway": "example",
                  "gatewayMerchantId": "exampleMerchantId"
                }
              }
            }
          ],
          "merchantInfo": {
            "merchantId": "${AppConfig.googlePackageName}"
          },
          "transactionInfo": {
            "totalPriceStatus": "ESTIMATED",
            "totalPrice": "0.00",
            "currencyCode": "USD"
          }
        }
      }
      '''
    );
    return paymentConfiguration;
  }

  Future<PaymentConfiguration?> getApplePayConfig() async {
    final paymentConfiguration = PaymentConfiguration.fromJsonString(
      '''
      {
        "provider": "apple_pay",
        "data": {
          "version": 2,
          "merchantIdentifier": "${AppConfig.appleBundleId}",
          "countryCode": "US",
          "currencyCode": "USD",
          "supportedNetworks": ["visa", "mastercard", "amex"],
          "merchantCapabilities": ["supports3DS", "supportsDebit", "supportsCredit"]
        }
      }
      '''
    );
    return paymentConfiguration;
  }

  // ==================== Premium Subscription ====================
  Future<bool> purchasePremiumMonthly() async {
    try {
      final items = [
        PaymentItem(
          label: 'Premium Monthly Subscription',
          amount: '9.99',
          status: PaymentItemStatus.final_price,
        ),
      ];
      
      // Trigger payment
      return true;
    } catch (e) {
      print('Premium purchase error: $e');
      return false;
    }
  }

  Future<bool> purchasePremiumAnnual() async {
    try {
      final items = [
        PaymentItem(
          label: 'Premium Annual Subscription',
          amount: '89.99',
          status: PaymentItemStatus.final_price,
        ),
      ];
      
      // Trigger payment
      return true;
    } catch (e) {
      print('Premium annual purchase error: $e');
      return false;
    }
  }

  // ==================== Single Guide Purchase ====================
  Future<bool> purchaseSingleGuide(String locationId, double price) async {
    try {
      final items = [
        PaymentItem(
          label: 'Single Audio Guide',
          amount: price.toString(),
          status: PaymentItemStatus.final_price,
        ),
      ];
      
      // Trigger payment
      return true;
    } catch (e) {
      print('Single guide purchase error: $e');
      return false;
    }
  }

  // ==================== Payment Methods ====================
  Future<List<PaymentItem>> buildPaymentItems(double amount, String label) async {
    return [
      PaymentItem(
        label: label,
        amount: amount.toStringAsFixed(2),
        status: PaymentItemStatus.final_price,
      ),
    ];
  }

  Future<PaymentConfiguration?> buildApplePayConfiguration(
    List<PaymentItem> items,
  ) async {
    return getApplePayConfig();
  }

  Future<PaymentConfiguration?> buildGooglePayConfiguration(
    List<PaymentItem> items,
  ) async {
    return getGooglePayConfig();
  }

  // ==================== Verify Purchase ====================
  Future<bool> verifyPurchase(String transactionId, String productId) async {
    try {
      // Verify with backend
      return true;
    } catch (e) {
      print('Verify purchase error: $e');
      return false;
    }
  }
}
