import '../entities/promo_material.dart';
import '../repositories/promo_repository.dart';

class GetPromoMaterialsUseCase {
  final PromoRepository _repository;

  GetPromoMaterialsUseCase(this._repository);

  Future<List<PromoMaterial>> call() {
    return _repository.getCCPromoMaterials();
  }
}
