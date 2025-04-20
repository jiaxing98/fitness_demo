import 'package:fitness_demo/core/extensions/build_context.dart';
import 'package:fitness_demo/core/l10n/l10n.dart';
import 'package:fitness_demo/core/theme/theme.dart';
import 'package:fitness_demo/presentation/home/widgets/action_button.dart';
import 'package:fitness_demo/presentation/home/widgets/expandable_fab.dart';
import 'package:fitness_demo/router/router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => context.read<ThemeCubit>().changeTheme(),
          icon: Icon(Icons.brush),
        ),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(context.l10n.appBarTitle),
        actions: [
          BlocBuilder<ThemeCubit, ThemeState>(
            builder: (context, state) {
              return IconButton(
                onPressed: () => context.read<ThemeCubit>().changeMode(
                      switch (state.mode) {
                        ThemeMode.light => ThemeMode.dark,
                        ThemeMode.dark => ThemeMode.light,
                        ThemeMode.system =>
                          context.brightness == Brightness.light ? ThemeMode.dark : ThemeMode.light,
                      },
                    ),
                icon: Icon(state.mode == ThemeMode.light ? Icons.light_mode : Icons.dark_mode),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16.0),
          child: Column(
            spacing: 16.0,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              OutlinedButton(
                onPressed: () {},
                child: Text("Memberships"),
              ),
              OutlinedButton(
                onPressed: () {},
                child: Text("Preferences"),
              ),
              OutlinedButton(
                onPressed: () {},
                child: Text("Find Friends"),
              ),
              OutlinedButton(
                onPressed: () {},
                child: Text("Support and FAQs"),
              ),
              OutlinedButton(
                onPressed: () {
                  context.goNamed(Routes.onboarding);
                },
                child: Text("Logout"),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: BlocBuilder<L10nCubit, L10nState>(
        builder: (context, state) {
          return ExpandableFab(
            distance: 110,
            children: state.supportedLocales
                .map(
                  (e) => ActionButton(
                    locale: e,
                    onPressed: context.read<L10nCubit>().changeLocale,
                  ),
                )
                .toList(),
          );
        },
      ),
    );
  }
}
