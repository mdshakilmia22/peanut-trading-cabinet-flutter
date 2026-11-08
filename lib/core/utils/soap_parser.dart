import 'dart:convert';
import '../constants/api_constants.dart';

class SoapParser {
  static String extractGetCCPromoResultJson(String xmlResponseBody) {
    final match = RegExp(
      r'<GetCCPromoResult[^>]*>(.*?)</GetCCPromoResult>',
      dotAll: true,
      caseSensitive: false,
    ).firstMatch(xmlResponseBody);

    if (match != null && match.groupCount >= 1) {
      String jsonText = match.group(1)!;

      jsonText = jsonText
          .replaceAll('&lt;', '<')
          .replaceAll('&gt;', '>')
          .replaceAll('&quot;', '"')
          .replaceAll('&apos;', "'")
          .replaceAll('&amp;', '&');

      jsonText = jsonText
          .replaceAll(': False', ': false')
          .replaceAll(': True', ': true');

      // Replace image domain
      jsonText = jsonText.replaceAll(
        ApiConstants.originalPromoImageDomain,
        ApiConstants.replacePromoImageDomain,
      );

      return jsonText;
    }

    throw FormatException(
      'Could not locate <GetCCPromoResult> in SOAP response',
    );
  }

  /// Converts promo JSON string into List of promo item maps
  static List<Map<String, dynamic>> parsePromoItems(String jsonText) {
    final decoded = json.decode(jsonText);
    final List<Map<String, dynamic>> items = [];

    if (decoded is Map<String, dynamic>) {
      decoded.forEach((key, value) {
        if (value is Map<String, dynamic>) {
          final item = Map<String, dynamic>.from(value);
          item['promo_key'] = key;

          if (item['image'] != null && item['image'] is String) {
            item['image'] = (item['image'] as String).replaceAll(
              ApiConstants.originalPromoImageDomain,
              ApiConstants.replacePromoImageDomain,
            );
          }
          items.add(item);
        }
      });
    } else if (decoded is List) {
      for (var element in decoded) {
        if (element is Map<String, dynamic>) {
          final item = Map<String, dynamic>.from(element);
          if (item['image'] != null && item['image'] is String) {
            item['image'] = (item['image'] as String).replaceAll(
              ApiConstants.originalPromoImageDomain,
              ApiConstants.replacePromoImageDomain,
            );
          }
          items.add(item);
        }
      }
    }

    return items;
  }
}
