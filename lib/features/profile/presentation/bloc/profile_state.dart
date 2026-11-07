import 'package:equatable/equatable.dart';
import '../../domain/entities/account_info.dart';

abstract class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object?> get props => [];
}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final AccountInfo accountInfo;

  const ProfileLoaded(this.accountInfo);

  @override
  List<Object?> get props => [accountInfo];
}

class ProfileError extends ProfileState {
  final String message;

  const ProfileError(this.message);

  @override
  List<Object?> get props => [message];
}
