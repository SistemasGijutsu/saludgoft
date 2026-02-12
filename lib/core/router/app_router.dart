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

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authProvider);

  return GoRouter(
    initialLocation: '/',
    redirect: (context, state) {
      final isAuthenticated = authState.isAuthenticated;
      final isAuthRoute = state.matchedLocation == '/' ||
          state.matchedLocation == '/login' ||
          state.matchedLocation == '/register-selection' ||
          state.matchedLocation.startsWith('/register');

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
});
