import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../providers/doctor_availability_provider.dart';

class DoctorHomePage extends ConsumerStatefulWidget {
  const DoctorHomePage({super.key});

  @override
  ConsumerState<DoctorHomePage> createState() => _DoctorHomePageState();
}

class _DoctorHomePageState extends ConsumerState<DoctorHomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final user = authState.user;
    final availabilityState = ref.watch(doctorAvailabilityProvider);

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.white),
          onPressed: () {
            _scaffoldKey.currentState?.openDrawer();
          },
        ),
        title: const Text(
          'SaludGo Doctor',
          style: TextStyle(color: Colors.white),
        ),
      ),
      drawer: _buildDrawer(context, user),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Mensaje de solicitudes
              Text(
                'Hay ${availabilityState.pendingRequests} solicitudes de consulta, activa tu disponibilidad para verlas',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 18,
                  color: AppColors.primary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              
              const SizedBox(height: 32),
              
              // Toggle de disponibilidad
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  color: availabilityState.isAvailable 
                      ? AppColors.success.withOpacity(0.2) 
                      : AppColors.textSecondary.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      availabilityState.isAvailable ? 'Disponible' : 'No disponible',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: availabilityState.isAvailable 
                            ? AppColors.success 
                            : AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Switch(
                      value: availabilityState.isAvailable,
                      onChanged: (value) {
                        ref.read(doctorAvailabilityProvider.notifier).toggleAvailability();
                      },
                      activeColor: AppColors.success,
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 40),
              
              // Botón para ver solicitudes (solo si está disponible)
              if (availabilityState.isAvailable)
                ElevatedButton(
                  onPressed: () {
                    // TODO: Navegar a solicitudes
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Función: Ver solicitudes (próximamente)'),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Ver Solicitudes',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDrawer(BuildContext context, user) {
    return Drawer(
      child: Container(
        color: AppColors.primary,
        child: Column(
          children: [
            // Header con foto y datos del doctor
            Container(
              padding: const EdgeInsets.only(top: 60, bottom: 20),
              child: Column(
                children: [
                  const CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.person,
                      size: 50,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    user?.nombre?.toUpperCase() ?? 'DOCTOR',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ...List.generate(4, (index) => const Icon(
                        Icons.star,
                        color: Colors.white,
                        size: 20,
                      )),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    user?.email ?? '',
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            
            // Opciones del menú
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: ListView(
                  padding: const EdgeInsets.only(top: 20),
                  children: [
                    _buildMenuItem(
                      icon: Icons.person,
                      title: 'MI PERFIL',
                      onTap: () {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Función: Mi Perfil (próximamente)')),
                        );
                      },
                    ),
                    _buildMenuItem(
                      icon: Icons.location_on,
                      title: 'CIUDAD',
                      onTap: () {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Función: Ciudad (próximamente)')),
                        );
                      },
                    ),
                    _buildMenuItem(
                      icon: Icons.payment,
                      title: 'RECARGA',
                      onTap: () {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Función: Recarga (próximamente)')),
                        );
                      },
                    ),
                    _buildMenuItem(
                      icon: Icons.history,
                      title: 'CONSULTAS REALIZADAS',
                      onTap: () {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Función: Consultas realizadas (próximamente)')),
                        );
                      },
                    ),
                    _buildMenuItem(
                      icon: Icons.search,
                      title: 'SABER MÁS SOBRE SALUDGO',
                      onTap: () {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Función: Saber más (próximamente)')),
                        );
                      },
                    ),
                    _buildMenuItem(
                      icon: Icons.security,
                      title: 'SEGURIDAD',
                      onTap: () {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Función: Seguridad (próximamente)')),
                        );
                      },
                    ),
                    _buildMenuItem(
                      icon: Icons.help,
                      title: 'NECESITO AYUDA',
                      onTap: () {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Función: Ayuda (próximamente)')),
                        );
                      },
                    ),
                    const Divider(height: 1),
                    _buildMenuItem(
                      icon: Icons.logout,
                      title: 'CERRAR SESIÓN',
                      textColor: Colors.red,
                      onTap: () async {
                        Navigator.pop(context);
                        await ref.read(authProvider.notifier).logout();
                        if (context.mounted) {
                          context.go('/');
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color? textColor,
  }) {
    return ListTile(
      leading: Icon(icon, color: textColor ?? AppColors.primary),
      title: Text(
        title,
        style: TextStyle(
          color: textColor ?? AppColors.textPrimary,
          fontWeight: FontWeight.w600,
          fontSize: 14,
        ),
      ),
      onTap: onTap,
    );
  }
}
