import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../data/api_result.dart';
import '../data/auth_repository.dart';
import '../models/auth_state.dart';

part 'auth_notifier.g.dart';

@riverpod
class AuthNotifier extends _$AuthNotifier {
  @override
  Future<AuthState> build() async {
    final repo = ref.read(authRepositoryProvider);
    final token = await repo.readAccessToken();
    if (token == null) return const Unauthenticated();
    if (repo.isTokenExpired(token)) {
      // No refresh endpoint exists on this API -- an expired token can only
      // be replaced by logging in again.
      await repo.logout();
      return const Unauthenticated();
    }
    return Authenticated(user: repo.decodeUser(token));
  }

  Future<void> login(String username, String password) async {
    state = const AsyncData(Authenticating());
    final result = await ref
        .read(authRepositoryProvider)
        .login(username, password);
    state = switch (result) {
      Success(:final data) => AsyncData(Authenticated(user: data)),
      Failure(:final message) => AsyncData(AuthError(message)),
    };
  }

  Future<void> logout() async {
    await ref.read(authRepositoryProvider).logout();
    state = const AsyncData(Unauthenticated());
    // Callers (the logout button) are responsible for invalidating data
    // providers. AuthNotifier must not import data notifiers to avoid a
    // circular import -- see bookings_screen.dart for the logout button.
  }
}
