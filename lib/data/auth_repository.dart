import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../models/user.dart';
import 'api_result.dart';

part 'auth_repository.g.dart';

const _accessKey = 'access_token';

// The full URI the JWT payload uses for the role claim. AuthService on the
// API builds the token with `new Claim(ClaimTypes.Role, role)` directly,
// without an outbound claim-type mapping, so the payload key is the literal
// ClaimTypes.Role constant, not the short string "role".
const _roleClaimUri =
    'http://schemas.microsoft.com/ws/2008/06/identity/claims/role';

@riverpod
AuthRepository authRepository(Ref ref) {
  // Auth calls use their own plain Dio with no interceptors. This API has no
  // refresh endpoint, so there is no infinite-loop risk the way there would
  // be if a refresh call were routed through AuthInterceptor -- but keeping
  // login on its own Dio still avoids coupling auth to the main client's
  // logging/interceptor stack.
  return AuthRepository(
    dio: Dio(
      BaseOptions(
        baseUrl: const String.fromEnvironment(
          'API_BASE_URL',
          defaultValue: 'http://10.0.2.2:5247',
        ),
      ),
    ),
    storage: const FlutterSecureStorage(),
  );
}

class AuthRepository {
  final Dio _dio;
  final FlutterSecureStorage _storage;

  const AuthRepository({required Dio dio, required FlutterSecureStorage storage})
    : _dio = dio,
      _storage = storage;

  Future<String?> readAccessToken() => _storage.read(key: _accessKey);

  bool isTokenExpired(String token) {
    try {
      final payload = _decodePayload(token);
      final exp = payload['exp'] as int?;
      if (exp == null) return false;
      return DateTime.fromMillisecondsSinceEpoch(
        exp * 1000,
      ).isBefore(DateTime.now());
    } catch (_) {
      return true;
    }
  }

  User decodeUser(String token) {
    final payload = _decodePayload(token);
    return User(
      username: payload['sub'] as String? ?? '',
      role: payload[_roleClaimUri] as String? ?? '',
    );
  }

  Future<ApiResult<User>> login(String username, String password) async {
    try {
      final response = await _dio.post<dynamic>(
        '/api/auth/login',
        data: {'username': username, 'password': password},
      );
      final data = response.data as Map<String, dynamic>;
      final token = data['token'] as String;
      await _storage.write(key: _accessKey, value: token);
      return Success(decodeUser(token));
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return const Failure('Invalid username or password.');
      }
      return Failure(_dioMessage(e));
    } catch (_) {
      return const Failure('An unexpected error occurred.');
    }
  }

  Future<void> logout() async => _storage.deleteAll();

  static Map<String, dynamic> _decodePayload(String token) {
    final parts = token.split('.');
    if (parts.length != 3) throw const FormatException('Malformed JWT');
    var segment = parts[1];
    // Base64URL omits trailing = padding. Add it back before decoding.
    switch (segment.length % 4) {
      case 2:
        segment += '==';
      case 3:
        segment += '=';
    }
    return json.decode(utf8.decode(base64Url.decode(segment)))
        as Map<String, dynamic>;
  }

  String _dioMessage(DioException e) => switch (e.type) {
    DioExceptionType.connectionError => 'Could not reach the server.',
    DioExceptionType.connectionTimeout => 'Connection timed out.',
    DioExceptionType.receiveTimeout => 'The server took too long to respond.',
    _ => 'Network error. Please try again.',
  };
}
