/// Configuración de la API del backend
class ApiConfig {
  // URL base de tu backend PHP
  // Configurado para emulador de Android Studio (10.0.2.2 = localhost de tu PC)
  // Puerto 8080 para Apache XAMPP
  static const String baseUrl = 'http://10.0.2.2:8080/saludgoft/saludgo-backend/public/api';
  
  // Para web o iOS simulator
  static const String baseUrlWeb = 'http://localhost:8080/saludgoft/saludgo-backend/public/api';
  
  // Para dispositivo físico (reemplaza con tu IP local)
  static const String baseUrlPhysicalDevice = 'http://192.168.1.X:8080/saludgoft/saludgo-backend/public/api';
  
  // Timeouts
  static const int connectTimeout = 30000; // 30 segundos
  static const int receiveTimeout = 30000; // 30 segundos
  
  // Endpoints
  static const String register = '/register/patient';
  static const String registerDoctor = '/register/doctor';
  static const String login = '/login';
  static const String me = '/me';
  static const String specialties = '/specialties';
  static const String serviceRequests = '/service-requests';
  static const String myServiceRequests = '/service-requests/my';
}
