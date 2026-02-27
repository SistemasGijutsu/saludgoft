class ApiConstants {
  // Cambia esto por la IP de tu PC cuando pruebes en celular real
  static const String baseUrlEmulator = 'http://10.0.2.2:8080/saludgoft/saludgo-backend/public/api';
  static const String baseUrlIOS = 'http://localhost:8080/saludgoft/saludgo-backend/public/api';
  
  // Ejemplo: static const String baseUrlReal = 'http://192.168.1.100:8080/saludgoft/saludgo-backend/public/api';
  static const String baseUrlReal = 'http://TU_IP_AQUI:8080/saludgoft/saludgo-backend/public/api';

  // Endpoints
  static const String login = '/login';
  static const String register = '/register/patient';
  static const String registerDoctor = '/register/doctor';
  static const String logout = '/logout';
  
  // Patient endpoints
  static const String serviceRequests = '/service-requests';
  static const String patientOffers = '/patient/offers';
  
  // Doctor endpoints
  static const String doctorRequests = '/doctor/service-requests';
  static const String doctorOffers = '/doctor/offers';
  
  // Common endpoints
  static const String specialties = '/specialties';
  static const String profile = '/me';
  
  // User/Profile endpoints
  static const String updateProfilePhoto = '/usuarios'; // usuarios/{id} con PUT
  static const String updateProfile = '/usuarios'; // usuarios/{id} con PUT
}
