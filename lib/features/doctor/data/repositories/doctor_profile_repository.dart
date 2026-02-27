import 'package:dio/dio.dart';
import '../../../../core/network/dio_client.dart';

class DoctorProfileRepository {
  final Dio _dio = DioClient.dio;

  DoctorProfileRepository();

  /// Obtener información del perfil del doctor
  Future<Map<String, dynamic>> getDoctorProfile(int userId) async {
    try {
      final response = await _dio.get(
        '/doctors/profile/$userId',
      );
      return response.data;
    } on DioException catch (e) {
      throw Exception(
        e.response?.data['message'] ?? 'Error al obtener perfil del doctor',
      );
    }
  }

  /// Actualizar nombre y correo del doctor
  Future<Map<String, dynamic>> updateDoctorProfile({
    required int userId,
    String? nombre,
    String? email,
    String? ciudad,
  }) async {
    try {
      final data = <String, dynamic>{};
      if (nombre != null) data['nombre'] = nombre;
      if (email != null) data['email'] = email;
      if (ciudad != null) data['ciudad'] = ciudad;

      // Usar el endpoint /me que requiere autenticación
      // El token se agrega automáticamente por el interceptor de DioClient
      final response = await _dio.put(
        '/me',
        data: data,
      );
      return response.data;
    } on DioException catch (e) {
      // Log detallado del error
      print('Error al actualizar perfil:');
      print('Status code: ${e.response?.statusCode}');
      print('Response data: ${e.response?.data}');
      print('Error message: ${e.message}');
      
      String errorMessage = 'Error al actualizar perfil';
      if (e.response?.data != null) {
        if (e.response!.data is Map) {
          errorMessage = e.response!.data['error'] ?? 
                        e.response!.data['message'] ?? 
                        errorMessage;
        }
      }
      throw Exception(errorMessage);
    }
  }

  /// Actualizar foto de perfil
  Future<Map<String, dynamic>> updateProfilePhoto({
    required int userId,
    required String photoPath,
  }) async {
    try {
      final formData = FormData.fromMap({
        'foto_perfil': await MultipartFile.fromFile(
          photoPath,
          filename: 'profile_${userId}_${DateTime.now().millisecondsSinceEpoch}.jpg',
        ),
      });

      // Usar el endpoint /me/photo que requiere autenticación
      // El token se agrega automáticamente por el interceptor de DioClient
      final response = await _dio.post(
        '/me/photo',
        data: formData,
        options: Options(
          headers: {
            'Content-Type': 'multipart/form-data',
          },
        ),
      );
      
      if (response.statusCode == 200 || response.statusCode == 201) {
        return response.data;
      } else {
        throw Exception('Error al subir foto: ${response.statusCode}');
      }
    } on DioException catch (e) {
      // Log detallado del error
      print('Error al subir foto:');
      print('Status code: ${e.response?.statusCode}');
      print('Response data: ${e.response?.data}');
      print('Error message: ${e.message}');
      
      String errorMessage = 'Error al subir foto de perfil';
      if (e.response?.data != null) {
        if (e.response!.data is Map) {
          errorMessage = e.response!.data['error'] ?? 
                        e.response!.data['message'] ?? 
                        errorMessage;
        }
      }
      throw Exception(errorMessage);
    } catch (e) {
      print('Error inesperado: $e');
      throw Exception('Error inesperado al subir foto: $e');
    }
  }

  /// Obtener estadísticas del doctor (consultas, calificación, etc.)
  Future<Map<String, dynamic>> getDoctorStats(int userId) async {
    try {
      final response = await _dio.get(
        '/doctors/stats/$userId',
      );
      return response.data;
    } on DioException catch (e) {
      throw Exception(
        e.response?.data['message'] ?? 'Error al obtener estadísticas',
      );
    }
  }
}
