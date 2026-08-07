import 'package:elmaleka_kitchen_project/core/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';
import '../../../../data/models/review_model.dart';
import '../../../Widgets/rating_stars.dart';

class ProductHeader extends StatelessWidget {
  const ProductHeader({
    super.key,
    required this.productName,
    required this.titleFont,
    required this.productRating,
    required this.reviewsCount,
    required this.smallFont,
    required this.productPrice,
    required this.priceFont,
    this.summary,
    required this.categoryName,
  });
  final String categoryName;
  final String productName;
  final double titleFont;
  final double productRating;
  final int reviewsCount;
  final double smallFont;
  final double productPrice;
  final double priceFont;
  final ReviewSummary? summary;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 3.sw),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                      child: Text(
                        productName,
                        style: TextStyle(
                            fontSize: titleFont, fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(
                      width: 2.sw,
                    ),
                    Flexible(
                      child: Text(
                        categoryName,
                        style: TextStyle(
                            fontSize: 3.sw,
                            color: AppColors.secondaryColor,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
                _buildReviewHeader(summary)
                // RatingStars(rating: productRating, size: 6.sw,),
                // Text('($reviewsCountتقييمات) '
                //   , style: TextStyle(fontSize: smallFont),)
              ],
            ),
          ),
          Text(
            '$productPrice جنية',
            style: TextStyle(fontSize: priceFont, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewHeader(ReviewSummary? summary) {
    if (summary == null) return const SizedBox();
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.sw),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RatingStars(
            rating: summary.ratingAverage,
            size: 5.sw,
          ),
          Text(
            '${summary.ratingAverage.toStringAsFixed(1)} (${summary.ratingCount} '
            'تقييم)',
            style: TextStyle(fontSize: 4.sw, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
