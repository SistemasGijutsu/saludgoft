import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../auth/domain/models/specialty.dart';

class DoctorSpecialtySelectionPage extends StatefulWidget {
  const DoctorSpecialtySelectionPage({super.key});

  @override
  State<DoctorSpecialtySelectionPage> createState() => _DoctorSpecialtySelectionPageState();
}

class _DoctorSpecialtySelectionPageState extends State<DoctorSpecialtySelectionPage> {
  Specialty? _selectedSpecialty;
  bool _showList = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        title: const Text('Registrarse'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 40),
            
            // Tarjeta de beneficios
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Obtén ingresos con nosotros',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildBenefit(Icons.access_time, 'Horarios flexibles'),
                  const SizedBox(height: 12),
                  _buildBenefit(Icons.attach_money, 'Tus precios'),
                  const SizedBox(height: 12),
                  _buildBenefit(Icons.payment, 'Pagos bajos por servicio'),
                ],
              ),
            ),
            
            const SizedBox(height: 32),
            
            // Selector de especialidad
            const Text(
              'Profesional en salud en',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Botón para mostrar/ocultar lista
            InkWell(
              onTap: () {
                setState(() {
                  _showList = !_showList;
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _selectedSpecialty?.name ?? 'Médico general',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                    Icon(
                      _showList ? Icons.keyboard_arrow_up : Icons.edit,
                      color: Colors.white,
                    ),
                  ],
                ),
              ),
            ),
            
            // Lista desplegable de especialidades
            if (_showList) ...[
              const SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  children: Specialties.list.map((specialty) {
                    return ListTile(
                      title: Text(specialty.name),
                      tileColor: _selectedSpecialty?.id == specialty.id
                          ? AppColors.primary.withOpacity(0.2)
                          : null,
                      onTap: () {
                        setState(() {
                          _selectedSpecialty = specialty;
                          _showList = false;
                        });
                      },
                    );
                  }).toList(),
                ),
              ),
            ],
            
            const SizedBox(height: 40),
            
            // Botón siguiente
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Navegar al formulario de información profesional
                  context.push(
                    '/doctor/register-info',
                    extra: _selectedSpecialty ?? Specialties.list[0],
                  );
                },
                child: const Text(
                  'Siguiente',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Botón ir al modo paciente
            TextButton(
              onPressed: () {
                context.go('/register?role=patient');
              },
              child: const Text(
                'Ir al modo paciente',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBenefit(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, color: Colors.white, size: 20),
        const SizedBox(width: 12),
        Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
        ),
      ],
    );
  }
}
