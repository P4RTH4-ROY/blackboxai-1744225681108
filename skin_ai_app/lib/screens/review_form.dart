import 'package:flutter/material.dart';
import 'package:skin_ai_app/widgets/star_rating.dart';
import 'package:skin_ai_app/models/doctor_review.dart';
import 'package:skin_ai_app/services/rating_service.dart';

class ReviewForm extends StatefulWidget {
  final String doctorId;
  final String userId;

  const ReviewForm({
    super.key,
    required this.doctorId,
    required this.userId,
  });

  @override
  State<ReviewForm> createState() => _ReviewFormState();
}

class _ReviewFormState extends State<ReviewForm> {
  final _formKey = GlobalKey<FormState>();
  final _ratingService = RatingService();
  double _rating = 0.0;
  final _commentController = TextEditingController();
  String? _treatmentType;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Leave a Review'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'How would you rate your experience?',
                style: TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 8),
              StarRating(
                rating: _rating,
                allowEditing: true,
                onRatingChanged: (rating) {
                  setState(() {
                    _rating = rating;
                  });
                },
              ),
              const SizedBox(height: 24),
              TextFormField(
                controller: _commentController,
                decoration: const InputDecoration(
                  labelText: 'Your review',
                  border: OutlineInputBorder(),
                ),
                maxLines: 5,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your review';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _treatmentType,
                decoration: const InputDecoration(
                  labelText: 'Treatment Type (Optional)',
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(
                    value: 'acne',
                    child: Text('Acne Treatment'),
                  ),
                  DropdownMenuItem(
                    value: 'eczema',
                    child: Text('Eczema Treatment'),
                  ),
                  DropdownMenuItem(
                    value: 'psoriasis',
                    child: Text('Psoriasis Treatment'),
                  ),
                  DropdownMenuItem(
                    value: 'other',
                    child: Text('Other'),
                  ),
                ],
                onChanged: (value) {
                  setState(() {
                    _treatmentType = value;
                  });
                },
              ),
              const SizedBox(height: 24),
              Center(
                child: ElevatedButton(
                  onPressed: _submitReview,
                  child: const Text('Submit Review'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _submitReview() async {
    if (_formKey.currentState!.validate()) {
      final review = DoctorReview(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        doctorId: widget.doctorId,
        userId: widget.userId,
        rating: _rating,
        comment: _commentController.text,
        date: DateTime.now(),
        treatmentType: _treatmentType,
      );

      await _ratingService.submitReview(review);
      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }
}
