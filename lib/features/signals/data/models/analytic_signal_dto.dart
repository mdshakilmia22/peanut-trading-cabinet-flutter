import '../../domain/entities/analytic_signal.dart';

class AnalyticSignalDto {
  final int id;
  final String pair;
  final String action;
  final double price;
  final String comment;
  final DateTime dateTime;
  final double? takeProfit;
  final double? stopLoss;

  const AnalyticSignalDto({
    required this.id,
    required this.pair,
    required this.action,
    required this.price,
    required this.comment,
    required this.dateTime,
    this.takeProfit,
    this.stopLoss,
  });

  factory AnalyticSignalDto.fromJson(Map<String, dynamic> json) {
    final id =
        (json['id'] as num?)?.toInt() ??
        (json['Id'] as num?)?.toInt() ??
        DateTime.now().millisecondsSinceEpoch;
    final pair =
        json['pair']?.toString() ?? json['Pair']?.toString() ?? 'EURUSD';
    final action =
        (json['cmd']?.toString() ?? json['Type']?.toString() ?? 'BUY')
            .toUpperCase();
    final price =
        (json['price'] as num?)?.toDouble() ??
        (json['Price'] as num?)?.toDouble() ??
        1.0850;
    final comment =
        json['comment']?.toString() ??
        json['Comment']?.toString() ??
        'Analytic signal recommendation';

    final dateVal = json['date'] ?? json['Time'] ?? json['from'];
    DateTime dateTime = DateTime.now();
    if (dateVal is int) {
      dateTime = DateTime.fromMillisecondsSinceEpoch(dateVal * 1000);
    } else if (dateVal is String) {
      dateTime = DateTime.tryParse(dateVal) ?? DateTime.now();
    }

    return AnalyticSignalDto(
      id: id,
      pair: pair,
      action: action,
      price: price,
      comment: comment,
      dateTime: dateTime,
      takeProfit: (json['tp'] as num?)?.toDouble(),
      stopLoss: (json['sl'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'pair': pair,
      'action': action,
      'price': price,
      'comment': comment,
      'dateTime': dateTime.toIso8601String(),
      'takeProfit': takeProfit,
      'stopLoss': stopLoss,
    };
  }

  AnalyticSignal toEntity() {
    return AnalyticSignal(
      id: id,
      pair: pair,
      action: action,
      price: price,
      comment: comment,
      dateTime: dateTime,
      takeProfit: takeProfit,
      stopLoss: stopLoss,
    );
  }
}
