import 'package:equatable/equatable.dart';

class Reviews extends Equatable {
  final String review_id;
  final String order_id;
  final String product_id;
  final int rating;
  final String reviewDescription;

  const Reviews({
    required this.review_id,
    required this.order_id,
    required this.product_id,
    required this.rating,
    required this.reviewDescription,
  });

  @override
  List<Object?> get props => [
    review_id,
    order_id,
    product_id,
    rating,
    reviewDescription,
  ];
}