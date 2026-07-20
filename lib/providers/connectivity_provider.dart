import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final _connectivity = Connectivity();

// connectivity_plus returns a list because a device can be connected over
// Wi-Fi and mobile data simultaneously -- the list holds every active
// connection type.
final connectivityStreamProvider = StreamProvider<List<ConnectivityResult>>((
  ref,
) {
  return _connectivity.onConnectivityChanged;
});

final isOfflineProvider = Provider<bool>((ref) {
  return ref
      .watch(connectivityStreamProvider)
      .when(
        data: (results) => results.every((r) => r == ConnectivityResult.none),
        loading: () => false,
        error: (_, _) => false,
      );
});
