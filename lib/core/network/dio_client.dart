import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DioClient {
  static Dio? _dio;

  static Dio get dio {
    if (_dio != null) return _dio!;
    
    _dio = Dio(
      BaseOptions(
        // Para celular real: usa la IP de tu PC (ej: 192.168.1.100:8080)
        // Para emulador Android: usa 10.0.2.2
        // Para emulador iOS: usa localhost
        baseUrl: 'http://10.0.2.2:8080/saludgoft/saludgo-backend/public/api',
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    // Interceptor para agregar el token de autenticación
    _dio!.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // Agregar el token desde SharedPreferences
          final prefs = await SharedPreferences.getInstance();
          final token = prefs.getString('token');
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
        onError: (DioException e, handler) {
          // Manejo global de errores
          return handler.next(e);
        },
      ),
    );

    return _dio!;
  }

  // Método para actualizar la baseUrl (útil cuando uses tu celular)
  static void updateBaseUrl(String newBaseUrl) {
    _dio?.options.baseUrl = newBaseUrl;
  }
}
