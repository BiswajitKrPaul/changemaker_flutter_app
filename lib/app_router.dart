import 'package:auto_route/auto_route.dart';
import 'package:changemaker_flutter_app/app_router.gr.dart';
import 'package:changemaker_flutter_app/domain/firebase_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

@AutoRouterConfig(replaceInRouteName: 'Route')
class AppRouter extends RootStackRouter {
  AppRouter({required this.ref});

  final Ref ref;

  @override
  List<AutoRoute> get routes => [
    AutoRoute(page: LoginPageRoute.page, path: '/login'),
    AutoRoute(
      page: HomePageRoute.page,
      path: '/home',
      initial: true,
      children: [
        AutoRoute(page: DashboardViewRoute.page, path: 'dashboard'),
        AutoRoute(page: ProfileViewRoute.page, path: 'profile'),
      ],
    ),
    AutoRoute(page: RegisterPageRoute.page, path: '/register'),
    AutoRoute(page: OnboardingViewRoute.page, path: '/onboarding'),
    AutoRoute(page: LandingPageRoute.page, path: '/landing'),
  ];

  @override
  List<AutoRouteGuard> get guards => [
    AutoRouteGuard.simple(
      (resolver, router) {
        final currentUser = ref.read(firebaseAuthProvider).currentUser;
        if (currentUser != null ||
            resolver.routeName == LandingPageRoute.name ||
            resolver.routeName == LoginPageRoute.name ||
            resolver.routeName == RegisterPageRoute.name ||
            resolver.routeName == OnboardingViewRoute.name) {
          resolver.next();
        } else {
          resolver.redirectUntil(const LandingPageRoute());
        }
      },
    ),
  ];
}

final routeProvider = Provider<AppRouter>((ref) {
  return AppRouter(ref: ref);
});
