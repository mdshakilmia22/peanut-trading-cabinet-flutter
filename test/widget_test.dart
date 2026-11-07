import 'package:flutter_test/flutter_test.dart';
import 'package:interview_task/features/auth/domain/entities/auth_tokens.dart';

void main() {
  test('AuthTokens entity equality test', () {
    const tokens1 = AuthTokens(
      peanutToken: 'token123',
      partnerToken: 'ptoken456',
      login: '20234561',
    );

    const tokens2 = AuthTokens(
      peanutToken: 'token123',
      partnerToken: 'ptoken456',
      login: '20234561',
    );

    expect(tokens1, equals(tokens2));
  });
}
