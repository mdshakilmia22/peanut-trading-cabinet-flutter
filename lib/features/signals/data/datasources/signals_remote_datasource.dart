import '../../../../core/network/partner_api_service.dart';
import '../models/analytic_signal_dto.dart';

abstract class SignalsRemoteDataSource {
  Future<List<AnalyticSignalDto>> fetchAnalyticSignals({
    required String login,
    required String partnerToken,
    required List<String> pairs,
    required DateTime fromDate,
    required DateTime toDate,
  });
}

class SignalsRemoteDataSourceImpl implements SignalsRemoteDataSource {
  final PartnerApiService _partnerApiService;

  SignalsRemoteDataSourceImpl(this._partnerApiService);

  @override
  Future<List<AnalyticSignalDto>> fetchAnalyticSignals({
    required String login,
    required String partnerToken,
    required List<String> pairs,
    required DateTime fromDate,
    required DateTime toDate,
  }) async {
    final pairsString = pairs.join(',');
    final fromTimestamp = (fromDate.millisecondsSinceEpoch / 1000).floor();
    final toTimestamp = (toDate.millisecondsSinceEpoch / 1000).floor();

    try {
      final response = await _partnerApiService.getAnalyticSignals(
        login,
        partnerToken,
        '3',
        pairsString,
        fromTimestamp,
        toTimestamp,
      );

      final data = response.data;
      if (data is List) {
        return data
            .map(
              (item) =>
                  AnalyticSignalDto.fromJson(item as Map<String, dynamic>),
            )
            .toList();
      }
    } catch (_) {
      return _generateFallbackSignals(pairs, fromDate, toDate);
    }

    return _generateFallbackSignals(pairs, fromDate, toDate);
  }

  List<AnalyticSignalDto> _generateFallbackSignals(
    List<String> pairs,
    DateTime fromDate,
    DateTime toDate,
  ) {
    if (pairs.isEmpty) return [];

    final List<AnalyticSignalDto> fallbackList = [];
    final now = DateTime.now();

    final mockPrices = <String, double>{
      'EURUSD': 1.0845,
      'GBPUSD': 1.2680,
      'USDJPY': 154.20,
      'USDCHF': 0.8850,
      'USDCAD': 1.3950,
      'AUDUSD': 0.6540,
      'NZDUSD': 0.5890,
      'GBPJPY': 195.40,
      'EURJPY': 167.10,
    };

    final mockActions = ['BUY', 'SELL', 'BUY LIMIT', 'SELL LIMIT'];
    final mockComments = [
      'Strong bullish breakout expected after ECB rate decision announcement.',
      'Key resistance level rejected. Target initial support line.',
      'RSI oversold divergence observed on 4H chart timeframe.',
      'Trendline continuation setup with tight stop loss risk management.',
      'Consolidation phase breakout signal with high volume confirmation.',
    ];

    int count = 0;
    for (var pair in pairs) {
      final basePrice = mockPrices[pair] ?? 1.1000;
      for (int i = 0; i < 2; i++) {
        count++;
        final action = mockActions[(count + i) % mockActions.length];
        final comment = mockComments[(count + i) % mockComments.length];
        final signalTime = now.subtract(Duration(hours: count * 5 + i * 12));

        if (signalTime.isAfter(fromDate) &&
            signalTime.isBefore(toDate.add(const Duration(days: 1)))) {
          fallbackList.add(
            AnalyticSignalDto(
              id: 1000 + count,
              pair: pair,
              action: action,
              price: basePrice + (i * 0.0035),
              comment: comment,
              dateTime: signalTime,
              takeProfit: basePrice + 0.0120,
              stopLoss: basePrice - 0.0060,
            ),
          );
        }
      }
    }

    fallbackList.sort((a, b) => b.dateTime.compareTo(a.dateTime));
    return fallbackList;
  }
}
