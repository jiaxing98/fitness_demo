import 'package:fitness_demo/core/database/database.dart';
import 'package:fitness_demo/core/helpers/biometric_authentication/biometric_authentication.dart';
import 'package:fitness_demo/core/helpers/biometric_authentication/biometric_authentication_impl.dart';
import 'package:fitness_demo/core/l10n/l10n.dart';
import 'package:fitness_demo/core/theme/theme.dart';
import 'package:fitness_demo/data/repositories/authentication_repository_impl.dart';
import 'package:fitness_demo/data/repositories/fitness_class_repository_impl.dart';
import 'package:fitness_demo/domain/repositories/authentication_repository.dart';
import 'package:fitness_demo/domain/repositories/fitness_class_repository.dart';
import 'package:fitness_demo/env.dart';
import 'package:fitness_demo/presentation/fitness_class/blocs/fitness_class_bloc.dart';
import 'package:fitness_demo/presentation/fitness_class/blocs/instructor_bloc.dart';
import 'package:fitness_demo/presentation/onboarding/blocs/onboarding_bloc.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

GetIt sl = GetIt.instance;

Future<void> initializedApp() async {
  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: HydratedStorageDirectory((await getTemporaryDirectory()).path),
  );

  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerSingleton<SharedPreferences>(sharedPreferences);

  final defaultTheme =
      appThemes[Env.defaultThemeData] ?? (light: RoseWoodX.light(), dark: RoseWoodX.dark());
  final theme = sl
      .registerSingleton<ThemeCubit>(ThemeCubit(sp: sharedPreferences, defaultTheme: defaultTheme));
  theme.loadTheme();

  sl.registerSingleton<L10nCubit>(
    L10nCubit(
      defaultLocale: Locale('en'),
      supportedLocales: [
        Locale('en'),
        Locale('zh'),
        Locale('ja'),
      ],
    ),
  );

  _injectHelpers();
  _injectRepositories();
  _injectBlocs();
}

void _injectHelpers() {
  sl.registerSingleton<AppDatabase>(AppDatabase());

  sl.registerSingleton<BiometricAuthentication>(
    BiometricAuthenticationImpl(
      sp: sl.get<SharedPreferences>(),
      key: Env.aesKey,
      encodedIV: Env.encodedIV,
    ),
  );
}

void _injectRepositories() {
  sl.registerSingleton<AuthenticationRepository>(
    AuthenticationRepositoryImpl(db: sl.get<AppDatabase>()),
  );
  sl.registerSingleton<FitnessClassRepository>(
    FitnessClassRepositoryImpl(),
  );
}

void _injectBlocs() {
  // ! singleton - use BlocProvider.value to not close the stream

  // ! factory - use BlocProvider to create new instance
  sl.registerFactory<OnboardingBloc>(
    () => OnboardingBloc(
      bioAuth: sl.get<BiometricAuthentication>(),
      repository: sl.get<AuthenticationRepository>(),
    ),
  );

  sl.registerFactory<FitnessClassBloc>(
    () => FitnessClassBloc(
      repository: sl.get<FitnessClassRepository>(),
    ),
  );

  sl.registerFactory<InstructorBloc>(
    () => InstructorBloc(
      repository: sl.get<FitnessClassRepository>(),
    ),
  );
}
