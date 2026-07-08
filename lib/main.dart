import 'package:flutter/material.dart';
import 'screens/bookings_screen.dart';

// Entry point of every Flutter app -- attaches the root widget to the screen.
void main() {
  runApp(const ConferenceHubApp());
}

// Root widget. Sets up Material theming and picks the first screen shown.
class ConferenceHubApp extends StatelessWidget {
  const ConferenceHubApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ConferenceHub',
      theme: ThemeData(
        // ColorScheme.fromSeed derives a full, accessible Material 3
        // colour palette from a single seed colour.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: const BookingsScreen(),
    );
  }
}
