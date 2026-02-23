import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../auth/domain/models/specialty.dart';

/// Estado del registro de médico
class DoctorRegistrationState {
  // Información personal y profesional
  final String? nombre;
  final String? email;
  final String? password;
  final String? dni;
  final int? edad;
  final String? genero;
  final String? telefono;
  final String? ciudad;
  final String? medioTransporte;
  final File? fotoPerfil;
  
  // Especialidad
  final Specialty? especialidad;
  
  // Documentos
  final File? documentoIdentidad;
  final File? tarjetaProfesional;
  final File? selfieConTarjeta;
  final File? registroProfesional;
  final File? actaGrado;
  final File? tituloEspecialidad;
  
  // Estado de carga
  final bool isLoading;
  final String? error;

  DoctorRegistrationState({
    this.nombre,
    this.email,
    this.password,
    this.dni,
    this.edad,
    this.genero,
    this.telefono,
    this.ciudad,
    this.medioTransporte,
    this.fotoPerfil,
    this.especialidad,
    this.documentoIdentidad,
    this.tarjetaProfesional,
    this.selfieConTarjeta,
    this.registroProfesional,
    this.actaGrado,
    this.tituloEspecialidad,
    this.isLoading = false,
    this.error,
  });

  DoctorRegistrationState copyWith({
    String? nombre,
    String? email,
    String? password,
    String? dni,
    int? edad,
    String? genero,
    String? telefono,
    String? ciudad,
    String? medioTransporte,
    File? fotoPerfil,
    Specialty? especialidad,
    File? documentoIdentidad,
    File? tarjetaProfesional,
    File? selfieConTarjeta,
    File? registroProfesional,
    File? actaGrado,
    File? tituloEspecialidad,
    bool? isLoading,
    String? error,
  }) {
    return DoctorRegistrationState(
      nombre: nombre ?? this.nombre,
      email: email ?? this.email,
      password: password ?? this.password,
      dni: dni ?? this.dni,
      edad: edad ?? this.edad,
      genero: genero ?? this.genero,
      telefono: telefono ?? this.telefono,
      ciudad: ciudad ?? this.ciudad,
      medioTransporte: medioTransporte ?? this.medioTransporte,
      fotoPerfil: fotoPerfil ?? this.fotoPerfil,
      especialidad: especialidad ?? this.especialidad,
      documentoIdentidad: documentoIdentidad ?? this.documentoIdentidad,
      tarjetaProfesional: tarjetaProfesional ?? this.tarjetaProfesional,
      selfieConTarjeta: selfieConTarjeta ?? this.selfieConTarjeta,
      registroProfesional: registroProfesional ?? this.registroProfesional,
      actaGrado: actaGrado ?? this.actaGrado,
      tituloEspecialidad: tituloEspecialidad ?? this.tituloEspecialidad,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }

  bool get hasAllDocuments =>
      documentoIdentidad != null &&
      tarjetaProfesional != null &&
      selfieConTarjeta != null &&
      registroProfesional != null &&
      actaGrado != null &&
      tituloEspecialidad != null;
}

/// Notifier para el registro de médico
class DoctorRegistrationNotifier extends StateNotifier<DoctorRegistrationState> {
  DoctorRegistrationNotifier() : super(DoctorRegistrationState());

  void setSpecialty(Specialty specialty) {
    state = state.copyWith(especialidad: specialty);
  }

  void setPersonalInfo({
    required String nombre,
    required String email,
    required String password,
    required String dni,
    required int edad,
    required String genero,
    required String telefono,
    required String ciudad,
    required String medioTransporte,
    File? fotoPerfil,
  }) {
    state = state.copyWith(
      nombre: nombre,
      email: email,
      password: password,
      dni: dni,
      edad: edad,
      genero: genero,
      telefono: telefono,
      ciudad: ciudad,
      medioTransporte: medioTransporte,
      fotoPerfil: fotoPerfil,
    );
  }

  void setDocument(String documentType, File file) {
    switch (documentType) {
      case 'identity':
        state = state.copyWith(documentoIdentidad: file);
        break;
      case 'license':
        state = state.copyWith(tarjetaProfesional: file);
        break;
      case 'selfie':
        state = state.copyWith(selfieConTarjeta: file);
        break;
      case 'register':
        state = state.copyWith(registroProfesional: file);
        break;
      case 'degree':
        state = state.copyWith(actaGrado: file);
        break;
      case 'specialty':
        state = state.copyWith(tituloEspecialidad: file);
        break;
    }
  }

  void setLoading(bool loading) {
    state = state.copyWith(isLoading: loading);
  }

  void setError(String? error) {
    state = state.copyWith(error: error, isLoading: false);
  }

  void reset() {
    state = DoctorRegistrationState();
  }
}

/// Provider del registro de médico
final doctorRegistrationProvider =
    StateNotifierProvider<DoctorRegistrationNotifier, DoctorRegistrationState>(
        (ref) => DoctorRegistrationNotifier());
