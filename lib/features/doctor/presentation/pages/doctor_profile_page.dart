import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/image_picker_helper.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../providers/doctor_profile_provider.dart';

class DoctorProfilePage extends ConsumerStatefulWidget {
  const DoctorProfilePage({super.key});

  @override
  ConsumerState<DoctorProfilePage> createState() => _DoctorProfilePageState();
}

class _DoctorProfilePageState extends ConsumerState<DoctorProfilePage> {
  @override
  void initState() {
    super.initState();
    // Cargar estadísticas al iniciar
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(doctorProfileProvider.notifier).loadStats();
    });
  }

  // Niveles del sistema de gamificación
  final List<Map<String, dynamic>> _levels = [
    {
      'name': 'Bronce I',
      'icon': Icons.shield,
      'color': const Color(0xFFCD7F32),
      'minConsultas': 0,
      'maxConsultas': 99,
      'nextLevel': 'Bronce II',
      'nextConsultas': 100,
    },
    {
      'name': 'Bronce II',
      'icon': Icons.shield,
      'color': const Color(0xFFCD7F32),
      'minConsultas': 100,
      'maxConsultas': 199,
      'nextLevel': 'Plata I',
      'nextConsultas': 200,
    },
    {
      'name': 'Plata I',
      'icon': Icons.workspace_premium,
      'color': const Color(0xFFC0C0C0),
      'minConsultas': 200,
      'maxConsultas': 399,
      'nextLevel': 'Plata II',
      'nextConsultas': 400,
    },
    {
      'name': 'Plata II',
      'icon': Icons.workspace_premium,
      'color': const Color(0xFFC0C0C0),
      'minConsultas': 400,
      'maxConsultas': 599,
      'nextLevel': 'Oro I',
      'nextConsultas': 600,
    },
    {
      'name': 'Oro I',
      'icon': Icons.stars,
      'color': const Color(0xFFFFD700),
      'minConsultas': 600,
      'maxConsultas': 999,
      'nextLevel': 'Oro II',
      'nextConsultas': 1000,
    },
    {
      'name': 'Oro II',
      'icon': Icons.stars,
      'color': const Color(0xFFFFD700),
      'minConsultas': 1000,
      'maxConsultas': 1999,
      'nextLevel': 'Diamante',
      'nextConsultas': 2000,
    },
    {
      'name': 'Diamante',
      'icon': Icons.diamond,
      'color': const Color(0xFFB9F2FF),
      'minConsultas': 2000,
      'maxConsultas': 999999,
      'nextLevel': null,
      'nextConsultas': null,
    },
  ];

  // Obtener el nivel actual basado en las consultas atendidas
  Map<String, dynamic> _getCurrentLevel(int consultasAtendidas) {
    for (var level in _levels) {
      if (consultasAtendidas >= level['minConsultas'] &&
          consultasAtendidas <= level['maxConsultas']) {
        return level;
      }
    }
    return _levels[0]; // Por defecto Bronce I
  }

  void _showLevelInfo(Map<String, dynamic> level, int consultasAtendidas) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Botón de cerrar
              Align(
                alignment: Alignment.topLeft,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              const SizedBox(height: 16),
              // Título "Nivel"
              const Text(
                'Nivel',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 24),
              // Insignia del nivel con alas
              Stack(
                alignment: Alignment.center,
                children: [
                  // Alas (decorativas)
                  Icon(
                    Icons.airplanemode_active,
                    size: 120,
                    color: level['color'].withOpacity(0.3),
                  ),
                  // Escudo/Insignia
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: level['color'],
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 10,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: Icon(
                      level['icon'],
                      size: 60,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              // Nombre del nivel
              Text(
                level['name'],
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: level['color'],
                ),
              ),
              const SizedBox(height: 16),
              // Descripción de progreso
              if (level['nextLevel'] != null)
                Text(
                  'Realiza ${level['nextConsultas']} consultas\npara alcanzar ${level['nextLevel']}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                )
              else
                const Text(
                  '¡Has alcanzado el nivel máximo!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
              const SizedBox(height: 8),
              Text(
                'Consultas actuales: $consultasAtendidas',
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Mostrar diálogo de términos y condiciones
  void _showTermsAndConditions(BuildContext context, {String? fotoPerfil}) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Container(
          constraints: const BoxConstraints(maxHeight: 600),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header con foto de perfil (si existe)
              Container(
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                ),
                child: Column(
                  children: [
                    if (fotoPerfil != null && fotoPerfil.isNotEmpty) ...[
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                          border: Border.all(
                            color: Colors.white,
                            width: 3,
                          ),
                        ),
                        child: ClipOval(
                          child: Image.network(
                            fotoPerfil,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                const Icon(
                              Icons.person,
                              size: 40,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                    ],
                    Row(
                      children: [
                        const Expanded(
                          child: Text(
                            'Términos y Condiciones',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close, color: Colors.white),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Contenido
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _termsItem(
                        'El médico acepta que ejerce su profesión de manera independiente y por su propia cuenta y riesgo.',
                      ),
                      _termsItem(
                        'SaludGo es exclusivamente un portal de contacto. La plataforma no asume responsabilidad alguna por el acto médico, diagnósticos o tratamientos. El médico asume cualquier reclamación legal derivada de su ejercicio.',
                      ),
                      _termsItem(
                        'El pago de la recarga otorga el derecho de uso de la herramienta tecnológica, no constituye una relación laboral ni un seguro de cobertura.',
                      ),
                      _termsItem(
                        'El profesional debe verificar la identidad del paciente antes de brindar atención.',
                      ),
                      _termsItem(
                        'El profesional acepta las políticas de privacidad y manejo de datos personales de SaludGo.',
                      ),
                      _termsItem(
                        'SaludGo se reserva el derecho de suspender o cancelar cuentas que incumplan estos términos.',
                      ),
                      _termsItem(
                        'Al registrarse, el profesional certifica que cuenta con todas las certificaciones, licencias y seguros necesarios para ejercer su profesión.',
                      ),
                    ],
                  ),
                ),
              ),
              // Botón Entendido
              Padding(
                padding: const EdgeInsets.all(16),
                child: SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Entendido',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _termsItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '• ',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 14,
                height: 1.5,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Mostrar diálogo para editar nombre
  void _showEditNameDialog(BuildContext context) {
    final authState = ref.read(authProvider);
    final user = authState.user;
    if (user == null) return;

    final controller = TextEditingController(text: user.nombre);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Editar Nombre'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            labelText: 'Nombre completo',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () async {
              final newName = controller.text.trim();
              if (newName.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('El nombre no puede estar vacío')),
                );
                return;
              }

              Navigator.pop(context);

              final success = await ref
                  .read(doctorProfileProvider.notifier)
                  .updateProfile(nombre: newName);

              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      success
                          ? 'Nombre actualizado correctamente'
                          : 'Error al actualizar nombre',
                    ),
                  ),
                );
              }
            },
            child: const Text('Guardar'),
          ),
        ],
      ),
    );
  }

  // Mostrar diálogo para editar correo
  void _showEditEmailDialog(BuildContext context) {
    final authState = ref.read(authProvider);
    final user = authState.user;
    if (user == null) return;

    final controller = TextEditingController(text: user.email);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Editar Correo Electrónico'),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.emailAddress,
          decoration: const InputDecoration(
            labelText: 'Correo electrónico',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () async {
              final newEmail = controller.text.trim();
              if (newEmail.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('El correo no puede estar vacío'),
                  ),
                );
                return;
              }

              if (!newEmail.contains('@')) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Correo inválido')),
                );
                return;
              }

              Navigator.pop(context);

              final success = await ref
                  .read(doctorProfileProvider.notifier)
                  .updateProfile(email: newEmail);

              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      success
                          ? 'Correo actualizado correctamente'
                          : 'Error al actualizar correo',
                    ),
                  ),
                );
              }
            },
            child: const Text('Guardar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final profileState = ref.watch(doctorProfileProvider);
    final user = authState.user;

    if (user == null) {
      return const Scaffold(
        body: Center(
          child: Text('No hay datos del usuario'),
        ),
      );
    }

    // Usar estadísticas del provider o valores por defecto
    final stats = profileState.stats;
    final consultasAtendidas = stats?.consultasAtendidas ?? 0;
    final consultasHoy = stats?.consultasHoy ?? 0;
    final saldoDisponible = stats?.saldoDisponible ?? 0.0;
    final bonificaciones = stats?.bonificaciones ?? 0;
    final rating = stats?.calificacionPromedio ?? 5.0;

    final currentLevel = _getCurrentLevel(consultasAtendidas);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Header con foto y datos principales
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(24),
                    bottomRight: Radius.circular(24),
                  ),
                ),
                child: Column(
                  children: [
                    // Foto de perfil
                    Stack(
                      children: [
                        Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 10,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: user.fotoPerfil != null
                                ? Image.network(
                                    user.fotoPerfil!,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) =>
                                        const Icon(
                                      Icons.person,
                                      size: 60,
                                      color: AppColors.primary,
                                    ),
                                  )
                                : const Icon(
                                    Icons.person,
                                    size: 60,
                                    color: AppColors.primary,
                                  ),
                          ),
                        ),
                        // Botón para cambiar foto
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: GestureDetector(
                            onTap: () async {
                              final image = await ImagePickerHelper.showImageSourceDialog(context);
                              if (image != null) {
                                // Subir la foto
                                final success = await ref
                                    .read(doctorProfileProvider.notifier)
                                    .updateProfilePhoto(image.path);
                                
                                if (mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        success
                                            ? 'Foto actualizada correctamente'
                                            : 'Error al actualizar foto',
                                      ),
                                    ),
                                  );
                                }
                              }
                            },
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: AppColors.primary,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.2),
                                    blurRadius: 4,
                                    spreadRadius: 1,
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.camera_alt,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // Nombre y verificación
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          user.nombre.toUpperCase(),
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: 1,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Icon(
                          Icons.verified,
                          color: Colors.white,
                          size: 24,
                        ),
                        const SizedBox(width: 4),
                        // Botón para editar
                        IconButton(
                          icon: const Icon(
                            Icons.edit,
                            color: Colors.white,
                            size: 20,
                          ),
                          onPressed: () {
                            // Mostrar menú de opciones
                            showModalBottomSheet(
                              context: context,
                              builder: (context) => Container(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    ListTile(
                                      leading: const Icon(Icons.person),
                                      title: const Text('Editar nombre'),
                                      onTap: () {
                                        Navigator.pop(context);
                                        _showEditNameDialog(context);
                                      },
                                    ),
                                    ListTile(
                                      leading: const Icon(Icons.email),
                                      title: const Text('Editar correo'),
                                      onTap: () {
                                        Navigator.pop(context);
                                        _showEditEmailDialog(context);
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    // Consultas atendidas
                    Text(
                      '$consultasAtendidas consultas atendidas',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.white70,
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Especialidad
                    const Text(
                      'MÉDICO GENERAL',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Estrellas de calificación
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        5,
                        (index) => Icon(
                          index < rating.floor()
                              ? Icons.star
                              : Icons.star_border,
                          color: Colors.white,
                          size: 32,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              // Card de información
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFFE3F2FD),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Título
                    const Text(
                      'Consultas atendidas hoy',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '$consultasHoy',
                      style: const TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Saldo disponible
                    _infoRow(
                      icon: Icons.account_balance_wallet,
                      label: 'Saldo disponible',
                      value: '\$${saldoDisponible.toStringAsFixed(0)}',
                      actionLabel: 'Recargar',
                      actionColor: AppColors.primary,
                      onActionTap: () {
                        // TODO: Implementar recarga
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Función de recarga próximamente'),
                          ),
                        );
                      },
                    ),
                    const Divider(height: 32),
                    // Bonificaciones
                    _infoRow(
                      icon: Icons.card_giftcard,
                      label: 'Bonificaciones',
                      value: bonificaciones.toString(),
                      actionLabel: 'Obtener',
                      actionColor: Colors.green,
                      onActionTap: () {
                        // TODO: Implementar bonificaciones
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Función de bonificaciones próximamente'),
                          ),
                        );
                      },
                    ),
                    const Divider(height: 32),
                    // Nivel
                    _infoRow(
                      icon: currentLevel['icon'],
                      iconColor: currentLevel['color'],
                      label: 'Nivel',
                      value: currentLevel['name'],
                      actionLabel: 'Ver',
                      actionColor: AppColors.primary,
                      onActionTap: () {
                        _showLevelInfo(currentLevel, consultasAtendidas);
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              // Botón Términos y Condiciones
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: OutlinedButton(
                    onPressed: () => _showTermsAndConditions(
                      context,
                      fotoPerfil: user.fotoPerfil,
                    ),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.primary,
                      side: const BorderSide(color: AppColors.primary, width: 2),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'TÉRMINOS Y CONDICIONES',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Botón VOLVER
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 2,
                    ),
                    child: const Text(
                      'VOLVER',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _infoRow({
    required IconData icon,
    Color? iconColor,
    required String label,
    required String value,
    required String actionLabel,
    required Color actionColor,
    required VoidCallback onActionTap,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          color: iconColor ?? AppColors.primary,
          size: 28,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
        ElevatedButton(
          onPressed: onActionTap,
          style: ElevatedButton.styleFrom(
            backgroundColor: actionColor,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            elevation: 0,
          ),
          child: Text(
            actionLabel,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
