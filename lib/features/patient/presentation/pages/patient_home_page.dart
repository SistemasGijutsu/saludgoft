import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/background_scaffold.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

class PatientHomePage extends ConsumerWidget {
  const PatientHomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final user = authState.user;

    return BackgroundScaffold(
      appBar: AppBar(
        title: const Text('SaludGo - Paciente'),
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
                      backgroundColor: AppColors.primary,
                      child: Icon(Icons.person, size: 35, color: Colors.white),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '¡Hola, ${user?.nombre ?? "Usuario"}!',
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
              '¿Qué necesitas?',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Botón: Nueva solicitud
            _MenuCard(
              icon: Icons.add_circle,
              title: 'Nueva Solicitud',
              subtitle: 'Solicita atención médica ahora',
              color: AppColors.primary,
              onTap: () {
                // TODO: Navegar a crear solicitud
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Función: Nueva solicitud (próximamente)'),
                  ),
                );
              },
            ),
            
            const SizedBox(height: 12),
            
            // Botón: Mis solicitudes
            _MenuCard(
              icon: Icons.list_alt,
              title: 'Mis Solicitudes',
              subtitle: 'Ver mis solicitudes activas',
              color: AppColors.secondary,
              onTap: () {
                // TODO: Navegar a mis solicitudes
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Función: Mis solicitudes (próximamente)'),
                  ),
                );
              },
            ),
            
            const SizedBox(height: 12),
            
            // Botón: Historial
            _MenuCard(
              icon: Icons.history,
              title: 'Historial',
              subtitle: 'Ver servicios anteriores',
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
            
            // Botón: Mi perfil
            _MenuCard(
              icon: Icons.person,
              title: 'Mi Perfil',
              subtitle: 'Ver y editar mi información',
              color: AppColors.warning,
              onTap: () {
                // TODO: Navegar a perfil
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Función: Mi perfil (próximamente)'),
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
