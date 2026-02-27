import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../data/repositories/doctor_profile_repository.dart';
import '../../domain/models/doctor_stats.dart';

// Provider del repositorio
final doctorProfileRepositoryProvider = Provider<DoctorProfileRepository>((ref) {
  return DoctorProfileRepository();
});

// Estado del perfil del doctor
class DoctorProfileState {
  final DoctorStats? stats;
  final bool isLoading;
  final String? error;

  DoctorProfileState({
    this.stats,
    this.isLoading = false,
    this.error,
  });

  DoctorProfileState copyWith({
    DoctorStats? stats,
    bool? isLoading,
    String? error,
  }) {
    return DoctorProfileState(
      stats: stats ?? this.stats,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

// Notifier del perfil del doctor
class DoctorProfileNotifier extends StateNotifier<DoctorProfileState> {
  final DoctorProfileRepository _repository;
  final Ref _ref;

  DoctorProfileNotifier(this._repository, this._ref)
      : super(DoctorProfileState());

  /// Cargar estadísticas del doctor
  Future<void> loadStats() async {
    final user = _ref.read(authProvider).user;
    if (user == null) return;

    state = state.copyWith(isLoading: true, error: null);

    try {
      final response = await _repository.getDoctorStats(user.id);
      
      final stats = DoctorStats(
        consultasAtendidas: response['consultas_atendidas'] ?? 0,
        consultasHoy: response['consultas_hoy'] ?? 0,
        saldoDisponible: (response['saldo_disponible'] ?? 0.0).toDouble(),
        bonificaciones: response['bonificaciones'] ?? 0,
        calificacionPromedio: (response['calificacion_promedio'] ?? 5.0).toDouble(),
        totalCalificaciones: response['total_calificaciones'] ?? 0,
      );

      state = state.copyWith(stats: stats, isLoading: false);
    } catch (e) {
      state = state.copyWith(
        error: e.toString(),
        isLoading: false,
      );
    }
  }

  /// Actualizar nombre y/o email del doctor
  Future<bool> updateProfile({
    String? nombre,
    String? email,
    String? ciudad,
  }) async {
    final user = _ref.read(authProvider).user;
    if (user == null) return false;

    state = state.copyWith(isLoading: true, error: null);

    try {
      await _repository.updateDoctorProfile(
        userId: user.id,
        nombre: nombre,
        email: email,
        ciudad: ciudad,
      );

      // Actualizar el usuario en el auth provider
      if (nombre != null || email != null || ciudad != null) {
        _ref.read(authProvider.notifier).updateUserInfo(
          nombre: nombre,
          email: email,
          ciudad: ciudad,
        );
      }

      state = state.copyWith(isLoading: false);
      return true;
    } catch (e) {
      state = state.copyWith(
        error: e.toString(),
        isLoading: false,
      );
      return false;
    }
  }

  /// Actualizar foto de perfil
  Future<bool> updateProfilePhoto(String photoPath) async {
    final user = _ref.read(authProvider).user;
    if (user == null) return false;

    state = state.copyWith(isLoading: true, error: null);

    try {
      final response = await _repository.updateProfilePhoto(
        userId: user.id,
        photoPath: photoPath,
      );

      // El backend retorna:
      // - foto_perfil: ruta relativa (ej: "uploads/profiles/img_abc.jpg")
      // - foto_url: URL completa (ej: "http://localhost:8000/uploads/...")
      
      // Guardar la ruta relativa en el usuario (como está en la BD)
      String? fotoPerfilPath = response['foto_perfil'] as String?;
      
      // Si viene con prefijo, usarlo; si no, construir la URL base
      if (fotoPerfilPath != null) {
        // Si ya viene con http, usar tal cual; si no, es ruta relativa
        if (!fotoPerfilPath.startsWith('http')) {
          // Construir URL completa para mostrar
          final baseUrl = 'http://10.0.2.2:8080/saludgoft/saludgo-backend/public';
          fotoPerfilPath = '$baseUrl/$fotoPerfilPath';
        }
        _ref.read(authProvider.notifier).updateUserPhoto(fotoPerfilPath);
      }

      state = state.copyWith(isLoading: false);
      return true;
    } catch (e) {
      print('Error en updateProfilePhoto: $e');
      state = state.copyWith(
        error: e.toString(),
        isLoading: false,
      );
      return false;
    }
  }
}

// Provider del estado del perfil
final doctorProfileProvider =
    StateNotifierProvider<DoctorProfileNotifier, DoctorProfileState>((ref) {
  final repository = ref.watch(doctorProfileRepositoryProvider);
  return DoctorProfileNotifier(repository, ref);
});
