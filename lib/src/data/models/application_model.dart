import 'package:lumiere/src/domain/entities/application.dart';

import '../../domain/entities/user.dart';

class ApplicationModel extends Application {
  ApplicationModel({
    required super.id,
    required super.name,
    required super.tagLine,
    required super.subTitle,
    required super.contact_email,
    required super.free_shipping_threshold,
    required super.standard_shipping_rate,
    required super.express_shipping_rate,
  });

  ApplicationModel copyWith({
    String? id,
    String? name,
    String? tagLine,
    String? subTitle,
    String? contact_email,
    double? free_shipping_threshold,
    double? standard_shipping_rate,
    double? express_shipping_rate,
  }) {
    return ApplicationModel(
      id: id ?? this.id,
      name: name ?? this.name,
      tagLine: tagLine ?? this.tagLine,
      subTitle: subTitle ?? this.subTitle,
      contact_email: contact_email ?? this.contact_email,
      free_shipping_threshold: free_shipping_threshold ?? this.free_shipping_threshold,
      standard_shipping_rate: standard_shipping_rate ?? this.standard_shipping_rate,
      express_shipping_rate: express_shipping_rate ?? this.express_shipping_rate,
    );
  }

  factory ApplicationModel.fromMap(Map<String, dynamic> map) {
    return ApplicationModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      tagLine: map['tagLine'] ?? '',
      subTitle: map['subTitle'] ?? '',
      contact_email: map['contact_email'] ?? '',
      free_shipping_threshold: (map['free_shipping_threshold'] ?? 0).toDouble(),
      standard_shipping_rate: (map['standard_shipping_rate'] ?? 0).toDouble(),
      express_shipping_rate: (map['express_shipping_rate'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'subTitle': subTitle,
      'tagLine': tagLine,
      'contact_email': contact_email,
      'free_shipping_threshold': free_shipping_threshold,
      'standard_shipping_rate': standard_shipping_rate,
      'express_shipping_rate': express_shipping_rate,
    };
  }

}