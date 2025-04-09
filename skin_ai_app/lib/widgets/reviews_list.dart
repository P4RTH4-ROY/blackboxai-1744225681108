import 'package:flutter/material.dart';
import 'package:skin_ai_app/models/doctor_review.dart';
import 'package:skin_ai_app/widgets/star_rating.dart';
import 'package:intl/intl.dart';

class ReviewsList extends StatelessWidget {
  final List<DoctorReview> reviews;
  final bool showUserInfo;

  const ReviewsList({
    super.key,
    required this.reviews,
    this.showUserInfo = true,
  });

  @override
  Widget build(BuildContext context) {
    if (reviews.isEmpty) {
      return const Center(
        child: Text('No reviews yet'),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: reviews.length,
      itemBuilder: (context, index) {
        final review = reviews[index];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (showUserInfo)
                  Text(
                    'Patient ${review.userId.substring(0, 6)}...',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    StarRating(
                      rating: review.rating,
                      starSize: 16,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      DateFormat('MMM d, y').format(review.date),
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                if (review.treatmentType != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    'Treatment: ${_formatTreatmentType(review.treatmentType!)}',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                    ),
                  ),
                ],
                const SizedBox(height: 8),
                Text(
                  review.comment,
                  style: const TextStyle(fontSize: 14),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  String _formatTreatmentType(String type) {
    switch (type) {
      case 'acne':
        return 'Acne';
      case 'eczema':
        return 'Eczema';
      case 'psoriasis':
        return 'Psoriasis';
      case 'other':
        return 'Other';
      default:
        return type;
    }
  }
}
