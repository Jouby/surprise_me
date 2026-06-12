import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingService {
  static const _doneKey = 'onboarding_done';

  /// Retourne le share_code de la surprise d'onboarding selon la locale.
  /// Actuellement seul le français est disponible ; toutes les autres langues
  /// utilisent également la version FR par défaut.
  static String onboardingCode(Locale locale) {
    switch (locale.languageCode) {
      case 'fr':
        return 'ONBFR';
      default:
        return 'ONBFR';
    }
  }

  static Future<bool> isFirstLaunch() async {
    final prefs = await SharedPreferences.getInstance();
    return !(prefs.getBool(_doneKey) ?? false);
  }

  static Future<void> markDone() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_doneKey, true);
  }
}
