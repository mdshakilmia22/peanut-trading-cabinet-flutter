import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/analytic_signal.dart';
import '../../domain/repositories/signals_repository.dart';
import '../datasources/signals_remote_datasource.dart';

class SignalsRepositoryImpl implements SignalsRepository {
  final SignalsRemoteDataSource _remoteDataSource;

  SignalsRepositoryImpl(this._remoteDataSource);

  @override
  Future<List<AnalyticSignal>> getAnalyticSignals({
    required String login,
    required String partnerToken,
    required List<String> pairs,
    required DateTime fromDate,
    required DateTime toDate,
  }) async {
    try {
      return await _remoteDataSource.fetchAnalyticSignals(
        login: login,
        partnerToken: partnerToken,
        pairs: pairs,
        fromDate: fromDate,
        toDate: toDate,
      );
    } on NetworkException catch (e) {
      throw NetworkFailure(e.message);
    } on ServerException catch (e) {
      throw ServerFailure(e.message, statusCode: e.statusCode);
    } catch (e) {
      throw ServerFailure('Failed to fetch trading signals: $e');
    }
  }
}
