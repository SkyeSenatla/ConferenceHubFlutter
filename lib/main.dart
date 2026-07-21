import 'package:conferencebookingsystemflutter/data/room_cache.dart' hide RoomCacheSchema;
import 'package:conferencebookingsystemflutter/router/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar_community/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/isar_provider.dart';
import 'core/prefs_provider.dart';
import 'data/room_cache.dart';
import 'router/app_router.dart';

Future<void> main() async {
  // Required whenever async work (path_provider, Isar, SharedPreferences)
  // runs before runApp() -- Flutter's native binding must exist first so
  // those plugins can use platform channels.
  WidgetsFlutterBinding.ensureInitialized();

  final dir = await getApplicationDocumentsDirectory();
  final isar = await Isar.open([RoomCacheSchema], directory: dir.path);

  final prefs = await SharedPreferences.getInstance();

  runApp(
    ProviderScope(
      overrides: [
        // Inject the pre-initialised singletons so every provider that
        // watches isarProvider/prefsProvider gets the real instance instead
        // of the stub's throw.
        isarProvider.overrideWithValue(isar),
        prefsProvider.overrideWithValue(prefs),
      ],
      child: const ConferenceHubApp(),
    ),
  );
}

class ConferenceHubApp extends ConsumerWidget {
  const ConferenceHubApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
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
      routerConfig: ref.watch(appRouterProvider),
    );
  }
}
