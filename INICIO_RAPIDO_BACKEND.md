# 🚀 Inicio Rápido: Conectar Flutter con Backend PHP

## ✅ Paso 1: Verificar que el backend funciona

1. Abre **XAMPP Control Panel**
2. Inicia **Apache** y **MySQL**
3. Abre en tu navegador:
   ```
   http://localhost/saludgoft/saludgo-backend/public/api/specialties
   ```
4. Deberías ver un JSON con especialidades médicas

## ✅ Paso 2: Configurar la URL en Flutter

Abre `lib/features/auth/screens/test_backend_connection.dart` y cambia la URL según tu caso:

```dart
// Para navegador web o iOS simulator:
final String baseUrl = 'http://localhost/saludgoft/saludgo-backend/public/api';

// Para emulador de Android:
final String baseUrl = 'http://10.0.2.2/saludgoft/saludgo-backend/public/api';

// Para dispositivo físico (reemplaza con tu IP):
final String baseUrl = 'http://192.168.1.X/saludgoft/saludgo-backend/public/api';
```

**¿Cómo obtener tu IP?** (solo si usas dispositivo físico)
- Abre CMD (Windows) y escribe: `ipconfig`
- Busca "IPv4 Address" → será algo como `192.168.1.10`

## ✅ Paso 3: Probar la conexión

### Opción A: Usar la pantalla de prueba

Agrega esta pantalla a tu router o main.dart:

```dart
import 'features/auth/screens/test_backend_connection.dart';

// En tu MaterialApp:
home: TestBackendConnection(),

// O en tus rutas:
'/test': (context) => TestBackendConnection(),
```

Luego ejecuta la app y presiona los botones para probar.

### Opción B: Usar Postman

1. Abre Postman
2. Crea request **GET**:
   - URL: `http://localhost/saludgoft/saludgo-backend/public/api/specialties`
   - Click "Send"
3. Crea request **POST**:
   - URL: `http://localhost/saludgoft/saludgo-backend/public/api/register/patient`
   - Body → raw → JSON:
     ```json
     {
       "nombre": "Test User",
       "email": "test@example.com",
       "password": "123456"
     }
     ```
   - Click "Send"

## 📝 Ejemplo Completo de Uso

```dart
import 'package:dio/dio.dart';

Future<void> registrarPaciente() async {
  final dio = Dio();
  
  try {
    final response = await dio.post(
      'http://localhost/saludgoft/saludgo-backend/public/api/register/patient',
      data: {
        'nombre': 'Juan Pérez',
        'email': 'juan@example.com',
        'password': '123456',
        'telefono': '3001234567',
      },
    );
    
    print('✅ Registro exitoso!');
    print('Token: ${response.data['token']}');
    print('Usuario: ${response.data['user']['nombre']}');
    
  } catch (e) {
    print('❌ Error: $e');
  }
}
```

## 🔍 Verificar en Base de Datos

1. Abre phpMyAdmin: `http://localhost/phpmyadmin`
2. Selecciona tu base de datos
3. Abre la tabla `usuarios`
4. Verifica que se haya insertado el nuevo registro

## 🚨 Problemas Comunes

### "Error de conexión"
- ✅ Verifica que XAMPP esté corriendo
- ✅ Si usas Android emulator, usa `10.0.2.2` en lugar de `localhost`
- ✅ Si usas dispositivo físico, usa tu IP local y misma red WiFi

### "404 Not Found"
- ✅ Verifica que la URL tenga `/public/api` al final
- ✅ Verifica que existe el archivo `.htaccess` en `public/`

### "email ya registrado"
- ✅ Usa otro email o elimina el registro anterior en la BD

## 📚 Archivos Creados

```
saludgo/
├── lib/
│   ├── core/
│   │   ├── config/
│   │   │   └── api_config.dart          # URLs del backend
│   │   └── services/
│   │       ├── api_service.dart         # Cliente HTTP
│   │       └── storage_service.dart     # Guardar token
│   └── features/
│       └── auth/
│           ├── models/
│           │   └── auth_models.dart     # Modelos de datos
│           ├── services/
│           │   └── auth_service.dart    # Servicio de auth
│           └── screens/
│               ├── register_patient_screen.dart      # Registro completo
│               └── test_backend_connection.dart      # Prueba simple
└── GUIA_CONEXION_BACKEND.md            # Guía completa
```

## 🎯 Próximos Pasos

1. ✅ Prueba la conexión con `TestBackendConnection`
2. ✅ Verifica el registro en la base de datos
3. ✅ Implementa login
4. ✅ Usa `RegisterPatientScreen` para un formulario completo
5. ✅ Lee `GUIA_CONEXION_BACKEND.md` para entender el flujo completo

---

**¿Funciona? ¡Perfecto! Ahora puedes guardar y obtener datos del backend desde Flutter.** 🎉
