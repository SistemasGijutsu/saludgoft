import 'package:dio/dio.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/constants/api_constants.dart';
import '../../models/auth_models.dart';

class AuthRepository {
  final Dio _dio = DioClient.dio;

  // Login
  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _dio.post(
        ApiConstants.login,
        data: {
          'email': email,
          'password': password,
        },
      );

      if (response.statusCode == 200) {
        return {
          'user': UserData.fromJson(response.data['user']),
          'token': response.data['token'] as String,
        };
      } else {
        throw Exception('Error en el login');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception(e.response!.data['message'] ?? 'Error en el login');
      } else {
        throw Exception('Error de conexión con el servidor');
      }
    }
  }

  // Register
  Future<Map<String, dynamic>> register({
    required String name,
    required String email,
    required String password,
    required String passwordConfirmation,
    required String role,
    String? phone,
  }) async {
    try {
      final response = await _dio.post(
        ApiConstants.register,
        data: {
          'name': name,
          'email': email,
          'password': password,
          'password_confirmation': passwordConfirmation,
          'role': role,
          if (phone != null) 'phone': phone,
        },
      );

      if (response.statusCode == 201) {
        return {
          'user': UserData.fromJson(response.data['user']),
          'token': response.data['token'] as String,
        };
      } else {
        throw Exception('Error en el registro');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception(e.response!.data['message'] ?? 'Error en el registro');
      } else {
        throw Exception('Error de conexión con el servidor');
      }
    }
  }

  // Register Doctor
  Future<Map<String, dynamic>> registerDoctor(DoctorRegisterRequest request) async {
    try {
      final response = await _dio.post(
        ApiConstants.registerDoctor,
        data: request.toJson(),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        return {
          'user': UserData.fromJson(response.data['user']),
          'token': response.data['token'] as String,
        };
      } else {
        throw Exception('Error en el registro del médico');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        final data = e.response!.data;
        final errorMessage = data is Map ? (data['error'] ?? data[' message'] ?? 'Error en el registro') : 'Error en el registro';
        throw Exception(errorMessage);
      } else {
        throw Exception('Error de conexión con el servidor');
      }
    }
  }

  // Logout
  Future<void> logout(String token) async {
    try {
      await _dio.post(
        ApiConstants.logout,
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );
    } catch (e) {
      // Ignorar errores de logout
    }
  }

  // Verificar token
  Future<UserData> verifyToken(String token) async {
    try {
      final response = await _dio.get(
        ApiConstants.profile,
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );

      if (response.statusCode == 200) {
        return UserData.fromJson(response.data['user']);
      } else {
        throw Exception('Token inválido');
      }
    } catch (e) {
      throw Exception('Token inválido');
    }
  }
}
