import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fitness_demo/core/exceptions/authentication_exception.dart';
import 'package:fitness_demo/core/helpers/biometric_authentication/biometric_authentication.dart';
import 'package:fitness_demo/domain/repositories/authentication_repository.dart';
import 'package:flutter/services.dart';
import 'package:meta/meta.dart';

part 'onboarding_event.dart';
part 'onboarding_state.dart';

class OnboardingBloc extends Bloc<OnboardingEvent, OnboardingState> {
  final BiometricAuthentication _bioAuth;
  final AuthenticationRepository _repository;

  OnboardingBloc({
    required BiometricAuthentication bioAuth,
    required AuthenticationRepository repository,
  })  : _bioAuth = bioAuth,
        _repository = repository,
        super(OnboardingInitial()) {
    on<OnboardingSignUpAccount>(_signUp);
    on<OnboardingLoginAccount>(_login);
    on<OnboardingIsBiometricEnabled>(_isBiometricEnabled);
    on<OnboardingSetupBiometricLogin>(_setupBiometricLogin);
    on<OnboardingAuthenticateWithBiometric>(_authenticateWithBiometric);
  }

  Future<void> _signUp(OnboardingSignUpAccount event, Emitter<OnboardingState> emit) async {
    try {
      emit(OnboardingLoading());
      await _repository.signup(event.username, event.password);
      emit(OnboardingSignUpSuccess());
    } on UserAlreadyExistException catch (ex, stacktrace) {
      log(ex.toString(), stackTrace: stacktrace);
      emit(OnboardingUserAlreadyExist());
    } catch (ex, stacktrace) {
      log(ex.toString(), stackTrace: stacktrace);
      emit(OnboardingUnknownFailure(message: ex.toString()));
    }
  }

  Future<void> _login(OnboardingLoginAccount event, Emitter<OnboardingState> emit) async {
    try {
      emit(OnboardingLoading());
      await _repository.login(event.username, event.password);
      _bioAuth.saveCaches(event.username);

      final canEnabled = await _bioAuth.canAuthenticateWithBiometrics;
      canEnabled
          ? emit(OnboardingAskIfEnableBiometricAuth())
          : emit(OnboardingLoginSuccess(username: event.username));
    } on AuthenticationFailedException catch (ex, stacktrace) {
      log(ex.toString(), stackTrace: stacktrace);
      emit(OnboardingLoginFailure());
    } catch (ex, stacktrace) {
      log(ex.toString(), stackTrace: stacktrace);
      emit(OnboardingUnknownFailure(message: ex.toString()));
    }
  }

  Future<void> _isBiometricEnabled(
      OnboardingIsBiometricEnabled event, Emitter<OnboardingState> emit) async {
    final enabled = await _bioAuth.isBiometricEnabled;
    emit(OnboardingInitial(isBiometricEnabled: enabled));
  }

  Future<void> _setupBiometricLogin(
      OnboardingSetupBiometricLogin event, Emitter<OnboardingState> emit) async {
    try {
      final authenticateSuccess = await _bioAuth.authenticateWithBiometric("Allow Biometric Login");
      if (authenticateSuccess) {
        await _bioAuth.enableBiometricLogin(event.password);
      }
      emit(OnboardingLoginSuccess(username: event.username));
    } on CredentialCorruptedException catch (ex, stacktrace) {
      log(ex.toString(), stackTrace: stacktrace);
      emit(OnboardingCredentialCorrupted());
    } catch (ex, stacktrace) {
      log(ex.toString(), stackTrace: stacktrace);
      emit(OnboardingUnknownFailure(message: ex.toString()));
    }
  }

  Future<void> _authenticateWithBiometric(
      OnboardingAuthenticateWithBiometric event, Emitter<OnboardingState> emit) async {
    try {
      final authenticateSuccess = await _bioAuth.authenticateWithBiometric("Allow Biometric Login");
      if (!authenticateSuccess) return;

      final credential = await _bioAuth.getCredential();
      await _repository.login(credential.username, credential.password);
      emit(OnboardingLoginSuccess(username: credential.username));
    } on PlatformException catch (ex, stacktrace) {
      /* Do Nothing */
      log(ex.toString(), stackTrace: stacktrace);
    } on CredentialCorruptedException catch (ex, stacktrace) {
      log(ex.toString(), stackTrace: stacktrace);
      await _bioAuth.removeAllCaches();
      emit(OnboardingCredentialCorrupted());
    } catch (ex, stacktrace) {
      log(ex.toString(), stackTrace: stacktrace);
      emit(OnboardingUnknownFailure(message: ex.toString()));
    }
  }
}
