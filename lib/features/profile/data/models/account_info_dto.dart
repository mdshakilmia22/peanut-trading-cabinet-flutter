import '../../domain/entities/account_info.dart';

class AccountInfoDto {
  final int login;
  final String name;
  final String phoneMask;
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

  const AccountInfoDto({
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

  factory AccountInfoDto.fromJson(
    Map<String, dynamic> json, {
    String phoneMask = '********0000',
    int login = 0,
  }) {
    return AccountInfoDto(
      login: (json['login'] as num?)?.toInt() ?? login,
      name: json['name']?.toString() ?? 'Test Trader Account',
      phoneMask: phoneMask,
      balance: (json['balance'] as num?)?.toDouble() ?? 2796.24,
      equity: (json['equity'] as num?)?.toDouble() ?? 2796.24,
      freeMargin: (json['freeMargin'] as num?)?.toDouble() ?? 2796.24,
      leverage: (json['leverage'] as num?)?.toInt() ?? 150,
      country: json['country']?.toString() ?? 'Default Country',
      city: json['city']?.toString() ?? 'Default City',
      address: json['address']?.toString() ?? 'Client Address',
      verificationLevel: (json['verificationLevel'] as num?)?.toInt() ?? 1,
      type: (json['type'] as num?)?.toInt() ?? 1,
      isPartialData: json['isPartialData'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'login': login,
      'name': name,
      'phoneMask': phoneMask,
      'balance': balance,
      'equity': equity,
      'freeMargin': freeMargin,
      'leverage': leverage,
      'country': country,
      'city': city,
      'address': address,
      'verificationLevel': verificationLevel,
      'type': type,
      'isPartialData': isPartialData,
    };
  }

  AccountInfo toEntity() {
    return AccountInfo(
      login: login,
      name: name,
      phoneMask: phoneMask,
      balance: balance,
      equity: equity,
      freeMargin: freeMargin,
      leverage: leverage,
      country: country,
      city: city,
      address: address,
      verificationLevel: verificationLevel,
      type: type,
      isPartialData: isPartialData,
    );
  }
}
