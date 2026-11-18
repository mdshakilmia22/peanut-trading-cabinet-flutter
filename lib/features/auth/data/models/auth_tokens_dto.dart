import '../../domain/entities/auth_tokens.dart';

class AuthTokensDto {
  final String peanutToken;
  final String partnerToken;
  final String login;

  const AuthTokensDto({
    required this.peanutToken,
    required this.partnerToken,
    required this.login,
  });

  factory AuthTokensDto.fromJson(Map<String, dynamic> json) {
    return AuthTokensDto(
      peanutToken: json['peanutToken'] as String? ?? '',
      partnerToken: json['partnerToken'] as String? ?? '',
      login: json['login'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'peanutToken': peanutToken,
      'partnerToken': partnerToken,
      'login': login,
    };
  }

  AuthTokens toEntity() {
    return AuthTokens(
      peanutToken: peanutToken,
      partnerToken: partnerToken,
      login: login,
    );
  }

  factory AuthTokensDto.fromEntity(AuthTokens entity) {
    return AuthTokensDto(
      peanutToken: entity.peanutToken,
      partnerToken: entity.partnerToken,
      login: entity.login,
    );
  }
}
