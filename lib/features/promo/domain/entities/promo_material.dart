import 'package:equatable/equatable.dart';

class PromoMaterial extends Equatable {
  final String key;
  final String imageUrl;
  final String text;
  final String link;
  final String buttonText;
  final String buttonColor;

  const PromoMaterial({
    required this.key,
    required this.imageUrl,
    required this.text,
    required this.link,
    required this.buttonText,
    required this.buttonColor,
  });

  @override
  List<Object?> get props => [
        key,
        imageUrl,
        text,
        link,
        buttonText,
        buttonColor,
      ];
}
