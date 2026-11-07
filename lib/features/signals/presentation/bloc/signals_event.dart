import 'package:equatable/equatable.dart';

abstract class SignalsEvent extends Equatable {
  const SignalsEvent();

  @override
  List<Object?> get props => [];
}

class FetchSignalsEvent extends SignalsEvent {
  final String login;
  final String partnerToken;
  final List<String> pairs;
  final DateTime fromDate;
  final DateTime toDate;

  const FetchSignalsEvent({
    required this.login,
    required this.partnerToken,
    required this.pairs,
    required this.fromDate,
    required this.toDate,
  });

  @override
  List<Object?> get props => [login, partnerToken, pairs, fromDate, toDate];
}

class TogglePairFilterEvent extends SignalsEvent {
  final String pair;

  const TogglePairFilterEvent(this.pair);

  @override
  List<Object?> get props => [pair];
}

class SelectDateRangeEvent extends SignalsEvent {
  final DateTime fromDate;
  final DateTime toDate;

  const SelectDateRangeEvent({
    required this.fromDate,
    required this.toDate,
  });

  @override
  List<Object?> get props => [fromDate, toDate];
}
