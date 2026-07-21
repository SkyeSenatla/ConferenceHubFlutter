// Plain Dart class with no imports. The API's JWT carries only two claims --
// sub (username) and role -- so that's all this app knows about a user.
// There is no email or display name anywhere in this backend.
class User {
  final String username;
  final String role;

  const User({required this.username, required this.role});
}
