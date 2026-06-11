import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../l10n/l10n.dart';

/// En debug : retourne le message complet de l'exception.
/// En release : retourne le message générique localisé.
String errorMessage(Object e, BuildContext context) {
  if (kDebugMode) return e.toString();
  return context.l10n.genericError;
}

/// Version sans contexte — pour les providers ou les couches sans widget.
/// En debug : retourne le message complet.
/// En release : retourne un message générique fixe.
String errorMessageRaw(Object e) {
  if (kDebugMode) return e.toString();
  return 'An error occurred. Please try again.';
}
