import '../../../../core/errors/failures.dart';
import '../../../auth/domain/repositories/auth_repository.dart';
import '../entities/analytic_signal.dart';
import '../repositories/signals_repository.dart';

class GetSignalsUseCase {
  final SignalsRepository _signalsRepository;
  final AuthRepository _authRepository;

  GetSignalsUseCase(this._signalsRepository, this._authRepository);

  Future<List<AnalyticSignal>> call({
    required List<String> pairs,
    required DateTime fromDate,
    required DateTime toDate,
  }) async {
    final tokens = _authRepository.getCachedTokens();
    if (tokens == null) {
      throw const AuthFailure('No active session found. Please log in.');
    }

    return _signalsRepository.getAnalyticSignals(
      login: tokens.login,
      partnerToken: tokens.partnerToken,
      pairs: pairs,
      fromDate: fromDate,
      toDate: toDate,
    );
  }
}
