# 📋 Resumen de Integración Flutter-Backend

## ✅ Lo que se ha implementado

### Backend PHP (saludgo-backend) ✓
- ✅ Tabla `usuarios` correctamente configurada
- ✅ CORS habilitado para permitir peticiones desde Flutter
- ✅ Endpoints REST funcionando:
  - `POST /api/register/patient` - Registrar paciente
  - `POST /api/login` - Iniciar sesión
  - `GET /api/specialties` - Obtener especialidades
  - `GET /api/me` - Perfil del usuario (requiere token)
- ✅ Autenticación JWT implementada
- ✅ Código subido a GitHub

### Frontend Flutter (saludgo) ✓
- ✅ Servicio HTTP base con Dio (`api_service.dart`)
- ✅ Configuración de URLs del backend (`api_config.dart`)
- ✅ Servicio de almacenamiento local para tokens (`storage_service.dart`)
- ✅ Modelos de datos de autenticación (`auth_models.dart`)
- ✅ Servicio de autenticación (`auth_service.dart`)
- ✅ Pantalla de registro completa (`register_patient_screen.dart`)
- ✅ Pantalla de prueba simple (`test_backend_connection.dart`)
- ✅ Documentación completa

---

## 🔄 Cómo Funciona (Resumen)

```
┌─────────────────────────────────────────────────────────────┐
│  1. Usuario llena formulario en Flutter                    │
└─────────────────────────────────────────────────────────────┘
                          ↓
┌─────────────────────────────────────────────────────────────┐
│  2. Flutter envía datos JSON vía HTTP POST                 │
│     → http://localhost/.../api/register/patient            │
└─────────────────────────────────────────────────────────────┘
                          ↓
┌─────────────────────────────────────────────────────────────┐
│  3. Backend PHP recibe y valida datos                      │
│     → RegisterPatientDTO valida campos                     │
│     → RegisterPatientUseCase procesa                       │
└─────────────────────────────────────────────────────────────┘
                          ↓
┌─────────────────────────────────────────────────────────────┐
│  4. Backend guarda en MySQL                                │
│     → INSERT INTO usuarios (nombre, email, ...)            │
└─────────────────────────────────────────────────────────────┘
                          ↓
┌─────────────────────────────────────────────────────────────┐
│  5. Backend genera token JWT y responde                    │
│     → {token: "eyJ...", user: {...}}                       │
└─────────────────────────────────────────────────────────────┘
                          ↓
┌─────────────────────────────────────────────────────────────┐
│  6. Flutter guarda token localmente                        │
│     → StorageService.saveToken()                           │
└─────────────────────────────────────────────────────────────┘
                          ↓
┌─────────────────────────────────────────────────────────────┐
│  7. Flutter navega a pantalla principal                    │
│     ✅ Usuario registrado y autenticado                     │
└─────────────────────────────────────────────────────────────┘
```

---

## 🚀 Cómo Empezar a Usar

### 1. Verifica que el backend funciona
```bash
# En tu navegador:
http://localhost/saludgoft/saludgo-backend/public/api/specialties
```

### 2. Configura la URL en Flutter

Edita la URL según tu caso en `test_backend_connection.dart`:

```dart
// Para web/iOS: 
final String baseUrl = 'http://localhost/saludgoft/saludgo-backend/public/api';

// Para Android emulator:
final String baseUrl = 'http://10.0.2.2/saludgoft/saludgo-backend/public/api';

// Para dispositivo físico (usa tu IP):
final String baseUrl = 'http://192.168.1.X/saludgoft/saludgo-backend/public/api';
```

### 3. Prueba la conexión

Opción A - En tu app Flutter:
```dart
import 'features/auth/screens/test_backend_connection.dart';

// Navega a la pantalla:
Navigator.push(
  context,
  MaterialPageRoute(builder: (context) => TestBackendConnection()),
);
```

Opción B - Con Postman:
```
POST http://localhost/saludgoft/saludgo-backend/public/api/register/patient
Body (JSON):
{
  "nombre": "Test User",
  "email": "test@test.com",
  "password": "123456"
}
```

---

## 📂 Estructura de Archivos

```
📦 saludgoft/
├── 📂 saludgo-backend/    (Backend PHP)
│   ├── public/
│   │   └── index.php              # Punto de entrada, maneja CORS
│   ├── src/
│   │   ├── Infrastructure/
│   │   │   ├── routes.php         # Define rutas de API
│   │   │   ├── Controllers/
│   │   │   │   └── PatientController.php
│   │   │   └── Persistence/
│   │   │       └── UserRepository.php    # INSERT INTO usuarios
│   │   └── Application/
│   │       └── DTOs/
│   │           └── RegisterPatientDTO.php
│   └── config/
│       ├── app.php                # Configuración (CORS, JWT)
│       └── database.php           # Conexión MySQL
│
└── 📂 saludgo/            (Frontend Flutter)
    ├── lib/
    │   ├── core/
    │   │   ├── config/
    │   │   │   └── api_config.dart          # 🔧 URLs del backend
    │   │   └── services/
    │   │       ├── api_service.dart         # 🌐 Cliente HTTP (Dio)
    │   │       └── storage_service.dart     # 💾 Guardar token
    │   └── features/
    │       └── auth/
    │           ├── models/
    │           │   └── auth_models.dart     # 📦 Modelos de datos
    │           ├── services/
    │           │   └── auth_service.dart    # 🔐 Lógica de auth
    │           └── screens/
    │               ├── register_patient_screen.dart      # 📝 Formulario
    │               └── test_backend_connection.dart      # 🧪 Prueba
    │
    ├── INICIO_RAPIDO_BACKEND.md        # 📖 Guía rápida
    └── GUIA_CONEXION_BACKEND.md        # 📚 Guía completa
```

