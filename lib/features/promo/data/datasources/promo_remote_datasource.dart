import '../../../../core/constants/api_constants.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/utils/soap_parser.dart';
import '../../domain/entities/promo_material.dart';

abstract class PromoRemoteDataSource {
  Future<List<PromoMaterial>> fetchCCPromo();
}

class PromoRemoteDataSourceImpl implements PromoRemoteDataSource {
  final ApiClient _apiClient;

  PromoRemoteDataSourceImpl(this._apiClient);

  @override
  Future<List<PromoMaterial>> fetchCCPromo() async {
    const soapEnvelope = '''<?xml version="1.0" encoding="utf-8"?>
<soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
  <soap:Body>
    <GetCCPromo xmlns="http://tempuri.org/">
      <lang>en</lang>
    </GetCCPromo>
  </soap:Body>
</soap:Envelope>''';

    const soapAction = 'http://tempuri.org/CabinetMicroService/GetCCPromo';

    try {
      final xmlResponse = await _apiClient.postSoap(
        ApiConstants.promoWsdlUrl,
        soapEnvelope: soapEnvelope,
        soapAction: soapAction,
      );

      final jsonText = SoapParser.extractGetCCPromoResultJson(xmlResponse);
      final rawItems = SoapParser.parsePromoItems(jsonText);

      return rawItems.map((map) => _mapToPromoMaterial(map)).toList();
    } catch (e) {
      return _generateFallbackPromos();
    }
  }

  PromoMaterial _mapToPromoMaterial(Map<String, dynamic> map) {
    String imageUrl = map['image']?.toString() ?? '';
    imageUrl = imageUrl.replaceAll(
      ApiConstants.originalPromoImageDomain,
      ApiConstants.replacePromoImageDomain,
    );

    return PromoMaterial(
      key: map['promo_key']?.toString() ?? 'promo',
      imageUrl: imageUrl,
      text: map['text']?.toString() ?? 'Exclusive Partner Promotion',
      link: map['link']?.toString() ?? 'https://www.instaforex.com',
      buttonText: map['button_text']?.toString() ?? 'Learn More',
      buttonColor: map['button_color']?.toString() ?? '#3A469A',
    );
  }

  List<PromoMaterial> _generateFallbackPromos() {
    return const [
      PromoMaterial(
        key: 'forex_copy',
        imageUrl: 'https://forex-images.ifxdb.com/interestingknow/thumb/608022d9f16b9.png',
        text: 'Forex Copy - Professionals trade, you earn with automated copying.',
        link: 'https://play.google.com/store/apps/details?id=com.instaforex.android.forexcopy',
        buttonText: 'Start earning today',
        buttonColor: '#3A469A',
      ),
      PromoMaterial(
        key: 'ferrari',
        imageUrl: 'https://forex-images.ifxdb.com/company_news/userfiles/ferrari.png',
        text: 'Open a trading account and participate in the raffle of the Ferrari F8 Tributo supercar!',
        link: 'https://www.instaforex.com/en/ferrari?x=mobcab',
        buttonText: 'I want to win a Ferrari!',
        buttonColor: '#ca3131',
      ),
      PromoMaterial(
        key: 'tether',
        imageUrl: 'https://forex-images.ifxdb.com/interestingknow/5f6209c90f127.png',
        text: 'Now you can make a deposit to your account with the most stable cryptocurrency - Tether!',
        link: 'https://secure.instaforex.com/deposit/b2binpay-preview?lang=en',
        buttonText: 'Make a deposit!',
        buttonColor: '#00a27b',
      ),
      PromoMaterial(
        key: 'lucky_deposit',
        imageUrl: 'https://forex-images.ifxdb.com/company_news/userfiles/lucky_deposit.png',
        text: 'Make a deposit today and get the chance to win \$8,000 in monthly draw',
        link: 'https://secure.instaforex.com/en/deposits?x=mobcab',
        buttonText: 'Deposit money now',
        buttonColor: '#EAB308',
      ),
    ];
  }
}
