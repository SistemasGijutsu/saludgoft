// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PatientRegisterRequest _$PatientRegisterRequestFromJson(
        Map<String, dynamic> json) =>
    PatientRegisterRequest(
      nombre: json['nombre'] as String,
      email: json['email'] as String,
      password: json['password'] as String,
      telefono: json['telefono'] as String?,
      fechaNacimiento: json['fecha_nacimiento'] as String?,
      edad: (json['edad'] as num?)?.toInt(),
      genero: json['genero'] as String?,
      ciudad: json['ciudad'] as String?,
      direccion: json['direccion'] as String?,
      contactoEmergenciaNombre: json['contacto_emergencia_nombre'] as String?,
      contactoEmergenciaTelefono:
          json['contacto_emergencia_telefono'] as String?,
      tipoSangre: json['tipo_sangre'] as String?,
      alergias: json['alergias'] as String?,
      condicionesCronicas: json['condiciones_cronicas'] as String?,
      notasMedicas: json['notas_medicas'] as String?,
    );

Map<String, dynamic> _$PatientRegisterRequestToJson(
        PatientRegisterRequest instance) =>
    <String, dynamic>{
      'nombre': instance.nombre,
      'email': instance.email,
      'password': instance.password,
      'telefono': instance.telefono,
      'fecha_nacimiento': instance.fechaNacimiento,
      'edad': instance.edad,
      'genero': instance.genero,
      'ciudad': instance.ciudad,
      'direccion': instance.direccion,
      'contacto_emergencia_nombre': instance.contactoEmergenciaNombre,
      'contacto_emergencia_telefono': instance.contactoEmergenciaTelefono,
      'tipo_sangre': instance.tipoSangre,
      'alergias': instance.alergias,
      'condiciones_cronicas': instance.condicionesCronicas,
      'notas_medicas': instance.notasMedicas,
    };

AuthResponse _$AuthResponseFromJson(Map<String, dynamic> json) => AuthResponse(
      message: json['message'] as String,
      token: json['token'] as String,
      user: UserData.fromJson(json['user'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$AuthResponseToJson(AuthResponse instance) =>
    <String, dynamic>{
      'message': instance.message,
      'token': instance.token,
      'user': instance.user,
    };

UserData _$UserDataFromJson(Map<String, dynamic> json) => UserData(
      id: (json['id'] as num).toInt(),
      nombre: json['nombre'] as String,
      email: json['email'] as String,
      rol: json['rol'] as String,
      telefono: json['telefono'] as String?,
      fechaNacimiento: json['fecha_nacimiento'] as String?,
      edad: (json['edad'] as num?)?.toInt(),
      genero: json['genero'] as String?,
      ciudad: json['ciudad'] as String?,
      direccion: json['direccion'] as String?,
      fotoPerfil: json['foto_perfil'] as String?,
      estadoCuenta: json['estado_cuenta'] as String?,
      activo: (json['activo'] as num?)?.toInt(),
      fechaRegistro: json['fecha_registro'] as String?,
    );

Map<String, dynamic> _$UserDataToJson(UserData instance) => <String, dynamic>{
      'id': instance.id,
      'nombre': instance.nombre,
      'email': instance.email,
      'rol': instance.rol,
      'telefono': instance.telefono,
      'fecha_nacimiento': instance.fechaNacimiento,
      'edad': instance.edad,
      'genero': instance.genero,
      'ciudad': instance.ciudad,
      'direccion': instance.direccion,
      'foto_perfil': instance.fotoPerfil,
      'estado_cuenta': instance.estadoCuenta,
      'activo': instance.activo,
      'fecha_registro': instance.fechaRegistro,
    };

LoginRequest _$LoginRequestFromJson(Map<String, dynamic> json) => LoginRequest(
      email: json['email'] as String,
      password: json['password'] as String,
    );

Map<String, dynamic> _$LoginRequestToJson(LoginRequest instance) =>
    <String, dynamic>{
      'email': instance.email,
      'password': instance.password,
    };

DoctorRegisterRequest _$DoctorRegisterRequestFromJson(
        Map<String, dynamic> json) =>
    DoctorRegisterRequest(
      nombre: json['nombre'] as String,
      email: json['email'] as String,
      password: json['password'] as String,
      especialidadId: (json['especialidad_id'] as num).toInt(),
      cedula: json['cedula'] as String,
      tarjetaProfesional: json['tarjeta_profesional'] as String?,
      medioTransporte: json['medio_transporte'] as String,
      anosExperiencia: (json['anos_experiencia'] as num).toInt(),
      tarifaConsulta: (json['tarifa_consulta'] as num).toDouble(),
      descripcion: json['descripcion'] as String?,
      telefono: json['telefono'] as String?,
      ciudad: json['ciudad'] as String?,
      genero: json['genero'] as String?,
      edad: (json['edad'] as num?)?.toInt(),
    );

Map<String, dynamic> _$DoctorRegisterRequestToJson(
        DoctorRegisterRequest instance) =>
    <String, dynamic>{
      'nombre': instance.nombre,
      'email': instance.email,
      'password': instance.password,
      'especialidad_id': instance.especialidadId,
      'cedula': instance.cedula,
      'tarjeta_profesional': instance.tarjetaProfesional,
      'medio_transporte': instance.medioTransporte,
      'anos_experiencia': instance.anosExperiencia,
      'tarifa_consulta': instance.tarifaConsulta,
      'descripcion': instance.descripcion,
      'telefono': instance.telefono,
      'ciudad': instance.ciudad,
      'genero': instance.genero,
      'edad': instance.edad,
    };
