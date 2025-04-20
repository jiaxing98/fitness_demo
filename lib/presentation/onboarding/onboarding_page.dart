import 'package:fitness_demo/core/service_locator.dart';
import 'package:fitness_demo/presentation/onboarding/blocs/onboarding_bloc.dart';
import 'package:fitness_demo/presentation/onboarding/widgets/login_form.dart';
import 'package:fitness_demo/presentation/onboarding/widgets/signup_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum Status { signup, login }

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  Status status = Status.login;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl.get<OnboardingBloc>()..add(OnboardingIsBiometricEnabled()),
      child: Scaffold(
        body: Container(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: switch (status) {
              Status.signup => SignUpForm(
                  onSwitchToLogin: () {
                    setState(() {
                      status = Status.login;
                    });
                  },
                ),
              Status.login => LoginForm(
                  onSwitchToSignUp: () {
                    setState(() {
                      status = Status.signup;
                    });
                  },
                ),
            },
          ),
        ),
      ),
    );
  }
}
