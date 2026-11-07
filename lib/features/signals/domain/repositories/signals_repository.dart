import '../entities/analytic_signal.dart';

abstract class SignalsRepository {
  Future<List<AnalyticSignal>> getAnalyticSignals({
    required String login,
    required String partnerToken,
    required List<String> pairs,
    required DateTime fromDate,
    required DateTime toDate,
  });
}
