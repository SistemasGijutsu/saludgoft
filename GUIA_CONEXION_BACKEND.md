# 📱 Guía de Integración Flutter ↔️ Backend PHP

## 🎯 Resumen

Este documento explica cómo tu frontend Flutter (carpeta `saludgo`) se comunica con tu backend PHP (carpeta `saludgo-backend`) para guardar y recuperar datos de la base de datos.

---

## 🔄 Flujo de Comunicación

```
┌─────────────────┐         HTTP/JSON          ┌─────────────────┐
│                 │  ──────────────────────→   │                 │
│  Flutter App    │                             │  Backend PHP    │
│  (saludgo/)     │  ←──────────────────────   │  (saludgo-      │
│                 │                             │   backend/)     │
└─────────────────┘                             └─────────────────┘
                                                         │
                                                         ↓
                                                 ┌──────────────┐
                                                 │   MySQL DB   │
                                                 │  (usuarios)  │
                                                 └──────────────┘
```

### Proceso paso a paso:

1. **Usuario llena formulario** en Flutter
2. **Flutter envía datos** como JSON vía HTTP POST
3. **Backend PHP recibe** la petición en `/api/register/patient`
4. **PHP valida** y procesa los datos
5. **PHP guarda** en la base de datos MySQL (tabla `usuarios`)
6. **PHP responde** con un token JWT y datos del usuario
7. **Flutter guarda** el token localmente y muestra mensaje de éxito

---

## 🏗️ Arquitectura de Archivos

### Backend PHP (saludgo-backend/)
```
public/
  └── index.php                    # Punto de entrada, maneja CORS
src/
  ├── Infrastructure/
  │   ├── routes.php               # Define rutas: /api/register/patient
  │   ├── Controllers/
  │   │   └── PatientController.php  # Recibe petición de registro
  │   └── Persistence/
  │       └── UserRepository.php   # Guarda en tabla usuarios
  └── Application/
      └── DTOs/
          └── RegisterPatientDTO.php  # Valida datos de entrada
```

### Frontend Flutter (saludgo/)
```
lib/
  ├── core/
  │   ├── config/
  │   │   └── api_config.dart        # URLs del backend
  │   └── services/
  │       ├── api_service.dart       # Cliente HTTP (Dio)
  │       └── storage_service.dart   # Guarda token localmente
  └── features/
      └── auth/
          ├── models/
          │   └── auth_models.dart   # Modelos de datos
          ├── services/
          │   └── auth_service.dart  # Lógica de autenticación
          └── screens/
              └── register_patient_screen.dart  # UI de registro
```

---

## 🔧 Configuración

### 1. Configurar URL del Backend

Edita `lib/core/config/api_config.dart`:

```dart
class ApiConfig {
  // Elige la URL según tu caso:
  
  // Para navegador web:
  static const String baseUrl = 'http://localhost/saludgoft/saludgo-backend/public/api';
  
  // Para emulador de Android (10.0.2.2 = localhost de la PC):
  static const String baseUrl = 'http://10.0.2.2/saludgoft/saludgo-backend/public/api';
  
  // Para dispositivo físico (reemplaza con tu IP local):
  static const String baseUrl = 'http://192.168.1.10/saludgoft/saludgo-backend/public/api';
}
```

**¿Cómo obtener tu IP local?**
- Windows: Abre CMD y escribe `ipconfig` → Busca "IPv4 Address"
- Tu IP será algo como: `192.168.1.X`

### 2. Asegurar que XAMPP esté corriendo

1. Abre **XAMPP Control Panel**
2. Inicia **Apache** (servidor web)
3. Inicia **MySQL** (base de datos)

### 3. Verificar que el backend funciona

Abre en el navegador:
```
http://localhost/saludgoft/saludgo-backend/public/api/specialties
```

Deberías ver un JSON con las especialidades médicas.

---

## 📝 Ejemplo Completo: Registro de Paciente

### Paso 1: Usuario llena el formulario en Flutter

