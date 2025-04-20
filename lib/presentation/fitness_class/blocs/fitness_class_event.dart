part of 'fitness_class_bloc.dart';

@immutable
sealed class FitnessClassEvent {}

final class FitnessClassFetch extends FitnessClassEvent {
  FitnessClassFetch();
}

final class FitnessClassFetchByPagination extends FitnessClassEvent {
  FitnessClassFetchByPagination();
}

final class FitnessClassFilterByClasses extends FitnessClassEvent {
  final List<String> filters;

  FitnessClassFilterByClasses({required this.filters});
}

final class FitnessClassFilterByQuery extends FitnessClassEvent {
  final String query;

  FitnessClassFilterByQuery({required this.query});
}
