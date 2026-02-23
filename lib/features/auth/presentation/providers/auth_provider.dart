import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/repositories/auth_repository.dart';
import '../../domain/models/auth_state.dart';
import '../../models/auth_models.dart';

// Provider del repositorio
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository();
});

// Provider del estado de autenticación
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(ref.read(authRepositoryProvider));
});

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthRepository _repository;

  AuthNotifier(this._repository) : super(AuthState.initial()) {
    _checkAuthStatus();
  }

  // Verificar si hay una sesión guardada
  Future<void> _checkAuthStatus() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      if (token != null) {
        state = AuthState.loading();
        final user = await _repository.verifyToken(token);
        state = AuthState.authenticated(user, token);
      }
    } catch (e) {
      // Si el token no es válido, limpiar la sesión
      await _clearSession();
      state = AuthState.initial();
    }
  }

  // Login
  Future<void> login(String email, String password) async {
    try {
      state = AuthState.loading();

      final result = await _repository.login(
        email: email,
        password: password,
      );

      // Guardar token en SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', result['token']);
      
      state = AuthState.authenticated(result['user'], result['token']);
    } catch (e) {
      state = AuthState.error(e.toString().replaceAll('Exception: ', ''));
    }
  }

  // Register
  Future<void> register({
    required String name,
    required String email,
    required String password,
    required String passwordConfirmation,
    required String role,
    String? phone,
  }) async {
    try {
      state = AuthState.loading();

      final result = await _repository.register(
        name: name,
        email: email,
        password: password,
        passwordConfirmation: passwordConfirmation,
        role: role,
        phone: phone,
      );

      // Guardar token en SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', result['token']);

      state = AuthState.authenticated(result['user'], result['token']);
    } catch (e) {
      state = AuthState.error(e.toString().replaceAll('Exception: ', ''));
    }
  }

  // Register Doctor
  Future<void> registerDoctor(DoctorRegisterRequest request) async {
    try {
      state = AuthState.loading();

      final result = await _repository.registerDoctor(request);

      // Guardar token en SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', result['token']);

      state = AuthState.authenticated(result['user'], result['token']);
    } catch (e) {
      state = AuthState.error(e.toString().replaceAll('Exception: ', ''));
      rethrow;
    }
  }

  // Logout
  Future<void> logout() async {
    try {
      if (state.token != null) {
        await _repository.logout(state.token!);
      }
      await _clearSession();
      state = AuthState.initial();
    } catch (e) {
      // Limpiar sesión de todas formas
      await _clearSession();
      state = AuthState.initial();
    }
  }

  // Limpiar sesión
  Future<void> _clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
  }

  // Limpiar error
  void clearError() {
    if (state.error != null) {
      state = state.copyWith(error: null);
    }
  }
}
