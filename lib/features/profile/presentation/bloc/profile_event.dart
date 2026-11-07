import 'package:equatable/equatable.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object?> get props => [];
}

class FetchProfileEvent extends ProfileEvent {
  final String login;
  final String peanutToken;

  const FetchProfileEvent({
    required this.login,
    required this.peanutToken,
  });

  @override
  List<Object?> get props => [login, peanutToken];
}

class RefreshProfileEvent extends ProfileEvent {
  final String login;
  final String peanutToken;

  const RefreshProfileEvent({
    required this.login,
    required this.peanutToken,
  });

  @override
  List<Object?> get props => [login, peanutToken];
}
