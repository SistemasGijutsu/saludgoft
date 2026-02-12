import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

class DoctorHomePage extends ConsumerWidget {
  const DoctorHomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final user = authState.user;

    return Scaffold(
      appBar: AppBar(
        title: const Text('SaludGo - Médico'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await ref.read(authProvider.notifier).logout();
              if (context.mounted) {
                context.go('/');
              }
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Saludo personalizado
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    const CircleAvatar(
                      radius: 30,
                      backgroundColor: AppColors.secondary,
                      child: Icon(Icons.medical_services, size: 35, color: Colors.white),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Dr. ${user?.name ?? "Usuario"}',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            user?.email ?? '',
                            style: const TextStyle(
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 24),
            
            const Text(
              'Panel de Control',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Botón: Solicitudes disponibles
            _MenuCard(
              icon: Icons.assignment,
              title: 'Solicitudes Disponibles',
              subtitle: 'Ver solicitudes de pacientes',
              color: AppColors.primary,
              onTap: () {
                // TODO: Navegar a solicitudes disponibles
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Función: Solicitudes disponibles (próximamente)'),
                  ),
                );
              },
            ),
            
            const SizedBox(height: 12),
            
            // Botón: Mis ofertas
            _MenuCard(
              icon: Icons.local_offer,
              title: 'Mis Ofertas',
              subtitle: 'Ver ofertas que he enviado',
              color: AppColors.secondary,
              onTap: () {
                // TODO: Navegar a mis ofertas
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Función: Mis ofertas (próximamente)'),
                  ),
                );
              },
            ),
            
            const SizedBox(height: 12),
            
            // Botón: Servicios activos
            _MenuCard(
              icon: Icons.timeline,
              title: 'Servicios Activos',
              subtitle: 'Servicios en curso',
              color: AppColors.success,
              onTap: () {
                // TODO: Navegar a servicios activos
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Función: Servicios activos (próximamente)'),
                  ),
                );
              },
            ),
            
            const SizedBox(height: 12),
            
            // Botón: Historial
            _MenuCard(
              icon: Icons.history,
              title: 'Historial',
              subtitle: 'Ver servicios completados',
              color: AppColors.info,
              onTap: () {
                // TODO: Navegar a historial
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Función: Historial (próximamente)'),
                  ),
                );
              },
            ),
            
            const SizedBox(height: 12),
            
            // Botón: Mi perfil profesional
            _MenuCard(
              icon: Icons.badge,
              title: 'Mi Perfil Profesional',
              subtitle: 'Especialidades y certificaciones',
              color: AppColors.warning,
              onTap: () {
                // TODO: Navegar a perfil profesional
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Función: Perfil profesional (próximamente)'),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _MenuCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  const _MenuCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 30),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_ios, color: color, size: 20),
            ],
          ),
        ),
      ),
    );
  }
}
