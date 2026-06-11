import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

class PremiumProvider extends ChangeNotifier {
  static const _entitlement = 'premium';
  static const _appleApiKey = 'appl_yNRtTwKxQbUGqaAJrUBlcRNzRud';
  static const _googleApiKey = 'goog_mFlzUvgfzXIdJHMjMgkrwKAikYs';

  bool _isPremium = false;
  bool _isLoading = true;
  String? _error;

  bool get isPremium => _isPremium;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> init() async {
    try {
      final apiKey = Platform.isIOS ? _appleApiKey : _googleApiKey;
      await Purchases.setLogLevel(LogLevel.error);
      await Purchases.configure(PurchasesConfiguration(apiKey));
      await _refresh();
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> _refresh() async {
    try {
      final info = await Purchases.getCustomerInfo();
      _isPremium = info.entitlements.active.containsKey(_entitlement);
    } catch (_) {}
    _isLoading = false;
    notifyListeners();
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
