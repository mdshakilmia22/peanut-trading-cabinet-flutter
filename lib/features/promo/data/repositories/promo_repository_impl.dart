import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/promo_material.dart';
import '../../domain/repositories/promo_repository.dart';
import '../datasources/promo_remote_datasource.dart';

class PromoRepositoryImpl implements PromoRepository {
  final PromoRemoteDataSource _remoteDataSource;

  PromoRepositoryImpl(this._remoteDataSource);

  @override
  Future<List<PromoMaterial>> getCCPromoMaterials() async {
    try {
      return await _remoteDataSource.fetchCCPromo();
    } on NetworkException catch (e) {
      throw NetworkFailure(e.message);
    } on ServerException catch (e) {
      throw ServerFailure(e.message, statusCode: e.statusCode);
    } catch (e) {
      throw ServerFailure('Failed to load promo materials: $e');
    }
  }
}
