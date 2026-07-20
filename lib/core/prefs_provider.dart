import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final prefsProvider = Provider<SharedPreferences>(
  (_) => throw UnimplementedError(
    'SharedPreferences not initialized -- override in main.dart',
  ),
);
