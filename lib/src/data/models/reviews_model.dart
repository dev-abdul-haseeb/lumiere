import '../../domain/entities/reviews.dart';

class ReviewsModel extends Reviews {
  const ReviewsModel({
    required super.review_id,
    required super.order_id,
    required super.product_id,
    required super.rating,
    required super.reviewDescription,
  });

  ReviewsModel copyWith({
    String? review_id,
    String? order_id,
    String? product_id,
    int? rating,
    String? reviewDescription,
  }) {
    return ReviewsModel(
      review_id: review_id ?? this.review_id,
      order_id: order_id ?? this.order_id,
      product_id: product_id ?? this.product_id,
      rating: rating ?? this.rating,
      reviewDescription: reviewDescription ?? this.reviewDescription,
    );
  }
}