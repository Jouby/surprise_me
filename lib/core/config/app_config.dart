class AppConfig {
  static const String pocketbaseUrl =
      'https://pb-surprise-me.thedeadmaskedcompany.com';

  static const String shareBaseUrl = 'https://jouby.github.io/surprise_me/join';

  static String shareUrl(String code) => '$shareBaseUrl/$code';
}