```dart
// En register_patient_screen.dart
TextFormField(
  controller: _nombreController,
  decoration: const InputDecoration(labelText: 'Nombre completo'),
),
TextFormField(
  controller: _emailController,
  decoration: const InputDecoration(labelText: 'Email'),
),
TextFormField(
  controller: _passwordController,
  decoration: const InputDecoration(labelText: 'Contraseña'),
  obscureText: true,
),
```

### Paso 2: Flutter envía los datos al backend

```dart
// Crear la petición
final request = PatientRegisterRequest(
  nombre: 'Juan Pérez',
  email: 'juan@example.com',
  password: '123456',
  telefono: '3001234567',
  ciudad: 'Bogotá',
);

// Enviar al backend
final response = await _authService.registerPatient(request);
```

**Datos que se envían (JSON):**
```json
{
  "nombre": "Juan Pérez",
  "email": "juan@example.com",
  "password": "123456",
  "telefono": "3001234567",
  "ciudad": "Bogotá"
}
```

### Paso 3: Backend recibe y procesa

**URL destino:** `POST http://localhost/.../api/register/patient`

El backend:
1. Valida que email y nombre no estén vacíos
2. Encripta la contraseña con `password_hash()`
3. Inserta en la tabla `usuarios`:
   ```sql
   INSERT INTO usuarios (nombre, email, password, rol, telefono, ciudad, ...)
   VALUES ('Juan Pérez', 'juan@example.com', '$2y$10$...', 'paciente', ...)
   ```
4. Genera un token JWT
5. Responde con:

```json
{
  "message": "Paciente registrado exitosamente",
  "token": "eyJ0eXAiOiJKV1QiLCJhbGc...",
  "user": {
    "id": 15,
    "nombre": "Juan Pérez",
    "email": "juan@example.com",
    "rol": "paciente",
    "telefono": "3001234567",
    "ciudad": "Bogotá"
  }
}
```

### Paso 4: Flutter guarda el token y muestra éxito

```dart
// Guardar token localmente (para futuras peticiones autenticadas)
await StorageService.saveToken(response.token);
await StorageService.saveUserInfo(
  userId: response.user.id,
  role: response.user.rol,
);

// Mostrar mensaje
ScaffoldMessenger.of(context).showSnackBar(
  SnackBar(content: Text('¡Registro exitoso!')),
);

// Navegar a la pantalla principal
Navigator.pushReplacementNamed(context, '/home');
```

---

## 🔐 Autenticación con JWT

### ¿Qué es el token JWT?

Es un "pase de acceso" que identifica al usuario. Se guarda en el dispositivo y se envía automáticamente en cada petición.

### Peticiones autenticadas

Para acceder a rutas protegidas (como crear solicitudes de servicio):

```dart
// El ApiService automáticamente agrega el token en los headers:
// Authorization: Bearer eyJ0eXAiOiJKV1...

final response = await _apiService.post('/service-requests', data: {...});
```

El backend verifica el token y extrae el ID del usuario.

---

## 🧪 Cómo Probar

### Opción 1: Usar la pantalla de ejemplo

Agrega la ruta en tu `main.dart` o router:

```dart
import 'features/auth/screens/register_patient_screen.dart';

// En tu MaterialApp o GoRouter:
MaterialApp(
  routes: {
    '/register': (context) => const RegisterPatientScreen(),
  },
)
```

### Opción 2: Probar con Postman

1. Abre **Postman**
2. Crea una petición **POST**
3. URL: `http://localhost/saludgoft/saludgo-backend/public/api/register/patient`
4. Body → raw → JSON:
   ```json
   {
     "nombre": "Test User",
     "email": "test@test.com",
     "password": "123456"
   }
   ```
5. Click en **Send**
6. Deberías recibir el token y datos del usuario

### Opción 3: Verificar en la base de datos

1. Abre **phpMyAdmin**: `http://localhost/phpmyadmin`
2. Selecciona tu base de datos
3. Abre la tabla `usuarios`
4. Verifica que se haya insertado el nuevo registro

---

## 🚨 Solución de Problemas

### Error: "Error de conexión"

**Causa:** Flutter no puede conectarse al backend

