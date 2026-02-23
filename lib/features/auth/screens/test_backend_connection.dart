import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

/// Pantalla de prueba simple para verificar la conexión con el backend
/// No requiere modelos generados
class TestBackendConnection extends StatefulWidget {
  const TestBackendConnection({super.key});

  @override
  State<TestBackendConnection> createState() => _TestBackendConnectionState();
}

class _TestBackendConnectionState extends State<TestBackendConnection> {
  String _status = 'Esperando...';
  bool _isLoading = false;
  
  // Cambia esta URL según tu caso:
  // - Para web/iOS simulator: http://localhost:8080/saludgoft/saludgo-backend/public/api
  // - Para Android emulator: http://10.0.2.2:8080/saludgoft/saludgo-backend/public/api
  // - Para dispositivo físico: http://TU_IP_LOCAL:8080/saludgoft/saludgo-backend/public/api
  final String baseUrl = 'http://10.0.2.2:8080/saludgoft/saludgo-backend/public/api';

  Future<void> _testConnection() async {
    setState(() {
      _isLoading = true;
      _status = 'Probando conexión...';
    });

    try {
      final dio = Dio();
      
      // Probar endpoint público (especialidades)
      final response = await dio.get('$baseUrl/specialties');
      
      setState(() {
        _status = '✅ Conexión exitosa!\n\n'
            'Status: ${response.statusCode}\n'
            'Datos: ${response.data}';
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _status = '❌ Error de conexión:\n\n$e\n\n'
            'Verifica:\n'
            '1. XAMPP esté corriendo\n'
            '2. La URL sea correcta\n'
            '3. Si usas emulador Android, usa 10.0.2.2';
        _isLoading = false;
      });
    }
  }

  Future<void> _testRegister() async {
    setState(() {
      _isLoading = true;
      _status = 'Registrando usuario de prueba...';
    });

    try {
      final dio = Dio();
      
      // Enviar petición de registro
      final response = await dio.post(
        '$baseUrl/register/patient',
        data: {
          'nombre': 'Usuario Prueba',
          'email': 'prueba${DateTime.now().millisecondsSinceEpoch}@test.com',
          'password': '123456',
          'telefono': '3001234567',
          'ciudad': 'Bogotá',
        },
      );
      
      setState(() {
        _status = '✅ Registro exitoso!\n\n'
            'Status: ${response.statusCode}\n'
            'Token: ${response.data['token']?.substring(0, 20)}...\n'
            'Usuario: ${response.data['user']['nombre']}';
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _status = '❌ Error al registrar:\n\n$e';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Test de Conexión Backend'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'URL del Backend:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      baseUrl,
                      style: const TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            
            ElevatedButton.icon(
              onPressed: _isLoading ? null : _testConnection,
              icon: const Icon(Icons.wifi),
              label: const Text('Probar Conexión (GET /specialties)'),
            ),
            const SizedBox(height: 8),
            
            ElevatedButton.icon(
              onPressed: _isLoading ? null : _testRegister,
              icon: const Icon(Icons.person_add),
              label: const Text('Probar Registro (POST /register/patient)'),
            ),
            const SizedBox(height: 24),
            
            Expanded(
              child: Card(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: _isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : Text(_status),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
