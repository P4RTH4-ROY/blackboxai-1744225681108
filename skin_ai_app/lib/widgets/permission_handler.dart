import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class PermissionHandler {
  static Future<bool> checkLocationPermission(BuildContext context) async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await _showServiceDisabledDialog(context);
      return false;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        await _showPermissionDeniedDialog(context);
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      await _showPermissionPermanentlyDeniedDialog(context);
      return false;
    }

    return true;
  }

  static Future<void> _showServiceDisabledDialog(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Location Services Disabled'),
        content: const Text(
            'Please enable location services to use this feature.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
          TextButton(
            onPressed: () => Geolocator.openLocationSettings(),
            child: const Text('Settings'),
          ),
        ],
      ),
    );
  }

  static Future<void> _showPermissionDeniedDialog(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Location Permission Required'),
        content: const Text(
            'This app needs location permissions to find nearby hospitals.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await Geolocator.requestPermission();
            },
            child: const Text('Request Again'),
          ),
        ],
      ),
    );
  }

  static Future<void> _showPermissionPermanentlyDeniedDialog(
      BuildContext context) async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Location Permission Denied'),
        content: const Text(
            'Please enable location permissions in app settings.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Geolocator.openAppSettings(),
            child: const Text('Open Settings'),
          ),
        ],
      ),
    );
  }
}