**Soluciones:**
1. Verifica que XAMPP esté corriendo (Apache activo)
2. Si usas emulador de Android, usa `10.0.2.2` en lugar de `localhost`
3. Si usas dispositivo físico:
   - Asegúrate de estar en la misma red WiFi
   - Usa tu IP local (no localhost)
   - Desactiva el firewall temporalmente

### Error: "CORS policy"

**Causa:** El backend rechaza peticiones del frontend

**Solución:** Ya está configurado CORS en el backend. Verifica que `CorsMiddleware::handle()` se llame en `public/index.php` (línea 14).

### Error: "Email ya registrado"

**Causa:** Ya existe un usuario con ese email

**Solución:** Usa otro email o elimina el registro anterior en la base de datos.

### La petición no llega al backend

**Verificar:**
1. URL correcta en `api_config.dart`
2. Apache corriendo en XAMPP
3. Archivo `.htaccess` en `public/` (para reescritura de URLs)

**Debug en Flutter:**
Los logs en consola muestran:
```
🌐 REQUEST: POST http://localhost/.../api/register/patient
📤 DATA: {nombre: Juan, email: ...}
✅ RESPONSE: 200
📥 DATA: {message: Paciente registrado...}
```

---

## 📊 Endpoints Disponibles

### Públicos (sin autenticación)

| Método | Ruta | Descripción |
|--------|------|-------------|
| POST | `/api/register/patient` | Registrar paciente |
| POST | `/api/register/doctor` | Registrar médico |
| POST | `/api/login` | Iniciar sesión |
| GET | `/api/specialties` | Obtener especialidades |

### Protegidos (requieren token)

| Método | Ruta | Rol | Descripción |
|--------|------|-----|-------------|
| GET | `/api/me` | Todos | Obtener perfil actual |
| POST | `/api/service-requests` | Paciente | Crear solicitud |
| GET | `/api/service-requests/my` | Paciente | Mis solicitudes |
| GET | `/api/service-requests/available` | Médico | Ver solicitudes disponibles |
| POST | `/api/service-requests/{id}/offer` | Médico | Enviar oferta |

---

## 🎓 Conceptos Clave

### HTTP/REST API
- **GET**: Obtener datos (no modifica nada)
- **POST**: Crear/enviar datos
- **PUT**: Actualizar datos existentes
- **DELETE**: Eliminar datos

### JSON
Formato de texto para intercambiar datos entre aplicaciones:
```json
{
  "clave": "valor",
  "numero": 123,
  "lista": [1, 2, 3]
}
```

### CORS (Cross-Origin Resource Sharing)
Permite que tu app Flutter (en un puerto/dominio) se comunique con el backend PHP (en otro puerto/dominio).

### JWT (JSON Web Token)
Token de autenticación que contiene información cifrada del usuario. Se envía en el header `Authorization: Bearer TOKEN`.

---

## ✅ Checklist de Integración

- [ ] XAMPP corriendo (Apache + MySQL)
- [ ] Base de datos creada con tabla `usuarios`
- [ ] Backend accesible en navegador
- [ ] URL del backend configurada en `api_config.dart`
- [ ] Dependencia `dio` instalada en Flutter (`flutter pub get`)
- [ ] Archivos de servicios creados
- [ ] Prueba de registro exitosa
- [ ] Token guardado correctamente
- [ ] Verificación en base de datos

---

## 📚 Próximos Pasos

1. **Crear pantalla de login** similar a la de registro
2. **Implementar solicitudes de servicio** (peticiones POST a `/api/service-requests`)
3. **Mostrar lista de solicitudes** (GET a `/api/service-requests/my`)
4. **Agregar manejo de errores** más robusto
5. **Implementar refresh token** para sesiones largas

---

## 🆘 Necesitas Ayuda?

1. Revisa los logs en la consola de Flutter
2. Verifica los logs de Apache en XAMPP (botón "Logs")
3. Usa `print()` para debuggear en Flutter
4. Usa `var_dump()` en PHP para ver qué datos llegan
5. Prueba endpoints en Postman primero

---

**¡Listo! Ahora tu Flutter puede comunicarse con el backend PHP y guardar datos en MySQL.** 🎉
