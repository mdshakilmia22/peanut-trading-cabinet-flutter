import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/repositories/signals_repository.dart';
import 'signals_event.dart';
import 'signals_state.dart';

class SignalsBloc extends Bloc<SignalsEvent, SignalsState> {
  final SignalsRepository _signalsRepository;

  SignalsBloc({required this._signalsRepository})
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
    emit(
      SignalsLoading(
        selectedPairs: event.pairs,
        fromDate: event.fromDate,
        toDate: event.toDate,
      ),
    );

    try {
      final signals = await _signalsRepository.getAnalyticSignals(
        login: event.login,
        partnerToken: event.partnerToken,
        pairs: event.pairs,
        fromDate: event.fromDate,
        toDate: event.toDate,
      );

      emit(
        SignalsLoaded(
          signals: signals,
          selectedPairs: event.pairs,
          fromDate: event.fromDate,
          toDate: event.toDate,
        ),
      );
    } on Failure catch (failure) {
      emit(
        SignalsError(
          message: failure.message,
          selectedPairs: event.pairs,
          fromDate: event.fromDate,
          toDate: event.toDate,
        ),
      );
    } catch (e) {
      emit(
        SignalsError(
          message: 'Error fetching signals: $e',
          selectedPairs: event.pairs,
          fromDate: event.fromDate,
          toDate: event.toDate,
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
