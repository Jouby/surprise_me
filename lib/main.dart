import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'core/config/supabase_config.dart';
import 'core/theme/app_theme.dart';

// ── Surprise feature ─────────────────────────────────────────────────────────
import 'features/surprise/data/datasources/surprise_local_datasource.dart';
import 'features/surprise/data/datasources/surprise_remote_datasource.dart';
import 'features/surprise/data/repositories/surprise_repository_impl.dart';
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
  final surpriseRepo = SurpriseRepositoryImpl(surpriseRemoteDs, surpriseLocalDs);

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
      ],
      child: const SurpriseMeApp(),
    ),
  );
}

class SurpriseMeApp extends StatelessWidget {
  const SurpriseMeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Surprise Me',
      theme: AppTheme.theme,
      debugShowCheckedModeBanner: false,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('fr')],
      locale: const Locale('fr'),
      home: const HomeScreen(),
    );
  }
}
