part of 'instructor_bloc.dart';

@immutable
sealed class InstructorEvent {}

final class InstructorFetchByClass extends InstructorEvent {
  final String classId;

  InstructorFetchByClass({required this.classId});
}
