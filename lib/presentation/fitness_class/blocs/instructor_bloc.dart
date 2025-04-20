import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fitness_demo/domain/models/instructor_with_class.dart';
import 'package:fitness_demo/domain/repositories/fitness_class_repository.dart';
import 'package:meta/meta.dart';

part 'instructor_event.dart';
part 'instructor_state.dart';

class InstructorBloc extends Bloc<InstructorEvent, InstructorState> {
  final FitnessClassRepository _repository;

  InstructorBloc({required FitnessClassRepository repository})
      : _repository = repository,
        super(InstructorState(availableInstructor: [])) {
    on<InstructorFetchByClass>(_instructorFetchByClass);
  }

  Future<void> _instructorFetchByClass(
      InstructorFetchByClass event, Emitter<InstructorState> emit) async {
    emit(InstructorFetchLoading(availableInstructor: state.availableInstructor));
    try {
      final result = await _repository.getAvailableInstructors(event.classId);
      emit(InstructorFetchSuccess(availableInstructor: result));
    } on Exception catch (ex) {
      emit(InstructorFetchFailure(exception: ex, availableInstructor: state.availableInstructor));
    }
  }
}
