import 'package:cloud_firestore/cloud_firestore.dart';

class DoctorReview {
  final String id;
  final String doctorId;
  final String userId;
  final double rating;
  final String comment;
  final DateTime date;
  final String? treatmentType;

  DoctorReview({
    required this.id,
    required this.doctorId,
    required this.userId,
    required this.rating,
    required this.comment,
    required this.date,
    this.treatmentType,
  });

  factory DoctorReview.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return DoctorReview(
      id: doc.id,
      doctorId: data['doctorId'],
      userId: data['userId'],
      rating: data['rating'].toDouble(),
      comment: data['comment'],
      date: (data['date'] as Timestamp).toDate(),
      treatmentType: data['treatmentType'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'doctorId': doctorId,
      'userId': userId,
      'rating': rating,
      'comment': comment,
      'date': Timestamp.fromDate(date),
      'treatmentType': treatmentType,
    };
  }
}
