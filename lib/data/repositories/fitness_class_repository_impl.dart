import 'package:collection/collection.dart';
import 'package:fitness_demo/domain/models/fitness_class.dart';
import 'package:fitness_demo/domain/models/instructor_with_class.dart';
import 'package:fitness_demo/domain/repositories/fitness_class_repository.dart';
import 'package:uuid/uuid.dart';

class FitnessClassRepositoryImpl extends FitnessClassRepository {
  @override
  Future<List<FitnessClass>> getAllFitnessClass({int page = 1}) async {
    final availableClassType = [
      'Cardio',
      'Cycling',
      'Dance',
      'Feature Class',
      'HIIT',
      'Mind and Body',
      'Strength and Conditioning'
    ];
    final availableComplexity = ['beginner', 'moderate', 'advanced'];

    final classes = [
      ...availableClassType.expandIndexed(
        (i, e) => [
          ...availableComplexity.mapIndexed(
            (j, x) => FitnessClass(
              classId: Uuid().v4(),
              className: 'Class$i$j',
              classType: e,
              complexity: x,
              imageId: (i * 10 + j).toString(),
            ),
          )
        ],
      )
    ];

    // todo: pagination
    // return classes.take(page * 15).toList();
    return classes;
  }

  @override
  Future<List<FitnessClass>> searchFitnessClass(String className) async {
    final classes = await getAllFitnessClass();
    return classes.where((e) => e.className.contains(className)).toList();
  }

  @override
  Future<List<InstructorWithClass>> getAvailableInstructors(String classId) async {
    return List.generate(
      5,
      (index) => InstructorWithClass(
          instructorId: Uuid().v4(),
          name: 'Instructor$index',
          availableDateTime: DateTime.now().add(Duration(days: 1 + index)),
          imageId: (90 + index).toString()),
    );
  }
}
