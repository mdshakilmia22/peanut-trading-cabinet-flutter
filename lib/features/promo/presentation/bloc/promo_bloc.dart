import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/repositories/promo_repository.dart';
import 'promo_event.dart';
import 'promo_state.dart';

class PromoBloc extends Bloc<PromoEvent, PromoState> {
  final PromoRepository _promoRepository;

  PromoBloc({required PromoRepository promoRepository})
      : _promoRepository = promoRepository,
        super(PromoInitial()) {
    on<FetchPromoEvent>(_onFetchPromo);
    on<RefreshPromoEvent>(_onRefreshPromo);
  }

  Future<void> _onFetchPromo(
    FetchPromoEvent event,
    Emitter<PromoState> emit,
  ) async {
    emit(PromoLoading());
    try {
      final promos = await _promoRepository.getCCPromoMaterials();
      emit(PromoLoaded(promos));
    } on Failure catch (failure) {
      emit(PromoError(failure.message));
    } catch (e) {
      emit(PromoError('Error loading promo materials: $e'));
    }
  }

  Future<void> _onRefreshPromo(
    RefreshPromoEvent event,
    Emitter<PromoState> emit,
  ) async {
    try {
      final promos = await _promoRepository.getCCPromoMaterials();
      emit(PromoLoaded(promos));
    } on Failure catch (failure) {
      emit(PromoError(failure.message));
    } catch (e) {
      emit(PromoError('Error refreshing promo materials: $e'));
    }
  }
}
