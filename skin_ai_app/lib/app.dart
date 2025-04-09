import 'package:flutter/material.dart';
import 'package:skin_ai_app/screens/home_screen.dart';
import 'package:skin_ai_app/screens/location_input.dart';
import 'package:skin_ai_app/screens/hospital_search.dart';
import 'package:skin_ai_app/screens/doctor_profile.dart';
import 'package:skin_ai_app/screens/review_form.dart';

class SkinAIApp extends StatelessWidget {
  const SkinAIApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Skin AI',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeScreen(),
        '/location': (context) => const LocationInput(userId: 'user123'),
        '/hospitals': (context) {
          final args = ModalRoute.of(context)!.settings.arguments as Map;
          return HospitalSearch(
            userId: args['userId'],
            initialLocation: args['location'],
          );
        },
        '/doctor': (context) {
          final args = ModalRoute.of(context)!.settings.arguments as Map;
          return DoctorProfile(
            doctor: args['doctor'],
            userId: args['userId'],
          );
        },
        '/review': (context) {
          final args = ModalRoute.of(context)!.settings.arguments as Map;
          return ReviewForm(
            doctorId: args['doctorId'],
            userId: args['userId'],
          );
        },
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
