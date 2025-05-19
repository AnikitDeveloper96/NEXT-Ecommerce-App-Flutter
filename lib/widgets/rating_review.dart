import 'package:flutter/material.dart';
import 'package:smooth_star_rating_null_safety/smooth_star_rating_null_safety.dart';

import '../models/product_model.dart';

class RatingReviewsSection extends StatefulWidget {
  final List<Review> reviews;
  final double maxWidth;

  const RatingReviewsSection({
    super.key,
    required this.reviews,
    required this.maxWidth,
  });

  @override
  State<RatingReviewsSection> createState() => _RatingReviewsSectionState();
}

class _RatingReviewsSectionState extends State<RatingReviewsSection> {
  bool _showAllReviews = false;

  @override
  Widget build(BuildContext context) {
    if (widget.reviews.isEmpty) {
      return const Center(child: Text("No reviews yet.", style: TextStyle(fontSize: 16)));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.reviews.length > 2)
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Rating & Reviews",
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                InkWell(
                  onTap: () {
                    setState(() {
                      _showAllReviews = !_showAllReviews;
                    });
                  },
                  child: Text(
                    _showAllReviews ? "See Less" : "See More",
                    style: const TextStyle(
                      color: Colors.black,
                      decoration: TextDecoration.underline,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),
        const SizedBox(height: 12),
        ListView.builder(
          shrinkWrap: true,
          physics: const ClampingScrollPhysics(),
          itemCount: _showAllReviews ? widget.reviews.length : (widget.reviews.length > 2 ? 2 : widget.reviews.length),
          itemBuilder: (context, index) {
            return _buildReviewTile(widget.reviews[index]);
          },
        ),
      ],
    );
  }

  Widget _buildReviewTile(Review review) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CircleAvatar(radius: 18, child: Icon(Icons.person, size: 24)),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          review.reviewerName ?? "Anonymous",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        SmoothStarRating(
                          allowHalfRating: true,
                          starCount: 5,
                          rating: (review.rating ?? 0).toDouble(),
                          size: 16,
                          color: Colors.amber,
                          borderColor: Colors.grey,
                          onRatingChanged: (rating) {},
                        ),
                      ],
                    ),
                    const SizedBox(height: 8.0),
                    if (review.comment != null && review.comment!.isNotEmpty)
                      Text(
                        review.comment!,
                        style: const TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: 15,
                          color: Colors.black87,
                        ),
                        maxLines: 10,
                        overflow: TextOverflow.ellipsis,
                      ),
                  ],
                ),
              ),
            ],
          ),
          const Divider(height: 20, thickness: 0.5, color: Colors.grey),
        ],
      ),
    );
  }
}