class AppException implements Exception {
  const AppException(this.message, {this.code});

  final String message;
  final String? code;

  @override
  String toString() => 'AppException(message: $message, code: $code)';
}

class NetworkException extends AppException {
  const NetworkException(super.message) : super(code: 'network');
}

class ServerException extends AppException {
  const ServerException(super.message) : super(code: 'server');
}

class TimeoutException extends AppException {
  const TimeoutException(super.message) : super(code: 'timeout');
}

class NoInternetException extends AppException {
  const NoInternetException(super.message) : super(code: 'no_internet');
}

class UnknownException extends AppException {
  const UnknownException(super.message) : super(code: 'unknown');
}
