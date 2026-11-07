import 'package:equatable/equatable.dart';

class AnalyticSignal extends Equatable {
  final int id;
  final String pair;
  final String action; // BUY, SELL, BUY LIMIT, SELL LIMIT, etc.
  final double price;
  final String comment;
  final DateTime dateTime;
  final double? takeProfit;
  final double? stopLoss;

  const AnalyticSignal({
    required this.id,
    required this.pair,
    required this.action,
    required this.price,
    required this.comment,
    required this.dateTime,
    this.takeProfit,
    this.stopLoss,
  });

  @override
  List<Object?> get props => [
        id,
        pair,
        action,
        price,
        comment,
        dateTime,
        takeProfit,
        stopLoss,
      ];
}
