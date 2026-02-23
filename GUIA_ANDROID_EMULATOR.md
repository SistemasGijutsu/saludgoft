# 📱 Guía para Emulador de Android Studio

## ✅ Configuración Completada

Tu proyecto Flutter ya está configurado para funcionar con el **Emulador de Android Studio**.

### 🔧 URL Configurada
```dart
http://10.0.2.2:8080/saludgoft/saludgo-backend/public/api
```

**¿Por qué `10.0.2.2:8080`?**  
- `10.0.2.2` es una dirección especial del emulador Android que apunta al `localhost` de tu PC
- `:8080` es el puerto donde corre Apache en tu XAMPP

---

## 🚀 Pasos para Probar

### 1. Asegúrate que XAMPP esté corriendo
- Abre **XAMPP Control Panel**
- Inicia **Apache** (debe mostrar el puerto 80)
- Inicia **MySQL**

### 2. Verifica el backend desde tu PC
Abre en el navegador de tu PC (no en el emulador):
```
http://localhost:8080/saludgoft/saludgo-backend/public/api/specialties
```

Deberías ver un JSON similar a:
```json
[
  {"id": 1, "nombre": "Medicina General"},
  {"id": 2, "nombre": "Cardiología"},
  ...
]
```

### 3. Inicia el emulador de Android
En Android Studio:
1. Click en el ícono de dispositivo (Device Manager)
2. Selecciona tu emulador (o crea uno nuevo)
3. Click en ▶️ para iniciarlo

### 4. Ejecuta tu app Flutter
En la terminal (en la carpeta `saludgo`):
```bash
flutter run
```

O en VS Code: presiona **F5** o click en "Run > Start Debugging"

### 5. Prueba la conexión
Tu app debería iniciar en el emulador. Si configuraste la ruta a `TestBackendConnection`, verás dos botones:
- **Probar Conexión**: Hace GET a `/specialties`
- **Probar Registro**: Hace POST a `/register/patient`

---

## 🧪 Probar desde la Terminal

También puedes probar desde tu PC que el emulador puede acceder:

```bash
# En la terminal de tu PC:
curl http://10.0.2.2:8080/saludgoft/saludgo-backend/public/api/specialties
```

---

## 🎯 Usar la Pantalla de Prueba

### Opción 1: Como pantalla principal temporal

Edita tu `lib/main.dart`:

```dart
import 'package:flutter/material.dart';
import 'features/auth/screens/test_backend_connection.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SaludGo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const TestBackendConnection(), // ← Pantalla de prueba
      debugShowCheckedModeBanner: false,
    );
  }
}
```

### Opción 2: Agregar como ruta

```dart
import 'features/auth/screens/test_backend_connection.dart';

MaterialApp(
  routes: {
    '/test': (context) => const TestBackendConnection(),
  },
)

// Para navegar:
Navigator.pushNamed(context, '/test');
```

---

## ✅ Qué Esperar

### Al presionar "Probar Conexión":
```
✅ Conexión exitosa!

Status: 200
Datos: [lista de especialidades...]
```

### Al presionar "Probar Registro":
```
✅ Registro exitoso!

Status: 200
Token: eyJ0eXAiOiJKV1QiLCJh...
Usuario: Usuario Prueba
```

---

## 🚨 Solución de Problemas

### ❌ Error: "Failed to connect to 10.0.2.2"

**Causas posibles:**
1. XAMPP no está corriendo
2. Apache no está en el puerto 80
3. Firewall bloqueando la conexión

**Soluciones:**
1. Verifica que Apache esté verde en XAMPP
2. Verifica que el puerto sea 8080 (click en Config → Apache → httpd.conf, busca `Listen 8080`)
3. Desactiva temporalmente el firewall de Windows

### ❌ Error: "404 Not Found"

**Causa:** La ruta no es correcta

**Solución:**
Verifica que la URL sea exactamente:
```
http://10.0.2.2:8080/saludgoft/saludgo-backend/public/api/specialties
```

Verifica también que el archivo `.htaccess` exista en `public/`.

### ❌ Error: "Connection timed out"

**Causa:** El emulador no puede acceder a tu PC

**Solución:**
1. Reinicia el emulador
2. Verifica que XAMPP esté corriendo
3. Prueba desde el navegador de tu PC primero

### ❌ La pantalla no aparece / app crashea

**Causa:** Importación incorrecta o falta dependencia

**Solución:**
```bash
flutter clean
flutter pub get
flutter run
```

---

## 📊 Verificar en la Base de Datos

Después de hacer un registro exitoso:

1. Abre phpMyAdmin: `http://localhost/phpmyadmin`
2. Selecciona tu base de datos
3. Click en la tabla `usuarios`
4. Verás el nuevo usuario registrado

```sql
SELECT id, nombre, email, fecha_registro 
FROM usuarios 
ORDER BY id DESC 
LIMIT 5;
```

---

## 🔍 Ver Logs en Tiempo Real

### En Flutter:
Los logs aparecen automáticamente en la terminal donde ejecutaste `flutter run`:

```
🌐 REQUEST: POST http://10.0.2.2/.../api/register/patient
📤 DATA: {nombre: Usuario Prueba, email: ...}
✅ RESPONSE: 200
📥 DATA: {message: Paciente registrado...}
```

### En PHP (backend):
En XAMPP Control Panel → Click en **Logs** junto a Apache → **error.log**

---

## 📱 Información del Emulador

### Direcciones IP especiales en Android Emulator:
- `10.0.2.2` → localhost de tu PC (el que usamos)
- `10.0.2.3` → Primer servidor DNS
- `10.0.2.15` → La IP del emulador mismo

### Ver logs del emulador:
En Android Studio: **View → Tool Windows → Logcat**

Filtrar por tu app:
```
package:com.example.saludgo
```

---

## ✅ Checklist

- [x] XAMPP corriendo (Apache en puerto 8080 + MySQL)
- [x] Backend verificado desde navegador PC
- [x] Emulador de Android iniciado
- [x] URL configurada a `10.0.2.2:8080` en Flutter
- [ ] App ejecutándose en el emulador
- [ ] Prueba de conexión exitosa
- [ ] Registro de usuario exitoso
- [ ] Usuario verificado en base de datos

---

## 🎯 Siguiente Paso

Una vez que veas "✅ Conexión exitosa" y "✅ Registro exitoso", ya puedes:

1. Implementar el formulario completo de registro
2. Crear la pantalla de login
3. Agregar funcionalidad de solicitudes de servicio
4. Construir el resto de tu app

---

## 📚 Archivos Relevantes

- **Configuración:** `lib/core/config/api_config.dart`
- **Servicio HTTP:** `lib/core/services/api_service.dart`
- **Pantalla de prueba:** `lib/features/auth/screens/test_backend_connection.dart`
- **Formulario completo:** `lib/features/auth/screens/register_patient_screen.dart`

---

**¡Todo está listo para usar tu app con el emulador de Android Studio!** 🎉

Si ves ✅ en las pruebas, significa que Flutter puede comunicarse perfectamente con tu backend PHP y guardar datos en MySQL.
