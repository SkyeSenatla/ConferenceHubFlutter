// A sealed result type -- the compiler proves every switch on an ApiResult
// handles both variants. Replaces raw exceptions leaking out of the
// repository with a typed success/failure the caller must handle explicitly.
sealed class ApiResult<T> {
  const ApiResult();
}

class Success<T> extends ApiResult<T> {
  final T data;
  const Success(this.data);
}

class Failure<T> extends ApiResult<T> {
  final String message;
  final int? statusCode;
  const Failure(this.message, {this.statusCode});
}
