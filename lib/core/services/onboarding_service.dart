import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingService {
  static const _homeKey = 'onboarding_done';
  static const _detailKey = 'onboarding_detail_done';

  /// Retourne le share_code de la surprise d'onboarding selon la locale.
  static String onboardingCode(Locale locale) {
    switch (locale.languageCode) {
      case 'fr':
        return 'ONBFR';
      case 'es':
        return 'ONBES';
      default:
        return 'ONBEN';
    }
  }

  /// Retourne le code du premier élément à saisir sur la page détail.
  static String firstElementCode(Locale locale) {
    switch (locale.languageCode) {
      case 'fr':
        return 'DEBUT';
      case 'es':
        return 'INICIO';
      default:
        return 'START';
    }
  }

  // ── Home ──────────────────────────────────────────────────────────────────

  static Future<bool> isFirstLaunch() async {
    final prefs = await SharedPreferences.getInstance();
    return !(prefs.getBool(_homeKey) ?? false);
  }

  static Future<void> markDone() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_homeKey, true);
  }

  // ── Detail ────────────────────────────────────────────────────────────────

  static Future<bool> isDetailFirstVisit() async {
    final prefs = await SharedPreferences.getInstance();
    return !(prefs.getBool(_detailKey) ?? false);
  }

  static Future<void> markDetailDone() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_detailKey, true);
  }
}
