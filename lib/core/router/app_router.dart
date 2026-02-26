import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/auth/presentation/providers/auth_provider.dart';
import '../../features/auth/presentation/pages/welcome_page.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/register_selection_page.dart';
import '../../features/auth/presentation/pages/register_page.dart';
import '../../features/patient/presentation/pages/patient_home_page.dart';
import '../../features/doctor/presentation/pages/doctor_home_page.dart';
import '../../features/doctor/presentation/pages/doctor_specialty_selection_page.dart';
import '../../features/doctor/presentation/pages/doctor_register_info_page.dart';
import '../../features/doctor/presentation/pages/doctor_register_documents_page.dart';
import '../../features/auth/domain/models/specialty.dart';
import '../../features/auth/screens/test_backend_connection.dart';

final routerProvider = Provider<GoRouter>((ref) {
  // El GoRouter se crea UNA sola vez. No usar ref.watch aquí porque
  // recrearía el router completo en cada cambio de auth (causa pantalla negra).
  final router = GoRouter(
    initialLocation: '/',
    redirect: (context, state) {
      // ref.read no produce rebuilds del router
      final authState = ref.read(authProvider);
      final isAuthenticated = authState.isAuthenticated;
      final location = state.matchedLocation;
      
      // Rutas públicas de autenticación y registro
      final isAuthRoute = location == '/' ||
          location == '/login' ||
          location == '/register-selection' ||
          location.startsWith('/register') ||
          location == '/doctor/select-specialty' ||
          location == '/doctor/register-info' ||
          location == '/doctor/register-documents' ||
          location == '/test';

      // Si está autenticado y trata de ir a rutas de auth, redirigir a su home
      if (isAuthenticated && isAuthRoute) {
        if (authState.user?.isPatient == true) {
          return '/patient/home';
        } else if (authState.user?.isDoctor == true) {
          return '/doctor/home';
        }
      }

      // Si no está autenticado y trata de ir a rutas protegidas, redirigir a welcome
      if (!isAuthenticated && !isAuthRoute) {
        return '/';
      }

      return null; // No redirigir
    },
    routes: [
      // Ruta de prueba de backend
      GoRoute(
        path: '/test',
        builder: (context, state) => const TestBackendConnection(),
      ),
      
      // Ruta de bienvenida
      GoRoute(
        path: '/',
        builder: (context, state) => const WelcomePage(),
      ),
      
      // Ruta de login
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginPage(),
      ),
      
      // Ruta de selección de tipo de registro
      GoRoute(
        path: '/register-selection',
        builder: (context, state) => const RegisterSelectionPage(),
      ),
      
      // Ruta de registro
      GoRoute(
        path: '/register',
        builder: (context, state) {
          final role = state.uri.queryParameters['role'] ?? 'patient';
          return RegisterPage(role: role);
        },
      ),
      
      // Ruta de selección de especialidad (médico)
      GoRoute(
        path: '/doctor/select-specialty',
        builder: (context, state) => const DoctorSpecialtySelectionPage(),
      ),
      
      // Ruta de información profesional (médico)
      GoRoute(
        path: '/doctor/register-info',
        builder: (context, state) {
          final specialty = state.extra as Specialty;
          return DoctorRegisterInfoPage(specialty: specialty);
        },
      ),
      
      // Ruta de documentos (médico)
      GoRoute(
        path: '/doctor/register-documents',
        builder: (context, state) => const DoctorRegisterDocumentsPage(),
      ),
      
      // Rutas de paciente
      GoRoute(
        path: '/patient/home',
        builder: (context, state) => const PatientHomePage(),
      ),
      
      // Rutas de médico
      GoRoute(
        path: '/doctor/home',
        builder: (context, state) => const DoctorHomePage(),
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 80, color: Colors.red),
            const SizedBox(height: 16),
            const Text(
              'Página no encontrada',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => context.go('/'),
              child: const Text('Volver al inicio'),
            ),
          ],
        ),
      ),
    ),
  );

  // Escuchar cambios de auth para refrescar SOLO el redirect, sin recrear el router
  ref.listen(authProvider, (previous, next) {
    if (previous?.isAuthenticated != next.isAuthenticated) {
      router.refresh();
    }
  });

  return router;
});
