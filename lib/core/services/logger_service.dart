import 'package:logger/logger.dart';

class LoggerService {
  final Logger _logger = Logger(
    printer: PrettyPrinter(
      methodCount: 0,
      errorMethodCount: 8,
      lineLength: 120,
      colors: true,
      printEmojis: true,
      printTime: true,
    ),
  );

  void debug(dynamic message) {
    _logger.d(message);
  }

  void info(dynamic message) {
    _logger.i(message);
  }

  void warning(dynamic message) {
    _logger.w(message);
  }

  void error(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    _logger.e(message, error: error, stackTrace: stackTrace);
  }

  void critical(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    _logger.f(message, error: error, stackTrace: stackTrace);
  }

  void logUserAction(String action, Map<String, dynamic> details) {
    _logger.i('USER ACTION: $action - ${details.toString()}');
  }
}
