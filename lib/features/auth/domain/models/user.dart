class User {
  final int id;
  final String name;
  final String email;
  final String role; // 'patient' or 'doctor'
  final String? phone;
  final String? avatar;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    this.phone,
    this.avatar,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as int,
      name: json['nombre'] as String, // Backend usa 'nombre'
      email: json['email'] as String,
      role: json['rol'] as String, // Backend usa 'rol'
      phone: json['telefono'] as String?, // Backend usa 'telefono'
      avatar: json['foto_perfil'] as String?, // Backend usa 'foto_perfil'
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'role': role,
      'phone': phone,
      'avatar': avatar,
    };
  }

  bool get isPatient => role == 'paciente';
  bool get isDoctor => role == 'profesional';
}
