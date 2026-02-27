class DoctorStats {
  final int consultasAtendidas;
  final int consultasHoy;
  final double saldoDisponible;
  final int bonificaciones;
  final double calificacionPromedio;
  final int totalCalificaciones;

  DoctorStats({
    this.consultasAtendidas = 0,
    this.consultasHoy = 0,
    this.saldoDisponible = 0.0,
    this.bonificaciones = 0,
    this.calificacionPromedio = 5.0,
    this.totalCalificaciones = 0,
  });

  factory DoctorStats.fromJson(Map<String, dynamic> json) {
    return DoctorStats(
      consultasAtendidas: json['consultas_atendidas'] ?? 0,
      consultasHoy: json['consultas_hoy'] ?? 0,
      saldoDisponible: (json['saldo_disponible'] ?? 0.0).toDouble(),
      bonificaciones: json['bonificaciones'] ?? 0,
      calificacionPromedio: (json['calificacion_promedio'] ?? 5.0).toDouble(),
      totalCalificaciones: json['total_calificaciones'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'consultas_atendidas': consultasAtendidas,
      'consultas_hoy': consultasHoy,
      'saldo_disponible': saldoDisponible,
      'bonificaciones': bonificaciones,
      'calificacion_promedio': calificacionPromedio,
      'total_calificaciones': totalCalificaciones,
    };
  }
}
