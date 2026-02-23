import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/background_scaffold.dart';
import '../../../../core/utils/image_picker_helper.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../auth/models/auth_models.dart';
import '../providers/doctor_registration_provider.dart';

class DoctorRegisterDocumentsPage extends ConsumerStatefulWidget {
  const DoctorRegisterDocumentsPage({super.key});

  @override
  ConsumerState<DoctorRegisterDocumentsPage> createState() => _DoctorRegisterDocumentsPageState();
}

class _DoctorRegisterDocumentsPageState extends ConsumerState<DoctorRegisterDocumentsPage> {
  final Map<String, File?> _uploadedDocuments = {
    'identity': null,
    'license': null,
    'selfie': null,
    'register': null,
    'degree': null,
    'specialty': null,
  };

  bool _isSubmitting = false;

  @override
  Widget build(BuildContext context) {
    return BackgroundScaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => context.pop(),
        ),
        title: const Text('Documentos'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Documentos personales',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            
            const SizedBox(height: 32),
            
            // Documento de identidad
            _buildDocumentCard(
              'identity',
              'Documento de identidad',
              Icons.badge,
            ),
            
            const SizedBox(height: 16),
            
            // Tarjeta profesional
            _buildDocumentCard(
              'license',
              'Tarjeta profesional -\nLicencia médica',
              Icons.credit_card,
            ),
            
            const SizedBox(height: 16),
            
            // Selfie
            _buildDocumentCard(
              'selfie',
              'Selfie con tarjeta\nprofesional',
              Icons.camera_alt,
            ),
            
            const SizedBox(height: 16),
            
            // Registro profesional
            _buildDocumentCard(
              'register',
              'Registro profesional',
              Icons.assignment,
            ),
            
            const SizedBox(height: 16),
            
            // Acta de grado
            _buildDocumentCard(
              'degree',
              'Acta de grado',
              Icons.school,
            ),
            
            const SizedBox(height: 16),
            
            // Título de especialidad
            _buildDocumentCard(
              'specialty',
              'Título de especialidad',
              Icons.workspace_premium,
            ),
            
            const SizedBox(height: 32),
            
            // Botón enviar documentos
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: (_allDocumentsUploaded() && !_isSubmitting)
                    ? _submitRegistration
                    : null,
                child: _isSubmitting
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : const Text(
                        'Enviar Documentos',
                        style: TextStyle(fontSize: 18),
                      ),
              ),
            ),
            
            const SizedBox(height: 16),
            
            if (!_allDocumentsUploaded())
              const Center(
                child: Text(
                  'Debes subir todos los documentos para continuar',
                  style: TextStyle(
                    color: AppColors.error,
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildDocumentCard(String key, String title, IconData icon) {
    final documentFile = _uploadedDocuments[key];
    final isUploaded = documentFile != null;
    
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isUploaded ? AppColors.success : Colors.grey.shade300,
          width: 2,
        ),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isUploaded 
                  ? AppColors.success.withOpacity(0.1)
                  : AppColors.primary.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              isUploaded ? Icons.check_circle : icon,
              size: 40,
              color: isUploaded ? AppColors.success : AppColors.primary,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          ElevatedButton.icon(
            onPressed: () async {
              final file = await ImagePickerHelper.showImageSourceDialog(context);
              if (file != null) {
                setState(() {
                  _uploadedDocuments[key] = file;
                });
                // Guardar en el provider
                ref.read(doctorRegistrationProvider.notifier).setDocument(key, file);
              }
            },
            icon: Icon(isUploaded ? Icons.edit : Icons.upload_file),
            label: Text(isUploaded ? 'Cambiar' : 'Subir'),
            style: ElevatedButton.styleFrom(
              backgroundColor: isUploaded ? AppColors.secondary : AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }

  bool _allDocumentsUploaded() {
    return _uploadedDocuments.values.every((file) => file != null);
  }

  Future<void> _submitRegistration() async {
    setState(() {
      _isSubmitting = true;
    });

    try {
      final registrationData = ref.read(doctorRegistrationProvider);

      // Validar que tenemos todos los datos necesarios
      if (registrationData.especialidad == null ||
          registrationData.nombre == null ||
          registrationData.email == null ||
          registrationData.password == null ||
          registrationData.dni == null) {
        throw Exception('Faltan datos requeridos. Por favor completa toda la información.');
      }

      // Crear el request para el backend
      final request = DoctorRegisterRequest(
        nombre: registrationData.nombre!,
        email: registrationData.email!,
        password: registrationData.password!,
        especialidadId: registrationData.especialidad!.id,
        cedula: registrationData.dni!,
        tarjetaProfesional: registrationData.dni!, // Por ahora usamos el mismo DNI
        medioTransporte: registrationData.medioTransporte?.toLowerCase() ?? 'motocicleta',
        anosExperiencia: 1, // Valor por defecto
        tarifaConsulta: 50000, // Valor por defecto
        telefono: registrationData.telefono,
        genero: registrationData.genero,
        edad: registrationData.edad,
        descripcion: 'Profesional de la salud registrado',
      );

      // Llamar al backend directamente sin autenticar
      final authRepo = ref.read(authRepositoryProvider);
      await authRepo.registerDoctor(request);

      // Limpiar el provider
      ref.read(doctorRegistrationProvider.notifier).reset();

      setState(() {
        _isSubmitting = false;
      });

      // Mostrar diálogo de éxito
      if (mounted) {
        _showSuccessDialog();
      }
    } catch (e) {
      setState(() {
        _isSubmitting = false;
      });

      if (mounted) {
        // Mostrar el error en un dialog en lugar de un SnackBar
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Row(
              children: [
                Icon(Icons.error, color: Colors.red),
                SizedBox(width: 8),
                Text('Error al registrar'),
              ],
            ),
            content: Text(e.toString().replaceAll('Exception: ', '')),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Entendido'),
              ),
            ],
          ),
        );
      }
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        icon: const Icon(Icons.check_circle, color: Colors.green, size: 60),
        title: const Text('¡Registro Exitoso!'),
        content: const Text(
          'Tu registro como médico ha sido completado exitosamente.\n\n'
          'Tu cuenta está pendiente de verificación. Te notificaremos cuando sea aprobada.\n\n'
          'Puedes iniciar sesión en cualquier momento.',
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context); // Cerrar diálogo
              context.go('/login'); // Ir al login
            },
            child: const Text('Ir a Iniciar Sesión'),
          ),
        ],
      ),
    );
  }
}
