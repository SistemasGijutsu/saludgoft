import 'package:json_annotation/json_annotation.dart';

part 'auth_models.g.dart';

/// Modelo para la petición de registro de paciente
@JsonSerializable()
class PatientRegisterRequest {
  final String nombre;
  final String email;
  final String password;
  final String? telefono;
  @JsonKey(name: 'fecha_nacimiento')
  final String? fechaNacimiento; // Formato: YYYY-MM-DD
  final int? edad;
  final String? genero; // 'masculino', 'femenino', 'otro'
  final String? ciudad;
  final String? direccion;
  
  // Datos médicos opcionales
  @JsonKey(name: 'contacto_emergencia_nombre')
  final String? contactoEmergenciaNombre;
  @JsonKey(name: 'contacto_emergencia_telefono')
  final String? contactoEmergenciaTelefono;
  @JsonKey(name: 'tipo_sangre')
  final String? tipoSangre;
  final String? alergias;
  @JsonKey(name: 'condiciones_cronicas')
  final String? condicionesCronicas;
  @JsonKey(name: 'notas_medicas')
  final String? notasMedicas;

  PatientRegisterRequest({
    required this.nombre,
    required this.email,
    required this.password,
    this.telefono,
    this.fechaNacimiento,
    this.edad,
    this.genero,
    this.ciudad,
    this.direccion,
    this.contactoEmergenciaNombre,
    this.contactoEmergenciaTelefono,
    this.tipoSangre,
    this.alergias,
    this.condicionesCronicas,
    this.notasMedicas,
  });

  factory PatientRegisterRequest.fromJson(Map<String, dynamic> json) =>
      _$PatientRegisterRequestFromJson(json);

  Map<String, dynamic> toJson() => _$PatientRegisterRequestToJson(this);
}

/// Modelo para la respuesta de login/registro
@JsonSerializable()
class AuthResponse {
  final String message;
  final String token;
  final UserData user;

  AuthResponse({
    required this.message,
    required this.token,
    required this.user,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) =>
      _$AuthResponseFromJson(json);

  Map<String, dynamic> toJson() => _$AuthResponseToJson(this);
}

/// Modelo de datos del usuario
@JsonSerializable()
class UserData {
  final int id;
  final String nombre;
  final String email;
  final String rol;
  final String? telefono;
  @JsonKey(name: 'fecha_nacimiento')
  final String? fechaNacimiento;
  final int? edad;
  final String? genero;
  final String? ciudad;
  final String? direccion;
  @JsonKey(name: 'foto_perfil')
  final String? fotoPerfil;
  @JsonKey(name: 'estado_cuenta')
  final String? estadoCuenta;
  final int? activo;
  @JsonKey(name: 'fecha_registro')
  final String? fechaRegistro;

  UserData({
    required this.id,
    required this.nombre,
    required this.email,
    required this.rol,
    this.telefono,
    this.fechaNacimiento,
    this.edad,
    this.genero,
    this.ciudad,
    this.direccion,
    this.fotoPerfil,
    this.estadoCuenta,
    this.activo,
    this.fechaRegistro,
  });

  factory UserData.fromJson(Map<String, dynamic> json) =>
      _$UserDataFromJson(json);

  Map<String, dynamic> toJson() => _$UserDataToJson(this);
  
  // Métodos helper para verificar el rol
  bool get isPatient => rol == 'paciente';
  bool get isDoctor => rol == 'profesional';
}

/// Modelo para la petición de login
@JsonSerializable()
class LoginRequest {
  final String email;
  final String password;

  LoginRequest({
    required this.email,
    required this.password,
  });

  factory LoginRequest.fromJson(Map<String, dynamic> json) =>
      _$LoginRequestFromJson(json);

  Map<String, dynamic> toJson() => _$LoginRequestToJson(this);
}

/// Modelo para la petición de registro de médico/profesional
@JsonSerializable()
class DoctorRegisterRequest {
  final String nombre;
  final String email;
  final String password;
  @JsonKey(name: 'especialidad_id')
  final int especialidadId;
  final String cedula;
  @JsonKey(name: 'tarjeta_profesional')
  final String tarjetaProfesional;
  @JsonKey(name: 'medio_transporte')
  final String medioTransporte;
  @JsonKey(name: 'anos_experiencia')
  final int anosExperiencia;
  @JsonKey(name: 'tarifa_consulta')
  final double tarifaConsulta;
  final String? descripcion;
  final String? telefono;
  final String? ciudad;
  final String? genero;
  final int? edad;

  DoctorRegisterRequest({
    required this.nombre,
    required this.email,
    required this.password,
    required this.especialidadId,
    required this.cedula,
    required this.tarjetaProfesional,
    required this.medioTransporte,
    required this.anosExperiencia,
    required this.tarifaConsulta,
    this.descripcion,
    this.telefono,
    this.ciudad,
    this.genero,
    this.edad,
  });

  factory DoctorRegisterRequest.fromJson(Map<String, dynamic> json) =>
      _$DoctorRegisterRequestFromJson(json);

  Map<String, dynamic> toJson() => _$DoctorRegisterRequestToJson(this);
}
