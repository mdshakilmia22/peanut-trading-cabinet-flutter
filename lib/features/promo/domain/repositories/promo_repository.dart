import '../entities/promo_material.dart';

abstract class PromoRepository {
  Future<List<PromoMaterial>> getCCPromoMaterials();
}
