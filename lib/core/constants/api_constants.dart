class ApiConstants {
  // Cambia esto por la IP de tu PC cuando pruebes en celular real
  static const String baseUrlEmulator = 'http://10.0.2.2:8000/api';
  static const String baseUrlIOS = 'http://localhost:8000/api';
  
  // Ejemplo: static const String baseUrlReal = 'http://192.168.1.100:8000/api';
  static const String baseUrlReal = 'http://TU_IP_AQUI:8000/api';

  // Endpoints
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String logout = '/auth/logout';
  
  // Patient endpoints
  static const String serviceRequests = '/service-requests';
  static const String patientOffers = '/patient/offers';
  
  // Doctor endpoints
  static const String doctorRequests = '/doctor/service-requests';
  static const String doctorOffers = '/doctor/offers';
  
  // Common endpoints
  static const String specialties = '/specialties';
  static const String profile = '/profile';
}
