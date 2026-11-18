import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/usecases/get_signals_usecase.dart';
import 'signals_event.dart';
import 'signals_state.dart';

class SignalsBloc extends Bloc<SignalsEvent, SignalsState> {
  final GetSignalsUseCase _getSignalsUseCase;

  SignalsBloc(this._getSignalsUseCase)
    : super(
        SignalsInitial(
          selectedPairs: const ['EURUSD', 'GBPUSD', 'USDJPY'],
          fromDate: DateTime.now().subtract(const Duration(days: 30)),
          toDate: DateTime.now(),
        ),
      ) {
    on<FetchSignalsEvent>(_onFetchSignals);
    on<TogglePairFilterEvent>(_onTogglePairFilter);
    on<SelectDateRangeEvent>(_onSelectDateRange);
  }

  Future<void> _onFetchSignals(
    FetchSignalsEvent event,
    Emitter<SignalsState> emit,
  ) async {
    final pairs = event.pairs ?? state.selectedPairs;
    final fromDate = event.fromDate ?? state.fromDate;
    final toDate = event.toDate ?? state.toDate;

    emit(
      SignalsLoading(selectedPairs: pairs, fromDate: fromDate, toDate: toDate),
    );

    try {
      final signals = await _getSignalsUseCase(
        pairs: pairs,
        fromDate: fromDate,
        toDate: toDate,
      );

      emit(
        SignalsLoaded(
          signals: signals,
          selectedPairs: pairs,
          fromDate: fromDate,
          toDate: toDate,
        ),
      );
    } on Failure catch (failure) {
      emit(
        SignalsError(
          message: failure.message,
          selectedPairs: pairs,
          fromDate: fromDate,
          toDate: toDate,
        ),
      );
    } catch (e) {
      emit(
        SignalsError(
          message: 'Error fetching signals: $e',
          selectedPairs: pairs,
          fromDate: fromDate,
          toDate: toDate,
        ),
      );
    }
  }

  void _onTogglePairFilter(
    TogglePairFilterEvent event,
    Emitter<SignalsState> emit,
  ) {
    final currentPairs = List<String>.from(state.selectedPairs);
    if (currentPairs.contains(event.pair)) {
      if (currentPairs.length > 1) {
        currentPairs.remove(event.pair);
      }
    } else {
      currentPairs.add(event.pair);
    }

    emit(
      SignalsInitial(
        selectedPairs: currentPairs,
        fromDate: state.fromDate,
        toDate: state.toDate,
      ),
    );
  }

  void _onSelectDateRange(
    SelectDateRangeEvent event,
    Emitter<SignalsState> emit,
  ) {
    emit(
      SignalsInitial(
        selectedPairs: state.selectedPairs,
        fromDate: event.fromDate,
        toDate: event.toDate,
      ),
    );
  }
}
