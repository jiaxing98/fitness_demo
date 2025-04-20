part of 'fitness_class_bloc.dart';

@immutable
final class FitnessClassState extends Equatable {
  final int currentPage;
  final List<FitnessClass> fitnessClasses;
  final List<FitnessClass> filteredFitnessClasses;

  const FitnessClassState({
    required this.currentPage,
    required this.fitnessClasses,
    required this.filteredFitnessClasses,
  });

  factory FitnessClassState.initial() {
    return FitnessClassState(
      currentPage: 1,
      fitnessClasses: [],
      filteredFitnessClasses: [],
    );
  }

  FitnessClassState copyWith({
    int? currentPage,
    List<FitnessClass>? fitnessClasses,
    List<FitnessClass>? filteredFitnessClasses,
  }) {
    return FitnessClassState(
      currentPage: currentPage ?? this.currentPage,
      fitnessClasses: fitnessClasses ?? this.fitnessClasses,
      filteredFitnessClasses: filteredFitnessClasses ?? this.filteredFitnessClasses,
    );
  }

  @override
  List<Object> get props => [currentPage, fitnessClasses, filteredFitnessClasses];
}

final class FitnessClassFetchLoading extends FitnessClassState {
  const FitnessClassFetchLoading({
    required super.currentPage,
    required super.fitnessClasses,
    required super.filteredFitnessClasses,
  });
}

final class FitnessClassFetchSuccess extends FitnessClassState {
  const FitnessClassFetchSuccess({
    required super.currentPage,
    required super.fitnessClasses,
    required super.filteredFitnessClasses,
  });
}

final class FitnessClassFetchFailure extends FitnessClassState {
  final Exception exception;

  const FitnessClassFetchFailure({
    required this.exception,
    required super.currentPage,
    required super.fitnessClasses,
    required super.filteredFitnessClasses,
  });
}
