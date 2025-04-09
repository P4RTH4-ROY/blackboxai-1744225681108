import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:skin_ai_app/screens/hospital_search.dart';

class LocationInput extends StatefulWidget {
  final String userId;

  const LocationInput({
    super.key,
    required this.userId,
  });

  @override
  State<LocationInput> createState() => _LocationInputState();
}

class _LocationInputState extends State<LocationInput> {
  final TextEditingController _searchController = TextEditingController();
  LatLng? _selectedLocation;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Find Hospitals'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Enter location',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: _searchLocation,
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text('OR'),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              icon: const Icon(Icons.location_on),
              label: const Text('Use Current Location'),
              onPressed: _useCurrentLocation,
            ),
            const SizedBox(height: 32),
            if (_selectedLocation != null)
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HospitalSearch(
                        userId: widget.userId,
                        initialLocation: _selectedLocation,
                      ),
                    ),
                  );
                },
                child: const Text('Find Nearby Hospitals'),
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _searchLocation() async {
    if (_searchController.text.isEmpty) return;

    setState(() {
      _selectedLocation = null;
    });

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    try {
      final geoService = GeolocationService();
      final location = await geoService.getLocationFromAddress(_searchController.text);
      
      if (location != null) {
        setState(() {
          _selectedLocation = location;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not find the specified location')),
        );
      }
    } finally {
      Navigator.of(context).pop();
    }
  }

  Future<void> _useCurrentLocation() async {
    setState(() {
      _selectedLocation = null;
    });

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    try {
      final geoService = GeolocationService();
      final location = await geoService.getCurrentLocation();
      
      if (location != null) {
        setState(() {
          _selectedLocation = location;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not access your current location')),
        );
      }
    } finally {
      Navigator.of(context).pop();
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
