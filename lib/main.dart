import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'core/config/supabase_config.dart';
import 'core/theme/app_theme.dart';

// ── Surprise feature ─────────────────────────────────────────────────────────
import 'features/surprise/data/datasources/surprise_local_datasource.dart';
import 'features/surprise/data/datasources/surprise_remote_datasource.dart';
import 'features/surprise/data/repositories/surprise_repository_impl.dart';
import 'features/surprise/domain/repositories/i_surprise_repository.dart';
import 'features/surprise/domain/usecases/create_surprise_usecase.dart';
import 'features/surprise/domain/usecases/delete_surprise_usecase.dart';
import 'features/surprise/domain/usecases/fetch_surprises_usecase.dart';
import 'features/surprise/domain/usecases/join_surprise_usecase.dart';
import 'features/surprise/domain/usecases/update_surprise_usecase.dart';
import 'features/surprise/domain/usecases/upload_image_usecase.dart';
import 'features/surprise/presentation/providers/surprise_provider.dart';
import 'features/surprise/presentation/screens/home_screen.dart';

// ── Unlock feature ────────────────────────────────────────────────────────────
import 'features/unlock/data/datasources/unlock_local_datasource.dart';
import 'features/unlock/data/repositories/unlock_repository_impl.dart';
import 'features/unlock/domain/usecases/is_unlocked_usecase.dart';
import 'features/unlock/domain/usecases/try_unlock_usecase.dart';
import 'features/unlock/presentation/providers/unlock_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  await Supabase.initialize(
    url: SupabaseConfig.url,
    // ignore: deprecated_member_use
    anonKey: SupabaseConfig.anonKey,
  );

  // ── Wiring ─────────────────────────────────────────────────────────────────

  final supabaseClient = Supabase.instance.client;

  // Surprise
  final surpriseRemoteDs = SurpriseRemoteDatasource(supabaseClient);
  final surpriseLocalDs = SurpriseLocalDatasource();
  final surpriseRepo = SurpriseRepositoryImpl(
    surpriseRemoteDs,
    surpriseLocalDs,
  );

  // Génère le token utilisateur dès le démarrage s'il n'existe pas encore.
  await surpriseLocalDs.getUserToken();

  final fetchSurprises = FetchSurprisesUseCase(surpriseRepo);
  final createSurprise = CreateSurpriseUseCase(surpriseRepo);
  final joinSurprise = JoinSurpriseUseCase(surpriseRepo);
  final updateSurprise = UpdateSurpriseUseCase(surpriseRepo);
  final deleteSurprise = DeleteSurpriseUseCase(surpriseRepo);
  final uploadImage = UploadImageUseCase(surpriseRepo);

  // Unlock
  final unlockLocalDs = UnlockLocalDatasource();
  final unlockRepo = UnlockRepositoryImpl(unlockLocalDs);
  final tryUnlock = TryUnlockUseCase(unlockRepo);
  final isUnlocked = IsUnlockedUseCase(unlockRepo);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => SurpriseProvider(
            fetchSurprises: fetchSurprises,
            createSurprise: createSurprise,
            joinSurprise: joinSurprise,
            deleteSurprise: deleteSurprise,
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => UnlockProvider(
            tryUnlock: tryUnlock,
            isUnlocked: isUnlocked,
            repository: unlockRepo,
          ),
        ),
        // Use cases fournis aux screens qui en ont besoin directement
        Provider<UpdateSurpriseUseCase>.value(value: updateSurprise),
        Provider<UploadImageUseCase>.value(value: uploadImage),
        Provider<ISurpriseRepository>.value(value: surpriseRepo),
      ],
      child: const SurpriseMeApp(),
    ),
  );
}

class SurpriseMeApp extends StatefulWidget {
  const SurpriseMeApp({super.key});

  @override
  State<SurpriseMeApp> createState() => _SurpriseMeAppState();
}

class _SurpriseMeAppState extends State<SurpriseMeApp> {
  final _navigatorKey = GlobalKey<NavigatorState>();
  late final AppLinks _appLinks;

  @override
  void initState() {
    super.initState();
    _initDeepLinks();
  }

  /// Extrait le code de partage depuis un URI deep link.
  /// Formats supportés :
  ///   surpriseme://join/CODE
  ///   https://jouby.github.io/surprise_me/join/CODE
  String? _extractCode(Uri uri) {
    // Scheme custom
    if (uri.scheme == 'surpriseme' && uri.host == 'join') {
      final code = uri.pathSegments.firstOrNull?.trim().toUpperCase();
      return (code?.isNotEmpty == true) ? code : null;
    }
    // Lien HTTPS GitHub Pages
    if ((uri.scheme == 'https' || uri.scheme == 'http') &&
        uri.host == 'jouby.github.io') {
      final segments = uri.pathSegments;
      // pathSegments = ['surprise_me', 'join', 'CODE']
      final joinIdx = segments.indexOf('join');
      if (joinIdx != -1 && joinIdx + 1 < segments.length) {
        final code = segments[joinIdx + 1].trim().toUpperCase();
        return code.isNotEmpty ? code : null;
      }
    }
    return null;
  }

  void _handleIncomingLink(Uri uri) {
    final code = _extractCode(uri);
    if (code == null) return;

    // Récupère le HomeScreen via la clé navigator et déclenche le join
    final context = _navigatorKey.currentContext;
    if (context == null) return;

    // Remonte à la racine puis ouvre la sheet de join avec le code pré-rempli
    _navigatorKey.currentState?.popUntil((route) => route.isFirst);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final ctx = _navigatorKey.currentContext;
      if (ctx == null) return;
      HomeScreen.openJoinSheet(ctx, initialCode: code);
    });
  }

  Future<void> _initDeepLinks() async {
    _appLinks = AppLinks();

    // Lien qui a lancé l'app (cold start)
    try {
      final initialUri = await _appLinks.getInitialLink();
      if (initialUri != null) {
        // On attend que le widget tree soit monté
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _handleIncomingLink(initialUri);
        });
      }
    } catch (_) {}

    // Liens reçus pendant que l'app est en arrière-plan (warm start)
    _appLinks.uriLinkStream.listen(_handleIncomingLink, onError: (_) {});
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: _navigatorKey,
      title: 'Surprise Me',
      theme: AppTheme.theme,
      debugShowCheckedModeBanner: false,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      home: const HomeScreen(),
    );
  }
}
