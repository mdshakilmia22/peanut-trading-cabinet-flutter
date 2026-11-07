import 'package:flutter_test/flutter_test.dart';
import 'package:interview_task/core/utils/soap_parser.dart';

void main() {
  group('SoapParser Tests', () {
    test('extractGetCCPromoResultJson should extract JSON and replace domain', () {
      const xmlInput = '''<s:Envelope xmlns:s="http://schemas.xmlsoap.org/soap/envelope/">
  <s:Body>
    <GetCCPromoResponse xmlns="http://tempuri.org/">
      <GetCCPromoResult>{"promo1": {"image": "https://forex-images.instaforex.com/test.png", "text": "Test Promo", "link": "https://example.com", "button_text": "Click", "button_color": "#FF0000", "euro_available": False}}</GetCCPromoResult>
    </GetCCPromoResponse>
  </s:Body>
</s:Envelope>''';

      final jsonResult = SoapParser.extractGetCCPromoResultJson(xmlInput);
      expect(jsonResult.contains('forex-images.ifxdb.com'), isTrue);
      expect(jsonResult.contains('forex-images.instaforex.com'), isFalse);
      expect(jsonResult.contains(': false'), isTrue);

      final items = SoapParser.parsePromoItems(jsonResult);
      expect(items.length, 1);
      expect(items.first['promo_key'], 'promo1');
      expect(items.first['image'], 'https://forex-images.ifxdb.com/test.png');
    });
  });
}
