import 'package:cached_network_image/cached_network_image.dart';
import 'package:fitness_demo/core/service_locator.dart';
import 'package:fitness_demo/domain/models/fitness_class.dart';
import 'package:fitness_demo/presentation/fitness_class/blocs/instructor_bloc.dart';
import 'package:fitness_demo/presentation/fitness_class/widgets/instructor_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class InstructorPage extends StatelessWidget {
  final FitnessClass fitnessClass;

  const InstructorPage({
    super.key,
    required this.fitnessClass,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider<InstructorBloc>(
      create: (context) =>
          sl.get<InstructorBloc>()..add(InstructorFetchByClass(classId: fitnessClass.classId)),
      child: Scaffold(
        appBar: AppBar(
          title: Text(fitnessClass.className),
        ),
        body: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final width = constraints.maxWidth.floor();
              final height = (constraints.maxHeight / 4).floor();

              return Column(
                spacing: 16.0,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Hero(
                    tag: fitnessClass.classId,
                    child: CachedNetworkImage(
                      imageUrl: "https://picsum.photos/id/${fitnessClass.imageId}/$width/$height",
                      progressIndicatorBuilder: (context, url, downloadProgress) => Center(
                          child: CircularProgressIndicator(value: downloadProgress.progress)),
                      errorWidget: (context, url, error) => Icon(Icons.error_outline),
                    ),
                  ),
                  Expanded(
                    child: BlocBuilder<InstructorBloc, InstructorState>(
                      builder: (context, state) {
                        return SingleChildScrollView(
                          padding: EdgeInsets.all(16.0),
                          child: Column(
                            spacing: 16.0,
                            children: [
                              ...state.availableInstructor.map((e) => InstructorCard(info: e))
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
