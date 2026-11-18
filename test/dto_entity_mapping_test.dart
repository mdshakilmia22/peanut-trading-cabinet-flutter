import 'package:flutter_test/flutter_test.dart';
import 'package:interview_task/features/auth/data/models/auth_tokens_dto.dart';
import 'package:interview_task/features/profile/data/models/account_info_dto.dart';
import 'package:interview_task/features/signals/data/models/analytic_signal_dto.dart';
import 'package:interview_task/features/promo/data/models/promo_material_dto.dart';

void main() {
  group('DTO to Entity Mapping Tests', () {
    test('AuthTokensDto should map properly to AuthTokens entity', () {
      final json = {
        'peanutToken': 'peanut_token_123',
        'partnerToken': 'partner_token_456',
        'login': '20234561',
      };

      final dto = AuthTokensDto.fromJson(json);
      final entity = dto.toEntity();

      expect(entity.peanutToken, 'peanut_token_123');
      expect(entity.partnerToken, 'partner_token_456');
      expect(entity.login, '20234561');
    });

    test('AccountInfoDto should map properly to AccountInfo entity', () {
      final json = {
        'name': 'John Doe',
        'balance': 1500.50,
        'equity': 1480.20,
        'freeMargin': 1400.00,
        'leverage': 200,
        'country': 'UK',
        'city': 'London',
        'address': 'Baker Street',
        'verificationLevel': 2,
        'type': 1,
      };

      final dto = AccountInfoDto.fromJson(
        json,
        phoneMask: '********1234',
        login: 99999,
      );
      final entity = dto.toEntity();

      expect(entity.login, 99999);
      expect(entity.name, 'John Doe');
      expect(entity.phoneMask, '********1234');
      expect(entity.balance, 1500.50);
      expect(entity.equity, 1480.20);
      expect(entity.leverage, 200);
      expect(entity.city, 'London');
    });

    test('AnalyticSignalDto should map properly to AnalyticSignal entity', () {
      final json = {
        'id': 101,
        'pair': 'EURUSD',
        'cmd': 'BUY',
        'price': 1.0850,
        'comment': 'Bullish trend',
        'tp': 1.0950,
        'sl': 1.0750,
        'date': 1700000000,
      };

      final dto = AnalyticSignalDto.fromJson(json);
      final entity = dto.toEntity();

      expect(entity.id, 101);
      expect(entity.pair, 'EURUSD');
      expect(entity.action, 'BUY');
      expect(entity.price, 1.0850);
      expect(entity.takeProfit, 1.0950);
      expect(entity.stopLoss, 1.0750);
    });

    test('PromoMaterialDto should map properly to PromoMaterial entity', () {
      final json = {
        'promo_key': 'test_promo',
        'image': 'https://forex-images.ifxdb.com/test.png',
        'text': 'Test Campaign',
        'link': 'https://example.com',
        'button_text': 'Learn More',
        'button_color': '#1E3A8A',
      };

      final dto = PromoMaterialDto.fromJson(json);
      final entity = dto.toEntity();

      expect(entity.key, 'test_promo');
      expect(entity.imageUrl, 'https://forex-images.ifxdb.com/test.png');
      expect(entity.text, 'Test Campaign');
      expect(entity.buttonColor, '#1E3A8A');
    });
  });
}
