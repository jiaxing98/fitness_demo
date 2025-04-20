import 'package:fitness_demo/domain/models/fitness_class.dart';
import 'package:fitness_demo/presentation/dashboard/dashboard_page.dart';
import 'package:fitness_demo/presentation/fitness_class/fitness_class_page.dart';
import 'package:fitness_demo/presentation/fitness_class/instructor_page.dart';
import 'package:fitness_demo/presentation/onboarding/onboarding_page.dart';
import 'package:fitness_demo/presentation/presentation.dart';
import 'package:fitness_demo/presentation/profile/profile_page.dart';
import 'package:fitness_demo/presentation/schedule/schedule_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

final RouteObserver<PageRoute> shellRouteObserver = RouteObserver<PageRoute>();

final GoRouter router = GoRouter(
  debugLogDiagnostics: true,
  navigatorKey: _rootNavigatorKey,
  initialLocation: Routes.onboarding,
  routes: <RouteBase>[
    GoRoute(
      path: Routes.onboarding,
      name: Routes.onboarding,
      builder: (context, state) {
        return const OnboardingPage();
      },
    ),
    ShellRoute(
      navigatorKey: _shellNavigatorKey,
      observers: [shellRouteObserver],
      builder: (context, state, child) {
        return DashboardPage(
          shellContext: context,
          child: child,
        );
      },
      routes: [
        GoRoute(
          path: Routes.home,
          name: Routes.home,
          builder: (context, state) {
            return const HomePage();
          },
        ),
        GoRoute(
          path: Routes.classes,
          name: Routes.classes,
          builder: (context, state) {
            return const FitnessClassPage();
          },
          routes: [
            GoRoute(
              path: Routes.instructor,
              name: Routes.instructor,
              parentNavigatorKey: _rootNavigatorKey,
              builder: (context, state) {
                final fitnessClass = state.extra as FitnessClass;
                return InstructorPage(fitnessClass: fitnessClass);
              },
            ),
          ],
        ),
        GoRoute(
          path: Routes.schedule,
          name: Routes.schedule,
          builder: (context, state) {
            return const SchedulePage();
          },
        ),
        GoRoute(
          path: Routes.profile,
          name: Routes.profile,
          builder: (context, state) {
            return const ProfilePage();
          },
        ),
      ],
    ),
  ],
);

abstract final class Routes {
  static const String home = "/";
  static const String onboarding = "/onboarding";
  static const String classes = "/classes";
  static const String instructor = "instructor";
  static const String schedule = "/schedule";
  static const String profile = "/profile";
}
