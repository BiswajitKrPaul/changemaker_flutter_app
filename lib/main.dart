import 'package:changemaker_flutter_app/app_router.dart';
import 'package:changemaker_flutter_app/app_router.gr.dart';
import 'package:changemaker_flutter_app/domain/firebase_providers.dart';
import 'package:changemaker_flutter_app/features/auth/providers/auth_provider.dart';
import 'package:changemaker_flutter_app/firebase_options.dart';
import 'package:changemaker_flutter_app/i18n/strings.g.dart';
import 'package:changemaker_flutter_app/injection.dart';
import 'package:changemaker_flutter_app/utils/color_utils.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LocaleSettings.useDeviceLocale();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  configureDependencies();
  final container = ProviderContainer();
  final fAuth = container.read(firebaseAuthProvider);
  final currentUser = fAuth.currentUser;
  container.dispose();
  runApp(
    TranslationProvider(
      child: ProviderScope(
        overrides: [
          authStateNotifierProvider.overrideWithBuild(
            (ref, notifier) {
              return notifier.build().copyWith(
                user: currentUser,
                isLoggedIn: currentUser != null,
              );
            },
          ),
        ],
        child: const MainApp(),
      ),
    ),
  );
}

class MainApp extends ConsumerWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(
      authStateNotifierProvider,
      (previous, next) {
        if (next.user == null) {
          ref.read(routeProvider).replaceAll([const LandingPageRoute()]);
        }
      },
    );
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      scaffoldMessengerKey: scaffoldMessengerKey,
      routerConfig: ref.read(routeProvider).config(),
      locale: TranslationProvider.of(context).flutterLocale,
      supportedLocales: AppLocaleUtils.supportedLocales,
      localizationsDelegates: GlobalMaterialLocalizations.delegates,
      theme: ThemeData.from(
        colorScheme:
            ColorScheme.fromSeed(
              seedColor: ref.read(colorProvider).gradientMiddleColor,
            ).copyWith(
              surface: Colors.white,
              error: ref.read(colorProvider).gradientStartColor,
            ),
        useMaterial3: true,
        textTheme: GoogleFonts.dmSansTextTheme(),
      ),
    );
  }
}
