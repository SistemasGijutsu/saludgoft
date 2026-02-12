import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';

class DoctorRegisterDocumentsPage extends StatefulWidget {
  const DoctorRegisterDocumentsPage({super.key});

  @override
  State<DoctorRegisterDocumentsPage> createState() => _DoctorRegisterDocumentsPageState();
}

class _DoctorRegisterDocumentsPageState extends State<DoctorRegisterDocumentsPage> {
  final Map<String, bool> _uploadedDocuments = {
    'identity': false,
    'license': false,
    'selfie': false,
    'register': false,
    'degree': false,
    'specialty': false,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE8EEF2),
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
                onPressed: _allDocumentsUploaded()
                    ? () {
                        // TODO: Enviar documentos al backend
                        _showSuccessDialog();
                      }
                    : null,
                child: const Text(
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
    final isUploaded = _uploadedDocuments[key] ?? false;
    
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
            onPressed: () {
              // TODO: Abrir selector de archivo o cámara
              setState(() {
                _uploadedDocuments[key] = true;
              });
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
    return _uploadedDocuments.values.every((uploaded) => uploaded);
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('¡Registro Exitoso!'),
        content: const Text(
          'Tu registro como médico ha sido enviado. '
          'Revisaremos tus documentos y te notificaremos cuando tu cuenta sea aprobada.',
        ),
        actions: [
          TextButton(
            onPressed: () {
              context.go('/');
            },
            child: const Text('Entendido'),
          ),
        ],
      ),
    );
  }
}
