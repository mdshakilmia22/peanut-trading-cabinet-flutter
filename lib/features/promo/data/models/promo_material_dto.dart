import '../../domain/entities/promo_material.dart';

class PromoMaterialDto {
  final String key;
  final String imageUrl;
  final String text;
  final String link;
  final String buttonText;
  final String buttonColor;

  const PromoMaterialDto({
    required this.key,
    required this.imageUrl,
    required this.text,
    required this.link,
    required this.buttonText,
    required this.buttonColor,
  });

  factory PromoMaterialDto.fromJson(Map<String, dynamic> json) {
    return PromoMaterialDto(
      key: json['promo_key']?.toString() ?? json['key']?.toString() ?? 'promo',
      imageUrl: json['image']?.toString() ?? json['imageUrl']?.toString() ?? '',
      text: json['text']?.toString() ?? 'Exclusive Partner Promotion',
      link: json['link']?.toString() ?? 'https://www.instaforex.com',
      buttonText:
          json['button_text']?.toString() ??
          json['buttonText']?.toString() ??
          'Learn More',
      buttonColor:
          json['button_color']?.toString() ??
          json['buttonColor']?.toString() ??
          '#3A469A',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'promo_key': key,
      'image': imageUrl,
      'text': text,
      'link': link,
      'button_text': buttonText,
      'button_color': buttonColor,
    };
  }

  PromoMaterial toEntity() {
    return PromoMaterial(
      key: key,
      imageUrl: imageUrl,
      text: text,
      link: link,
      buttonText: buttonText,
      buttonColor: buttonColor,
    );
  }

  factory PromoMaterialDto.fromEntity(PromoMaterial entity) {
    return PromoMaterialDto(
      key: entity.key,
      imageUrl: entity.imageUrl,
      text: entity.text,
      link: entity.link,
      buttonText: entity.buttonText,
      buttonColor: entity.buttonColor,
    );
  }
}
