import 'package:equatable/equatable.dart';

class AccountInfo extends Equatable {
  final int login;
  final String name;
  final String phoneMask; // From GetLastFourNumbersPhone (e.g. ********0000)
  final double balance;
  final double equity;
  final double freeMargin;
  final int leverage;
  final String country;
  final String city;
  final String address;
  final int verificationLevel;
  final int type;
  final bool isPartialData;

  const AccountInfo({
    required this.login,
    required this.name,
    required this.phoneMask,
    required this.balance,
    required this.equity,
    required this.freeMargin,
    required this.leverage,
    required this.country,
    required this.city,
    required this.address,
    required this.verificationLevel,
    required this.type,
    this.isPartialData = false,
  });

  @override
  List<Object?> get props => [
        login,
        name,
        phoneMask,
        balance,
        equity,
        freeMargin,
        leverage,
        country,
        city,
        address,
        verificationLevel,
        type,
        isPartialData,
      ];
}
