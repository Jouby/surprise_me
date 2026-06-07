class SupabaseConfig {
  // Remplacez ces valeurs par vos credentials Supabase
  // Project Settings → API → Project URL / anon public key
  static const String url = 'https://rmnhlamafcxuonnjpevm.supabase.co';
  static const String anonKey =
      'sb_publishable_0PEM-1faIPa6H_6_w2SmQA_7ljhmCvU';
}

class AppConfig {
  /// URL de base pour les liens de partage (deep links HTTPS).
  static const String shareBaseUrl =
      'https://jouby.github.io/surprise_me/join';

  /// Construit le lien de partage pour un code donné.
  static String shareUrl(String code) => '$shareBaseUrl/$code';
}
