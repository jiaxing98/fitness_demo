import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fitness_demo/domain/models/fitness_class.dart';
import 'package:fitness_demo/domain/repositories/fitness_class_repository.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';

part 'fitness_class_event.dart';
part 'fitness_class_state.dart';

class FitnessClassBloc extends Bloc<FitnessClassEvent, FitnessClassState> {
  final FitnessClassRepository _repository;

  FitnessClassBloc({required FitnessClassRepository repository})
      : _repository = repository,
        super(FitnessClassState.initial()) {
    on<FitnessClassFetch>(_fetchFitnessClass);
    on<FitnessClassFetchByPagination>(_fetchFitnessClassByPagination);
    on<FitnessClassFilterByClasses>(_filterFitnessClass);
    on<FitnessClassFilterByQuery>(_filterFitnessClassByQuery,
        transformer: _debounce(const Duration(milliseconds: 300)));
  }

  Future<void> _fetchFitnessClass(FitnessClassFetch event, Emitter<FitnessClassState> emit) async {
    emit(
      FitnessClassFetchLoading(
          currentPage: state.currentPage,
          fitnessClasses: state.fitnessClasses,
          filteredFitnessClasses: state.filteredFitnessClasses),
    );

    try {
      final result = await _repository.getAllFitnessClass();
      emit(
        FitnessClassFetchSuccess(
          currentPage: state.currentPage,
          fitnessClasses: result,
          filteredFitnessClasses: result,
        ),
      );
    } on Exception catch (ex) {
      emit(
        FitnessClassFetchFailure(
          exception: ex,
          currentPage: state.currentPage,
          fitnessClasses: state.fitnessClasses,
          filteredFitnessClasses: state.filteredFitnessClasses,
        ),
      );
    }
  }

  Future<void> _fetchFitnessClassByPagination(
      FitnessClassFetchByPagination event, Emitter<FitnessClassState> emit) async {
    final nextPage = state.currentPage + 1;

    try {
      final result = await _repository.getAllFitnessClass(page: nextPage);
      emit(
        FitnessClassFetchSuccess(
          currentPage: nextPage,
          fitnessClasses: result,
          filteredFitnessClasses: result,
        ),
      );
    } on Exception catch (ex) {
      emit(
        FitnessClassFetchFailure(
          exception: ex,
          currentPage: state.currentPage,
          fitnessClasses: state.fitnessClasses,
          filteredFitnessClasses: state.filteredFitnessClasses,
        ),
      );
    }
  }

  Future<void> _filterFitnessClass(
      FitnessClassFilterByClasses event, Emitter<FitnessClassState> emit) async {
    final a = state.fitnessClasses.where((e) => event.filters.contains(e.classType)).toList();
    print('a: $a');

    event.filters.isEmpty
        ? emit(
            FitnessClassFetchSuccess(
              currentPage: state.currentPage,
              fitnessClasses: state.fitnessClasses,
              filteredFitnessClasses: state.fitnessClasses,
            ),
          )
        : emit(
            FitnessClassFetchSuccess(
                currentPage: state.currentPage,
                fitnessClasses: state.fitnessClasses,
                filteredFitnessClasses: state.fitnessClasses
                    .where((e) => event.filters.contains(e.classType))
                    .toList()),
          );
  }

  Future<void> _filterFitnessClassByQuery(
      FitnessClassFilterByQuery event, Emitter<FitnessClassState> emit) async {
    final query = event.query.toLowerCase();

    if (query.isEmpty) {
      emit(
        FitnessClassFetchSuccess(
          currentPage: state.currentPage,
          fitnessClasses: state.fitnessClasses,
          filteredFitnessClasses: state.fitnessClasses,
        ),
      );
    }

    final filtered = state.filteredFitnessClasses
        .where((e) =>
            e.className.toLowerCase().contains(query) ||
            e.classType.toLowerCase().contains(query) ||
            e.complexity.toLowerCase().contains(query))
        .toList();

    emit(
      FitnessClassFetchSuccess(
        currentPage: state.currentPage,
        fitnessClasses: state.fitnessClasses,
        filteredFitnessClasses: filtered,
      ),
    );
  }

  EventTransformer<T> _debounce<T>(Duration duration) {
    return (events, mapper) =>
        events.debounceTime(duration).switchMap(mapper); // cancels previous if a new event comes
  }
}
