import 'package:fitness_demo/presentation/onboarding/blocs/onboarding_bloc.dart';
import 'package:fitness_demo/presentation/onboarding/formz/inputs/password_input.dart';
import 'package:fitness_demo/presentation/onboarding/formz/inputs/username_input.dart';
import 'package:fitness_demo/presentation/onboarding/formz/states/onboarding_formz_state.dart';
import 'package:fitness_demo/presentation/onboarding/widgets/onboarding_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:loader_overlay/loader_overlay.dart';

class SignUpForm extends StatefulWidget {
  final void Function() onSwitchToLogin;

  const SignUpForm({super.key, required this.onSwitchToLogin});

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  late OnboardingFormzState _formzState;
  late final TextEditingController _usernameCtrl;
  late final TextEditingController _passwordCtrl;

  bool hidePassword = true;

  @override
  void initState() {
    super.initState();

    _formzState = OnboardingFormzState();
    _usernameCtrl = TextEditingController();
    _passwordCtrl = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<OnboardingBloc, OnboardingState>(
      listener: _handleListener,
      child: Form(
        key: _formKey,
        child: Column(
          spacing: 16.0,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(
              "Sign Up",
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.italic,
              ),
            ),
            TextFormField(
              controller: _usernameCtrl,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                icon: Icon(Icons.person),
                labelText: 'Username',
              ),
              onChanged: (text) =>
                  _formzState = _formzState.copyWith(username: UsernameInput.dirty(text)),
              validator: (value) => _formzState.username.validator(value ?? '')?.text(),
            ),
            TextFormField(
              controller: _passwordCtrl,
              obscureText: hidePassword,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                icon: Icon(Icons.lock),
                labelText: 'Password',
                errorMaxLines: 2,
                suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      hidePassword = !hidePassword;
                    });
                  },
                  icon: hidePassword
                      ? Icon(Icons.visibility_off_outlined)
                      : Icon(Icons.visibility_outlined),
                ),
              ),
              onChanged: (text) =>
                  _formzState = _formzState.copyWith(password: PasswordInput.dirty(text)),
              validator: (value) => _formzState.password.validator(value ?? '')?.text(),
            ),
            OutlinedButton(
              onPressed: () async {
                if (!_formKey.currentState!.validate()) return;

                context.read<OnboardingBloc>().add(
                      OnboardingSignUpAccount(
                        username: _formzState.username.value,
                        password: _formzState.password.value,
                      ),
                    );
              },
              child: Text("Sign Up"),
            ),
            OnboardingText(
              description: 'Already have an account?',
              label: 'Login Here',
              onTap: () {
                widget.onSwitchToLogin();
              },
            )
          ],
        ),
      ),
    );
  }

  void _handleListener(BuildContext context, OnboardingState state) async {
    switch (state) {
      case OnboardingLoading():
        context.loaderOverlay.show();
      case OnboardingSignUpSuccess():
        context.loaderOverlay.hide();
        await showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text("Sign Up Successfully!"),
            content: Text("Your Account has been created successfully, please proceed to login."),
            actions: [
              FilledButton(
                onPressed: () {
                  context.pop();
                },
                child: Text("OKAY"),
              )
            ],
          ),
        );
        widget.onSwitchToLogin();
      case OnboardingUserAlreadyExist():
        context.loaderOverlay.hide();
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text("User Already Existed!"),
            content: Text("Username has been taken, please use another username."),
            actions: [
              OutlinedButton(
                onPressed: () {
                  context.pop();
                },
                child: Text("OKAY"),
              )
            ],
          ),
        );
      case OnboardingUnknownFailure():
        context.loaderOverlay.hide();
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text("Oops, Something Went Wrong!"),
            content: Text(state.message),
            actions: [
              OutlinedButton(
                onPressed: () {
                  context.pop();
                },
                child: Text("OKAY"),
              )
            ],
          ),
        );
      default:
        context.loaderOverlay.hide();
        break;
    }
  }
}
