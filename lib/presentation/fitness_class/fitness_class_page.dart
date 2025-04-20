import 'package:fitness_demo/core/service_locator.dart';
import 'package:fitness_demo/presentation/fitness_class/blocs/fitness_class_bloc.dart';
import 'package:fitness_demo/presentation/fitness_class/widgets/filter_group.dart';
import 'package:fitness_demo/presentation/fitness_class/widgets/fitness_class_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FitnessClassPage extends StatefulWidget {
  const FitnessClassPage({super.key});

  @override
  State<FitnessClassPage> createState() => _FitnessClassPageState();
}

class _FitnessClassPageState extends State<FitnessClassPage> {
  late final ScrollController _controller;

  @override
  void initState() {
    super.initState();
    _controller = ScrollController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _controller.addListener(() {
      _onScroll(context);
    });
  }

  @override
  void dispose() {
    _controller.removeListener(() {
      _onScroll(context);
    });
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<FitnessClassBloc>(
      create: (context) => sl.get<FitnessClassBloc>()..add(FitnessClassFetch()),
      child: BlocBuilder<FitnessClassBloc, FitnessClassState>(
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: Text("1 Fitness"),
            ),
            body: RefreshIndicator(
              onRefresh: () async => context.read<FitnessClassBloc>().add(FitnessClassFetch()),
              child: CustomScrollView(
                controller: _controller,
                slivers: [
                  SliverPersistentHeader(
                    pinned: true,
                    delegate: FilterGroup(
                      availableClasses: [...state.fitnessClasses.map((e) => e.classType).toSet()],
                      height: 150.0,
                      onTap: (filters) {
                        context
                            .read<FitnessClassBloc>()
                            .add(FitnessClassFilterByClasses(filters: filters));
                      },
                    ),
                  ),
                  SliverList(
                    delegate: SliverChildListDelegate(
                      [
                        ...state.filteredFitnessClasses.map(
                          (e) => FitnessClassCard(info: e),
                        ),
                        if (state is FitnessClassFetchLoading) CircularProgressIndicator()
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _onScroll(BuildContext context) {
    // if (_controller.position.pixels >= _controller.position.maxScrollExtent - 200) {
    //   context.read<FitnessClassBloc>().add(FitnessClassFetchByPagination());
    // }
  }
}
