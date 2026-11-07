import 'package:equatable/equatable.dart';
import '../../domain/entities/promo_material.dart';

abstract class PromoState extends Equatable {
  const PromoState();

  @override
  List<Object?> get props => [];
}

class PromoInitial extends PromoState {}

class PromoLoading extends PromoState {}

class PromoLoaded extends PromoState {
  final List<PromoMaterial> promos;

  const PromoLoaded(this.promos);

  @override
  List<Object?> get props => [promos];
}

class PromoError extends PromoState {
  final String message;

  const PromoError(this.message);

  @override
  List<Object?> get props => [message];
}
