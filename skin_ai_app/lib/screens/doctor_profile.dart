import 'package:flutter/material.dart';
import 'package:skin_ai_app/models/healthcare_provider.dart';
import 'package:skin_ai_app/widgets/reviews_list.dart';
import 'package:skin_ai_app/widgets/star_rating.dart';
import 'package:skin_ai_app/screens/review_form.dart';
import 'package:skin_ai_app/services/rating_service.dart';

class DoctorProfile extends StatefulWidget {
  final HealthcareProvider doctor;
  final String userId;

  const DoctorProfile({
    super.key,
    required this.doctor,
    required this.userId,
  });

  @override
  State<DoctorProfile> createState() => _DoctorProfileState();
}

class _DoctorProfileState extends State<DoctorProfile> {
  final RatingService _ratingService = RatingService();
  late Future<double> _averageRating;

  @override
  void initState() {
    super.initState();
    _averageRating = _ratingService.getAverageRating(widget.doctor.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.doctor.name),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeader(),
            _buildReviewSection(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToReviewForm(),
        child: const Icon(Icons.edit),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.doctor.name,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            widget.doctor.specialty ?? 'Dermatologist',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 16),
          FutureBuilder<double>(
            future: _averageRating,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Row(
                  children: [
                    StarRating(
                      rating: snapshot.data!,
                      starSize: 24,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${snapshot.data!.toStringAsFixed(1)} (${widget.doctor.rating?.toStringAsFixed(1) ?? '0.0'})',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                );
              }
              return const CircularProgressIndicator();
            },
          ),
          const SizedBox(height: 16),
          _buildInfoRow(Icons.location_on, widget.doctor.address),
          if (widget.doctor.phone != null)
            _buildInfoRow(Icons.phone, widget.doctor.phone!),
          if (widget.doctor.website != null)
            _buildInfoRow(Icons.language, widget.doctor.website!),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 16),
          const SizedBox(width: 8),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }

  Widget _buildReviewSection() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Patient Reviews',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          StreamBuilder<List<DoctorReview>>(
            stream: _ratingService.getReviewsForDoctor(widget.doctor.id),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ReviewsList(reviews: snapshot.data!);
              }
              return const Center(child: CircularProgressIndicator());
            },
          ),
        ],
      ),
    );
  }

  void _navigateToReviewForm() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ReviewForm(
          doctorId: widget.doctor.id,
          userId: widget.userId,
        ),
      ),
    ).then((_) {
      setState(() {
        _averageRating = _ratingService.getAverageRating(widget.doctor.id);
      });
    });
  }
}
