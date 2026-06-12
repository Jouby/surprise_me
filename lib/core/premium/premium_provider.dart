import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

import '../utils/error_utils.dart';

class PremiumProvider extends ChangeNotifier {
  static const _entitlement = 'premium';
  static const _appleApiKey = 'appl_yNRtTwKxQbUGqaAJrUBlcRNzRud';
  static const _googleApiKey = 'goog_mFlzUvgfzXIdJHMjMgkrwKAikYs';

  bool _isPremium = false;
  bool _isLoading = true;
  String? _error;
  bool? _debugOverride;
  String? _priceString;

  bool get isPremium =>
      kDebugMode ? (_debugOverride ?? _isPremium) : _isPremium;
  bool get isLoading => _isLoading;
  String? get error => _error;
  String? get priceString => _priceString;

  Future<void> init() async {
    try {
      final apiKey = Platform.isIOS ? _appleApiKey : _googleApiKey;
      await Purchases.setLogLevel(LogLevel.error);
      await Purchases.configure(PurchasesConfiguration(apiKey));
      await _refresh();
    } catch (e) {
      _isLoading = false;
      _error = errorMessageRaw(e);
      notifyListeners();
    }
  }

  Future<void> _refresh() async {
    try {
      final info = await Purchases.getCustomerInfo();
      _isPremium = info.entitlements.active.containsKey(_entitlement);
    } catch (_) {}
    _isLoading = false;
    unawaited(_fetchPrice());
    notifyListeners();
  }

  Future<void> _fetchPrice() async {
    try {
      final offerings = await Purchases.getOfferings();
      final price = offerings.current?.lifetime?.storeProduct.priceString;
      if (price != null && price != _priceString) {
        _priceString = price;
        notifyListeners();
      }
    } catch (_) {}
  }

  Future<bool> purchase() async {
    try {
      final offerings = await Purchases.getOfferings();
      final package = offerings.current?.lifetime;
      if (package == null) return false;
      final info = await Purchases.purchasePackage(package);
      _isPremium = info.entitlements.active.containsKey(_entitlement);
      notifyListeners();
      return _isPremium;
    } on PurchasesErrorCode catch (e) {
      if (e == PurchasesErrorCode.purchaseCancelledError) return false;
      rethrow;
    }
  }

  void debugSetPremium(bool value) {
    assert(kDebugMode, 'debugSetPremium is only available in debug mode');
    _debugOverride = value;
    notifyListeners();
  }

  Future<bool> restore() async {
    try {
      final info = await Purchases.restorePurchases();
      _isPremium = info.entitlements.active.containsKey(_entitlement);
      notifyListeners();
      return _isPremium;
    } catch (_) {
      return false;
    }
  }
}
