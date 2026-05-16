import 'package:equatable/equatable.dart';

class Application extends Equatable   {
  final String id;
  final String name;
  final String tagLine;
  final String subTitle;
  final String contact_email;
  final double free_shipping_threshold;
  final double standard_shipping_rate;
  final double express_shipping_rate;
  Application ({
    required this.id,
    required this.name,
    required this.tagLine,
    required this.subTitle,
    required this.contact_email,
    required this.free_shipping_threshold,
    required this.standard_shipping_rate,
    required this.express_shipping_rate,
  });

  Application copyWith({
    String? id,
    String? name,
    String? tagLine,
    String? subTitle,
    String? contact_email,
    double? free_shipping_threshold,
    double? standard_shipping_rate,
    double? express_shipping_rate,
  }) {
    return Application(
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


  @override
  List<Object?> get props => [id, name, tagLine, subTitle, contact_email, free_shipping_threshold, standard_shipping_rate, express_shipping_rate];
}