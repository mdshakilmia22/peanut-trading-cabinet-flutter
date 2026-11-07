import 'package:equatable/equatable.dart';

class AuthTokens extends Equatable {
  final String peanutToken;
  final String partnerToken;
  final String login;

  const AuthTokens({
    required this.peanutToken,
    required this.partnerToken,
    required this.login,
  });

  @override
  List<Object?> get props => [peanutToken, partnerToken, login];
}
