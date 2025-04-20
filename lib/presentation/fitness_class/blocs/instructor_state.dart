part of 'instructor_bloc.dart';

@immutable
final class InstructorState extends Equatable {
  final List<InstructorWithClass> availableInstructor;

  const InstructorState({required this.availableInstructor});

  InstructorState copyWith({
    List<InstructorWithClass>? availableInstructor,
  }) {
    return InstructorState(
      availableInstructor: availableInstructor ?? this.availableInstructor,
    );
  }

  @override
  List<Object> get props => [availableInstructor];
}

final class InstructorFetchLoading extends InstructorState {
  const InstructorFetchLoading({required super.availableInstructor});
}

final class InstructorFetchSuccess extends InstructorState {
  const InstructorFetchSuccess({required super.availableInstructor});
}

final class InstructorFetchFailure extends InstructorState {
  final Exception exception;

  const InstructorFetchFailure({
    required this.exception,
    required super.availableInstructor,
  });
}
