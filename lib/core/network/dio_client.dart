import 'package:dio/dio.dart';
import '../constants/api_constants.dart';
import 'jwt_interceptor.dart';
import '../../features/auth/providers/auth_provider.dart' show TEST_MODE;

class DioClient {
  DioClient._();
  static final DioClient instance = DioClient._();

  late final Dio _dio;
  Dio get dio => _dio;

  void init() {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
        sendTimeout: const Duration(seconds: 15),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );
    
    // Test mode: block all API calls
    if (TEST_MODE) {
      _dio.interceptors.add(InterceptorsWrapper(
        onRequest: (options, handler) {
          // Block all requests in test mode
          handler.reject(
            DioException(
              requestOptions: options,
              type: DioExceptionType.unknown,
              error: 'API calls disabled in test mode',
            ),
          );
        },
      ));
    } else {
      _dio.interceptors.add(JwtInterceptor());
    }
    
    _dio.interceptors.add(LogInterceptor(
      requestBody: false,
      responseBody: false,
      logPrint: (_) {}, // silent in prod; swap with print(_) for debug
    ));
  }

  /// Extracts a user-friendly error message from a DioException.
  static String errorMessage(dynamic e) {
    if (e is DioException) {
      final data = e.response?.data;
      if (data is Map) return data['message']?.toString() ?? _fromType(e.type);
      if (data is String && data.isNotEmpty) return data;
      return _fromType(e.type);
    }
    return e.toString();
  }

  static String _fromType(DioExceptionType t) {
    switch (t) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return 'Délai de connexion dépassé';
      case DioExceptionType.connectionError:
        return 'Impossible de contacter le serveur';
      default:
        return 'Une erreur est survenue';
    }
  }
}
