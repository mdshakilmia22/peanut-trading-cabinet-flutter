import 'package:equatable/equatable.dart';

abstract class PromoEvent extends Equatable {
  const PromoEvent();

  @override
  List<Object?> get props => [];
}

class FetchPromoEvent extends PromoEvent {}

class RefreshPromoEvent extends PromoEvent {}
