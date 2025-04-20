import 'package:fitness_demo/domain/models/fitness_class.dart';
import 'package:fitness_demo/domain/models/instructor_with_class.dart';

abstract class FitnessClassRepository {
  Future<List<FitnessClass>> getAllFitnessClass({int page = 1});
  Future<List<FitnessClass>> searchFitnessClass(String className);
  Future<List<InstructorWithClass>> getAvailableInstructors(String classId);
}
