import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar_community/isar.dart';

// Deliberate stub -- any code that reads this before main.dart overrides it
// gets a clear error instead of a null pointer. In a running app this throw
// is never reached because the override is installed before runApp().
final isarProvider = Provider<Isar>(
  (_) => throw UnimplementedError(
    'Isar not initialized -- override this in main.dart',
  ),
);
