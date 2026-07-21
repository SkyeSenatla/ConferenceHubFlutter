import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

const _accessKey = 'access_token';

// This API has no refresh-token endpoint (AuthService only issues a single
// 2-hour access token), so there is no silent-refresh-and-retry step here --
// a 401 means the session is over. That is a real constraint of the backend
// in this repo, not a simplification of the pattern: attempting to "refresh"
// against an endpoint that doesn't exist would just be a second failed call.
class AuthInterceptor extends Interceptor {
  final FlutterSecureStorage _storage;
  final void Function() _onUnauthenticated;

  AuthInterceptor({
    required FlutterSecureStorage storage,
    required void Function() onUnauthenticated,
  }) : _storage = storage,
       _onUnauthenticated = onUnauthenticated;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await _storage.read(key: _accessKey);
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    if (err.response?.statusCode == 401) {
      await _storage.deleteAll();
      _onUnauthenticated();
    }
    handler.next(err);
  }
}
