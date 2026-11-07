import 'package:equatable/equatable.dart';
import '../../domain/entities/analytic_signal.dart';

abstract class SignalsState extends Equatable {
  final List<String> selectedPairs;
  final DateTime fromDate;
  final DateTime toDate;

  const SignalsState({
    required this.selectedPairs,
    required this.fromDate,
    required this.toDate,
  });

  @override
  List<Object?> get props => [selectedPairs, fromDate, toDate];
}

class SignalsInitial extends SignalsState {
  SignalsInitial({
    required super.selectedPairs,
    required super.fromDate,
    required super.toDate,
  });
}

class SignalsLoading extends SignalsState {
  SignalsLoading({
    required super.selectedPairs,
    required super.fromDate,
    required super.toDate,
  });
}

class SignalsLoaded extends SignalsState {
  final List<AnalyticSignal> signals;

  SignalsLoaded({
    required this.signals,
    required super.selectedPairs,
    required super.fromDate,
    required super.toDate,
  });

  @override
  List<Object?> get props => [signals, ...super.props];
}

class SignalsError extends SignalsState {
  final String message;

  SignalsError({
    required this.message,
    required super.selectedPairs,
    required super.fromDate,
    required super.toDate,
  });

  @override
  List<Object?> get props => [message, ...super.props];
}
