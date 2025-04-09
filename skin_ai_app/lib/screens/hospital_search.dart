import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:skin_ai_app/models/healthcare_provider.dart';
import 'package:skin_ai_app/services/location_service.dart';
import 'package:skin_ai_app/screens/doctor_profile.dart';

class HospitalSearch extends StatefulWidget {
  final String userId;
  final LatLng? initialLocation;

  const HospitalSearch({
    super.key,
    required this.userId,
    this.initialLocation,
  });

  @override
  State<HospitalSearch> createState() => _HospitalSearchState();
}

class _HospitalSearchState extends State<HospitalSearch> {
  late GoogleMapController _mapController;
  final LocationService _locationService = LocationService();
  late LatLng _currentLocation;
  Set<Marker> _markers = {};
  List<HealthcareProvider> _hospitals = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _currentLocation = widget.initialLocation ?? const LatLng(0, 0);
    _loadHospitals();
  }

  Future<void> _loadHospitals() async {
    setState(() => _loading = true);
    try {
      _hospitals = await _locationService.findNearbyHospitals(_currentLocation);
      _updateMarkers();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading hospitals: $e')),
      );
    }
    setState(() => _loading = false);
  }

  void _updateMarkers() {
    _markers = _hospitals.map((hospital) {
      return Marker(
        markerId: MarkerId(hospital.id),
        position: hospital.location,
        infoWindow: InfoWindow(
          title: hospital.name,
          snippet: hospital.address,
        ),
        onTap: () => _showHospitalDetails(hospital),
      );
    }).toSet();
  }

  void _showHospitalDetails(HealthcareProvider hospital) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                hospital.name,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(hospital.address),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DoctorProfile(
                        doctor: hospital,
                        userId: widget.userId,
                      ),
                    ),
                  );
                },
                child: const Text('View Details'),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nearby Hospitals'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadHospitals,
          ),
        ],
      ),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: _currentLocation,
              zoom: 12,
            ),
            markers: _markers,
            onMapCreated: (controller) {
              _mapController = controller;
            },
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            onCameraMove: (position) {
              _currentLocation = position.target;
            },
          ),
          if (_loading)
            const Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _mapController.animateCamera(
            CameraUpdate.newLatLng(_currentLocation),
          );
          _loadHospitals();
        },
        child: const Icon(Icons.search),
      ),
    );
  }
}
