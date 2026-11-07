import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class CheckAuthStatusEvent extends AuthEvent {}

class LoginSubmittedEvent extends AuthEvent {
  final String login;
  final String password;

  const LoginSubmittedEvent({
    required this.login,
    required this.password,
  });

  @override
  List<Object?> get props => [login, password];
}

class LogoutSubmittedEvent extends AuthEvent {}
