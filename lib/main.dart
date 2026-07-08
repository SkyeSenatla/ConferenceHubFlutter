import 'package:flutter/material.dart';
import 'screens/bookings_screen.dart';

void main() {
  runApp(const ConferenceHubApp());
}

class ConferenceHubApp extends StatelessWidget {
  const ConferenceHubApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ConferenceHub',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.indigo,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      themeMode: ThemeMode.system,
      home: const BookingsScreen(),
    );
  }
}
