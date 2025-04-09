import 'package:google_maps_flutter/google_maps_flutter.dart';

class HealthcareProvider {
  final String id;
  final String name;
  final String address;
  final LatLng location;
  final double? rating;
  final bool? isOpen;
  final String type;
  final String? specialty;
  final String? phone;
  final String? website;

  HealthcareProvider({
    required this.id,
    required this.name,
    required this.address,
    required this.location,
    this.rating,
    this.isOpen,
    required this.type,
    this.specialty,
    this.phone,
    this.website,
  });

  factory HealthcareProvider.fromMap(Map<String, dynamic> map) {
    return HealthcareProvider(
      id: map['place_id'],
      name: map['name'],
      address: map['vicinity'],
      location: LatLng(
        map['geometry']['location']['lat'],
        map['geometry']['location']['lng'],
      ),
      rating: map['rating']?.toDouble(),
      isOpen: map['opening_hours']?['open_now'],
      type: map['types']?.contains('hospital') ?? false ? 'hospital' : 'clinic',
      specialty: map['types']?.contains('doctor') ?? false ? 'dermatologist' : null,
      phone: map['international_phone_number'],
      website: map['website'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'place_id': id,
      'name': name,
      'vicinity': address,
      'geometry': {
        'location': {
          'lat': location.latitude,
          'lng': location.longitude,
        },
      },
      'rating': rating,
      'opening_hours': {
        'open_now': isOpen,
      },
      'types': [type, if (specialty != null) specialty],
      'international_phone_number': phone,
      'website': website,
    };
  }
}
