import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Estado de disponibilidad del doctor
class DoctorAvailabilityState {
  final bool isAvailable;
  final int pendingRequests;

  DoctorAvailabilityState({
    required this.isAvailable,
    required this.pendingRequests,
  });

  DoctorAvailabilityState copyWith({
    bool? isAvailable,
    int? pendingRequests,
  }) {
    return DoctorAvailabilityState(
      isAvailable: isAvailable ?? this.isAvailable,
      pendingRequests: pendingRequests ?? this.pendingRequests,
    );
  }
}

/// Provider para manejar la disponibilidad del doctor
class DoctorAvailabilityNotifier extends StateNotifier<DoctorAvailabilityState> {
  DoctorAvailabilityNotifier()
      : super(DoctorAvailabilityState(
          isAvailable: false,
          pendingRequests: 12, // TODO: Obtener del backend
        ));

  /// Cambiar estado de disponibilidad
  void toggleAvailability() {
    state = state.copyWith(isAvailable: !state.isAvailable);
    // TODO: Enviar al backend el cambio de disponibilidad
  }

  /// Actualizar cantidad de solicitudes pendientes
  void updatePendingRequests(int count) {
    state = state.copyWith(pendingRequests: count);
  }
}

/// Provider global para disponibilidad del doctor
final doctorAvailabilityProvider =
    StateNotifierProvider<DoctorAvailabilityNotifier, DoctorAvailabilityState>(
  (ref) => DoctorAvailabilityNotifier(),
);
