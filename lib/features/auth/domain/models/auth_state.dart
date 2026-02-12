import '../models/user.dart';

class AuthState {
  final User? user;
  final String? token;
  final bool isLoading;
  final String? error;
  final bool isAuthenticated;

  AuthState({
    this.user,
    this.token,
    this.isLoading = false,
    this.error,
    this.isAuthenticated = false,
  });

  AuthState copyWith({
    User? user,
    String? token,
    bool? isLoading,
    String? error,
    bool? isAuthenticated,
  }) {
    return AuthState(
      user: user ?? this.user,
      token: token ?? this.token,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
    );
  }

  // Estado inicial
  factory AuthState.initial() {
    return AuthState();
  }

  // Estado de carga
  factory AuthState.loading() {
    return AuthState(isLoading: true);
  }

  // Estado autenticado
  factory AuthState.authenticated(User user, String token) {
    return AuthState(
      user: user,
      token: token,
      isAuthenticated: true,
    );
  }

  // Estado con error
  factory AuthState.error(String message) {
    return AuthState(error: message);
  }
}
