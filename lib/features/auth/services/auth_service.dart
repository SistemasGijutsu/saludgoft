import '../../../core/config/api_config.dart';
import '../../../core/services/api_service.dart';
import '../../../core/services/storage_service.dart';
import '../models/auth_models.dart';

/// Servicio de autenticación
class AuthService {
  final ApiService _apiService;

  AuthService(this._apiService);

  /// Registrar un nuevo paciente
  Future<AuthResponse> registerPatient(PatientRegisterRequest request) async {
    try {
      final response = await _apiService.post(
        ApiConfig.register,
        data: request.toJson(),
      );

      final authResponse = AuthResponse.fromJson(response.data);

      // Guardar el token y la información del usuario
      await StorageService.saveToken(authResponse.token);
      await StorageService.saveUserInfo(
        userId: authResponse.user.id,
        role: authResponse.user.rol,
      );

      return authResponse;
    } catch (e) {
      rethrow;
    }
  }

  /// Registrar un nuevo médico/profesional
  Future<AuthResponse> registerDoctor(DoctorRegisterRequest request) async {
    try {
      final response = await _apiService.post(
        ApiConfig.registerDoctor,
        data: request.toJson(),
      );

      final authResponse = AuthResponse.fromJson(response.data);

      // Guardar el token y la información del usuario
      await StorageService.saveToken(authResponse.token);
      await StorageService.saveUserInfo(
        userId: authResponse.user.id,
        role: authResponse.user.rol,
      );

      return authResponse;
    } catch (e) {
      rethrow;
    }
  }

  /// Iniciar sesión
  Future<AuthResponse> login(String email, String password) async {
    try {
      final request = LoginRequest(email: email, password: password);
      
      final response = await _apiService.post(
        ApiConfig.login,
        data: request.toJson(),
      );

      final authResponse = AuthResponse.fromJson(response.data);

      // Guardar el token y la información del usuario
      await StorageService.saveToken(authResponse.token);
      await StorageService.saveUserInfo(
        userId: authResponse.user.id,
        role: authResponse.user.rol,
      );

      return authResponse;
    } catch (e) {
      rethrow;
    }
  }

  /// Obtener información del usuario actual
  Future<UserData> getCurrentUser() async {
    try {
      final response = await _apiService.get(ApiConfig.me);
      return UserData.fromJson(response.data['user']);
    } catch (e) {
      rethrow;
    }
  }

  /// Cerrar sesión
  Future<void> logout() async {
    await StorageService.logout();
  }

  /// Verificar si el usuario está autenticado
  Future<bool> isAuthenticated() async {
    return await StorageService.isAuthenticated();
  }
}