---

## 💡 Conceptos Clave

### 1. **API REST**
Tu backend PHP expone "endpoints" (URLs) que Flutter puede llamar:
- `GET` = Obtener datos
- `POST` = Crear/enviar datos
- `PUT` = Actualizar
- `DELETE` = Eliminar

### 2. **JSON**
Formato de intercambio de datos entre Flutter y PHP:
```json
{
  "nombre": "Juan",
  "email": "juan@test.com"
}
```

### 3. **JWT Token**
Un "pase de acceso" que identifica al usuario. Se guarda en el dispositivo y se envía automáticamente en cada petición protegida.

### 4. **CORS**
Permite que Flutter (en un puerto) se comunique con PHP (en otro puerto). Ya está configurado en tu backend.

---

## 🧪 Endpoints Disponibles

### Públicos (sin token)
| Método | Ruta | Descripción |
|--------|------|-------------|
| POST | `/api/register/patient` | Registrar paciente |
| POST | `/api/register/doctor` | Registrar médico |
| POST | `/api/login` | Iniciar sesión |
| GET | `/api/specialties` | Obtener especialidades |

### Protegidos (requieren token)
| Método | Ruta | Rol | Descripción |
|--------|------|-----|-------------|
| GET | `/api/me` | Todos | Perfil actual |
| POST | `/api/service-requests` | Paciente | Crear solicitud |
| GET | `/api/service-requests/my` | Paciente | Mis solicitudes |
| GET | `/api/service-requests/available` | Médico | Ver disponibles |
| POST | `/api/service-requests/{id}/offer` | Médico | Enviar oferta |

---

## 🔍 Ejemplo de Código Completo

```dart
import 'package:dio/dio.dart';

// 1. Crear instancia de Dio
final dio = Dio();

// 2. Enviar datos al backend
Future<void> registrar() async {
  try {
    final response = await dio.post(
      'http://localhost/saludgoft/saludgo-backend/public/api/register/patient',
      data: {
        'nombre': 'Juan Pérez',
        'email': 'juan@example.com',
        'password': '123456',
      },
    );
    
    // 3. Extraer datos de la respuesta
    String token = response.data['token'];
    String nombre = response.data['user']['nombre'];
    int userId = response.data['user']['id'];
    
    // 4. Guardar token localmente
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
    
    print('✅ Registrado: $nombre (ID: $userId)');
    
  } catch (e) {
    print('❌ Error: $e');
  }
}

// 5. Usar el token en peticiones protegidas
Future<void> obtenerPerfil() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? token = prefs.getString('token');
  
  final response = await dio.get(
    'http://localhost/saludgoft/saludgo-backend/public/api/me',
    options: Options(
      headers: {'Authorization': 'Bearer $token'},
    ),
  );
  
  print('Usuario: ${response.data['user']['nombre']}');
}
```

---

## 🚨 Troubleshooting

### ❌ "Error de conexión"
**Solución:**
1. Verifica que XAMPP esté corriendo (Apache + MySQL)
2. Si usas Android emulator: usa `10.0.2.2` en lugar de `localhost`
3. Si usas dispositivo físico: usa tu IP local y misma red WiFi

### ❌ "404 Not Found"
**Solución:**
- Verifica que la URL termine en `/public/api`
- Verifica que existe `.htaccess` en `public/` del backend

### ❌ "Email ya registrado"
**Solución:**
- Usa otro email o elimina el registro en phpMyAdmin

### ❌ Los logs no aparecen
**Solución:**
- En Flutter: verifica que `kDebugMode` esté habilitado
- En PHP: verifica `display_errors` en `php.ini`

---

## 📚 Documentación

- **Inicio rápido**: `INICIO_RAPIDO_BACKEND.md`
- **Guía completa**: `GUIA_CONEXION_BACKEND.md`
- **Ejemplo de prueba**: `lib/features/auth/screens/test_backend_connection.dart`
- **Formulario completo**: `lib/features/auth/screens/register_patient_screen.dart`

---

## ✅ Checklist

- [ ] XAMPP corriendo (Apache + MySQL)
- [ ] Backend accesible en navegador
- [ ] URL configurada en Flutter según tu plataforma
- [ ] Prueba simple ejecutada con éxito
- [ ] Registro verificado en base de datos
- [ ] Token guardado correctamente
- [ ] Login funcionando

---

## 🎯 Próximos Pasos

1. ✅ Implementar pantalla de login
2. ✅ Crear servicios para solicitudes médicas
3. ✅ Implementar listado de solicitudes
4. ✅ Agregar pantalla de perfil
5. ✅ Implementar refresh/logout

---

**¡Listo! Tu Flutter ahora puede comunicarse con el backend PHP y guardar datos en MySQL.** 🎉
