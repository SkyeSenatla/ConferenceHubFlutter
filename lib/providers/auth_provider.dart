import 'package:flutter/foundation.dart';
import 'package:riverpod/riverpod.dart';
import '../models/auth_state.dart';
import 'auth_notifier.dart';

// Provides the callback dioProvider registers as its onUnauthenticated
// handler. Defined here in the providers layer so bookings_repository.dart
// can import this file rather than importing auth_notifier.dart directly
// across the data/providers layer boundary -- see the circular-import note
// on AuthNotifier.logout().
final onUnauthenticatedProvider = Provider<void Function()>((ref) {
  return () => ref.invalidate(authProvider);
});

// Bridges Riverpod's provider graph to GoRouter's Listenable mechanism.
// GoRouter re-evaluates its redirect callback whenever this notifier calls
// notifyListeners.
class AuthStateListenable extends ChangeNotifier {
  AuthStateListenable(Ref ref) {
    _sub = ref.listen(authProvider, (_, _) => notifyListeners());
  }

  late final ProviderSubscription<AsyncValue<AuthState>> _sub;

  @override
  void dispose() {
    _sub.close();
    super.dispose();
  }
}

final authStateListenableProvider = Provider<AuthStateListenable>((ref) {
  final notifier = AuthStateListenable(ref);
  ref.onDispose(notifier.dispose);
  return notifier;
});
