import 'user.dart';

// Dart 3 sealed class -- no Freezed, no build_runner, no .g.dart file. The
// sealed keyword closes the hierarchy so any switch on AuthState is checked
// for exhaustiveness by the compiler.
sealed class AuthState {
  const AuthState();
}

final class Unauthenticated extends AuthState {
  const Unauthenticated();
}

final class Authenticating extends AuthState {
  const Authenticating();
}

final class Authenticated extends AuthState {
  final User user;
  const Authenticated({required this.user});
}

final class AuthError extends AuthState {
  final String message;
  const AuthError(this.message);
}
