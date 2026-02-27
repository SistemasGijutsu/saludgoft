import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../providers/doctor_availability_provider.dart';
import 'doctor_profile_page.dart';
import 'doctor_city_page.dart';

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
      drawer: _buildDrawer(context, user),
      body: Stack(
        children: [
          // Fondo con patrón de iconos médicos
          const _MedicalIconsBackground(),

          // Contenido principal
          SafeArea(
            child: Column(
              children: [
                // ── Barra superior: hamburguesa + toggle disponibilidad ──
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Row(
                    children: [
                      // Botón hamburguesa circular
                      GestureDetector(
                        onTap: () =>
                            _scaffoldKey.currentState?.openDrawer(),
                        child: Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.primary.withOpacity(0.3),
                                blurRadius: 8,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.menu,
                            color: Colors.white,
                            size: 22,
                          ),
                        ),
                      ),

                      const Spacer(),

                      // Toggle disponibilidad (píldora animada)
                      GestureDetector(
                        onTap: () => ref
                            .read(doctorAvailabilityProvider.notifier)
                            .toggleAvailability(),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 9),
                          decoration: BoxDecoration(
                            color: availabilityState.isAvailable
                                ? AppColors.success
                                : const Color(0xFF9E9E9E),
                            borderRadius: BorderRadius.circular(22),
                            boxShadow: [
                              BoxShadow(
                                color: (availabilityState.isAvailable
                                        ? AppColors.success
                                        : Colors.grey)
                                    .withOpacity(0.35),
                                blurRadius: 6,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 8,
                                height: 8,
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                availabilityState.isAvailable
                                    ? 'Disponible'
                                    : 'No disponible',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 0.3,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // ── Mensaje central ──
                Expanded(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 36),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Hay ${availabilityState.pendingRequests} solicitudes de consulta, activa tu disponibilidad para verlas',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 22,
                              color: AppColors.primary,
                              fontWeight: FontWeight.w600,
                              height: 1.45,
                            ),
                          ),

                          if (availabilityState.isAvailable) ...[
                            const SizedBox(height: 40),
                            ElevatedButton(
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                        'Ver solicitudes (próximamente)'),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 44, vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                elevation: 4,
                              ),
                              child: const Text(
                                'Ver Solicitudes',
                                style: TextStyle(
                                    fontSize: 16, color: Colors.white),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ─── Drawer estilo InDriver ─────────────────────────────────────────────

  Widget _buildDrawer(BuildContext context, dynamic user) {
    return Drawer(
      width: MediaQuery.of(context).size.width * 0.82,
      child: Container(
        color: AppColors.primary,
        child: Column(
          children: [
            // ── Header del doctor ──
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(
                  top: 56, bottom: 24, left: 20, right: 20),
              child: Column(
                children: [
                  // Avatar circular con borde blanco
                  Container(
                    width: 88,
                    height: 88,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 3),
                    ),
                    child: const CircleAvatar(
                      backgroundColor: Colors.white,
                      child: Icon(
                        Icons.person,
                        size: 54,
                        color: AppColors.primary,
                      ),
                    ),
                  ),

                  const SizedBox(height: 14),

                  // Nombre + ícono verificado
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Flexible(
                        child: Text(
                          (user?.nombre?.toUpperCase() ?? 'DOCTOR'),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.8,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 6),
                      const Icon(Icons.verified,
                          color: Colors.white, size: 18),
                    ],
                  ),

                  const SizedBox(height: 5),

                  // Consultas atendidas
                  Text(
                    '${ref.watch(doctorAvailabilityProvider).pendingRequests} Consultas atendidas',
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 13,
                    ),
                  ),

                  const SizedBox(height: 10),

                  // Estrellas
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      5,
                      (i) => Icon(
                        i < 4 ? Icons.star : Icons.star_half,
                        color: Colors.white,
                        size: 22,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ── Panel blanco con opciones de menú ──
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(28),
                    topRight: Radius.circular(28),
                  ),
                ),
                child: ListView(
                  padding:
                      const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
                  children: [
                    _menuItem(
                      icon: Icons.person_outline,
                      title: 'MI PERFIL',
                      onTap: () => _onMenuTap(context, 'Mi Perfil'),
                    ),
                    _menuItem(
                      icon: Icons.location_on_outlined,
                      title: 'CIUDAD',
                      onTap: () => _onMenuTap(context, 'Ciudad'),
                    ),
                    _menuItem(
                      icon: Icons.credit_card_outlined,
                      title: 'RECARGA',
                      onTap: () => _onMenuTap(context, 'Recarga'),
                    ),
                    _menuItem(
                      icon: Icons.history,
                      title: 'CONSULTAS REALIZADAS',
                      onTap: () =>
                          _onMenuTap(context, 'Consultas realizadas'),
                    ),
                    _menuItem(
                      icon: Icons.search,
                      title: 'SABER MÁS SOBRE SALUDGO',
                      onTap: () => _onMenuTap(context, 'Saber más'),
                    ),
                    _menuItem(
                      icon: Icons.shield_outlined,
                      title: 'SEGURIDAD',
                      onTap: () => _onMenuTap(context, 'Seguridad'),
                    ),
                    _menuItem(
                      icon: Icons.settings_outlined,
                      title: 'CONFIGURACIÓN',
                      onTap: () => _onMenuTap(context, 'Configuración'),
                    ),
                    _menuItem(
                      icon: Icons.warning_amber_outlined,
                      title: 'NECESITO AYUDA',
                      onTap: () => _onMenuTap(context, 'Necesito ayuda'),
                    ),
                    const Divider(
                        height: 24, indent: 16, endIndent: 16),
                    _menuItem(
                      icon: Icons.logout,
                      title: 'CERRAR SESIÓN',
                      textColor: Colors.red,
                      onTap: () async {
                        Navigator.pop(context);
                        await ref.read(authProvider.notifier).logout();
                        if (context.mounted) context.go('/');
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

  void _onMenuTap(BuildContext context, String name) {
    Navigator.pop(context);
    
    // Navegación según la opción seleccionada
    switch (name) {
      case 'Mi Perfil':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const DoctorProfilePage(),
          ),
        );
        break;
      case 'Ciudad':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const DoctorCityPage(),
          ),
        );
        break;
      default:
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('$name (próximamente)')),
        );
    }
  }

  Widget _menuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color? textColor,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
          padding:
              const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
          decoration: BoxDecoration(
            border:
                Border.all(color: const Color(0xFFE0EAF4), width: 1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              Icon(
                icon,
                color: textColor ?? AppColors.primary,
                size: 22,
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    color: textColor ?? AppColors.primary,
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Fondo con patrón de iconos médicos ────────────────────────────────────

class _MedicalIconsBackground extends StatelessWidget {
  const _MedicalIconsBackground();

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: CustomPaint(
        painter: _MedicalPatternPainter(),
      ),
    );
  }
}

class _MedicalPatternPainter extends CustomPainter {
  static const List<_IconEntry> _icons = [
    _IconEntry(Icons.local_hospital, 0.08, 0.07),
    _IconEntry(Icons.favorite_border, 0.38, 0.04),
    _IconEntry(Icons.medical_services_outlined, 0.70, 0.10),
    _IconEntry(Icons.monitor_heart_outlined, 0.90, 0.06),
    _IconEntry(Icons.healing, 0.15, 0.22),
    _IconEntry(Icons.vaccines_outlined, 0.62, 0.18),
    _IconEntry(Icons.medication_outlined, 0.84, 0.26),
    _IconEntry(Icons.biotech_outlined, 0.04, 0.38),
    _IconEntry(Icons.psychology_outlined, 0.46, 0.33),
    _IconEntry(Icons.medical_information_outlined, 0.76, 0.43),
    _IconEntry(Icons.science_outlined, 0.22, 0.52),
    _IconEntry(Icons.health_and_safety_outlined, 0.93, 0.56),
    _IconEntry(Icons.local_pharmacy_outlined, 0.10, 0.66),
    _IconEntry(Icons.bloodtype_outlined, 0.52, 0.61),
    _IconEntry(Icons.emergency_outlined, 0.80, 0.69),
    _IconEntry(Icons.coronavirus_outlined, 0.30, 0.76),
    _IconEntry(Icons.monitor_outlined, 0.66, 0.81),
    _IconEntry(Icons.air_outlined, 0.05, 0.86),
    _IconEntry(Icons.sanitizer_outlined, 0.43, 0.89),
    _IconEntry(Icons.thermostat, 0.89, 0.89),
    _IconEntry(Icons.local_hospital, 0.56, 0.96),
    _IconEntry(Icons.favorite_border, 0.20, 0.96),
  ];

  @override
  void paint(Canvas canvas, Size size) {
    for (final entry in _icons) {
      final x = entry.relX * size.width;
      final y = entry.relY * size.height;
      final tp = TextPainter(textDirection: TextDirection.ltr)
        ..text = TextSpan(
          text: String.fromCharCode(entry.icon.codePoint),
          style: TextStyle(
            fontSize: 38,
            fontFamily: entry.icon.fontFamily,
            package: entry.icon.fontPackage,
            color: AppColors.primary.withOpacity(0.08),
          ),
        )
        ..layout();
      tp.paint(canvas, Offset(x - tp.width / 2, y - tp.height / 2));
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _IconEntry {
  final IconData icon;
  final double relX;
  final double relY;

  const _IconEntry(this.icon, this.relX, this.relY);
}
