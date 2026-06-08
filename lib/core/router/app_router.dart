import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/settings/presentation/screens/settings_screen.dart';
import '../../features/surprise/domain/entities/surprise.dart';
import '../../features/surprise/presentation/screens/create_surprise_screen.dart';
import '../../features/surprise/presentation/screens/edit_surprise_screen.dart';
import '../../features/surprise/presentation/screens/home_screen.dart';
import '../../features/surprise/presentation/screens/surprise_detail_screen.dart';
import '../../features/motus_game/presentation/screens/motus_game_screen.dart';

// ─── Args ─────────────────────────────────────────────────────────────────────

/// Paramètres passés via [GoRouter.extra] pour les routes de détail.
class SurpriseRouteArgs {
  final Surprise surprise;
  final bool isOwner;

  const SurpriseRouteArgs({required this.surprise, this.isOwner = false});
}

/// Paramètres passés via [GoRouter.extra] pour la route du jeu Motus.
class MotusRouteArgs {
  final String word;
  final Color themeColor;

  const MotusRouteArgs({required this.word, required this.themeColor});
}

// ─── Router ───────────────────────────────────────────────────────────────────

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomeScreen(),
      routes: [
        GoRoute(
          path: 'create',
          builder: (context, state) => const CreateSurpriseScreen(),
        ),
        GoRoute(
          path: 'settings',
          builder: (context, state) => const SettingsScreen(),
        ),
        GoRoute(
          path: 'surprise/:id',
          builder: (context, state) {
            final args = state.extra as SurpriseRouteArgs;
            return SurpriseDetailScreen(
              surprise: args.surprise,
              isOwner: args.isOwner,
            );
          },
          routes: [
            GoRoute(
              path: 'edit',
              builder: (context, state) =>
                  EditSurpriseScreen(surprise: state.extra as Surprise),
            ),
            GoRoute(
              path: 'preview',
              builder: (context, state) => SurpriseDetailScreen(
                surprise: state.extra as Surprise,
                previewMode: true,
              ),
            ),
          ],
        ),
      ],
    ),

    // Jeu Motus plein écran
    GoRoute(
      path: '/motus',
      builder: (context, state) {
        final args = state.extra as MotusRouteArgs;
        return MotusGameScreen(word: args.word, themeColor: args.themeColor);
      },
    ),

    // Deep link : surpriseme://join/CODE ou https://.../join/CODE
    // Redirigé vers /  avec le code en query param → HomeScreen ouvre la sheet.
    GoRoute(
      path: '/join/:code',
      redirect: (context, state) {
        final code = state.pathParameters['code']!;
        return '/?joinCode=$code';
      },
    ),
  ],
);
