class Specialty {
  final int id;
  final String name;

  Specialty({
    required this.id,
    required this.name,
  });

  factory Specialty.fromJson(Map<String, dynamic> json) {
    return Specialty(
      id: json['id'] as int,
      name: json['name'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}

// Lista de especialidades médicas
class Specialties {
  static final List<Specialty> list = [
    Specialty(id: 1, name: 'Médico general'),
    Specialty(id: 2, name: 'Pediatra'),
    Specialty(id: 3, name: 'Psicólogo'),
    Specialty(id: 4, name: 'Psiquiatra'),
    Specialty(id: 5, name: 'Nutricionista'),
    Specialty(id: 6, name: 'Fisioterapeuta'),
    Specialty(id: 7, name: 'Ortopedista'),
    Specialty(id: 8, name: 'Enfermera superior'),
    Specialty(id: 9, name: 'Auxiliar de enfermería'),
    Specialty(id: 10, name: 'Veterinario'),
    Specialty(id: 11, name: 'Ambulancia'),
    Specialty(id: 12, name: 'Otro'),
  ];
}
