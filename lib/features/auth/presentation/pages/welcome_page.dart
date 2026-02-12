import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
                            // Logo
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // Logo de SaludGo
                    Image.asset(
                      'assets/images/logo.png',
                      height: 120,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        // Si no encuentra el logo, muestra el icono placeholder
                        return const Icon(
                          Icons.local_hospital,
                          size: 80,
                          color: AppColors.primary,
                        );
                      },
                    ),
                  ],
                ),
              ),
                            // Botón Regístrate
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    context.push('/register-selection');
                  },
                  child: const Text(
                    'Regístrate',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
              
              const SizedBox(height: 16),
              
              // Botón Inicia sesión
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () {
                    context.push('/login');
                  },
                  child: const Text(
                    'Inicia sesión',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),

              

              
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
