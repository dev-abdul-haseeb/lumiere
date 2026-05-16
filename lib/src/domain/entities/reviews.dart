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

  Reviews copyWith({
    String? review_id,
    String? order_id,
    String? product_id,
    int? rating,
    String? reviewDescription,
  }) {
    return Reviews(
      review_id: review_id ?? this.review_id,
      order_id: order_id ?? this.order_id,
      product_id: product_id ?? this.product_id,
      rating: rating ?? this.rating,
      reviewDescription: reviewDescription ?? this.reviewDescription,
    );
  }

  @override
  List<Object?> get props => [
    review_id,
    order_id,
    product_id,
    rating,
    reviewDescription,
  ];
}