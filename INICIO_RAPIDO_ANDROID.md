# 🎯 Inicio Rápido - Emulador Android Studio

## ✅ Configuración Completada

Tu proyecto está **100% configurado** para el emulador de Android Studio.

---

## 🚀 3 Pasos para Probar AHORA

### Paso 1: Inicia XAMPP
1. Abre **XAMPP Control Panel**
2. Click **Start** en Apache
3. Click **Start** en MySQL

**Verifica:** Abre en tu navegador
```
http://localhost:8080/saludgoft/saludgo-backend/public/api/specialties
```
✅ Debes ver JSON con especialidades

---

### Paso 2: Inicia el Emulador
En Android Studio:
1. Click en el ícono 📱 (Device Manager)
2. Selecciona tu emulador
3. Click ▶️

**O** desde la terminal:
```bash
flutter emulators --launch <nombre_emulador>
```

Ver emuladores disponibles:
```bash
flutter emulators
```

---

### Paso 3: Ejecuta la App

En tu terminal (dentro de la carpeta `saludgo`):

```bash
flutter run
```

**O** en VS Code: presiona **F5**

---

## 🧪 Probar la Conexión

### Opción A: Usar la pantalla de prueba (MÁS FÁCIL)

Edita tu `lib/main.dart` para usar la pantalla de prueba temporalmente:

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
      home: const TestBackendConnection(),
      debugShowCheckedModeBanner: false,
    );
  }
}
```

Guarda, espera el hot reload, y verás:
- Botón: **Probar Conexión** (GET /specialties)
- Botón: **Probar Registro** (POST /register/patient)

---

## ✅ Resultado Esperado

### Al presionar "Probar Conexión":
```
✅ Conexión exitosa!

Status: 200
Datos: [{"id":1,"nombre":"Medicina General"}...]
```

### Al presionar "Probar Registro":
```
✅ Registro exitoso!

Status: 200
Token: eyJ0eXAiOiJKV1QiLCJh...
Usuario: Usuario Prueba
```

---

## 🎉 ¿Funciona?

### ✅ SÍ → ¡Perfecto!
Ahora puedes:
1. Implementar el formulario completo de registro
2. Crear pantalla de login
3. Construir el resto de tu app

### ❌ NO → Verifica:

**Error "Failed to connect":**
- ✅ XAMPP está corriendo (Apache verde)
- ✅ Backend funciona en navegador PC
- ✅ Reinicia el emulador

**Error "404 Not Found":**
- ✅ La URL es: `http://10.0.2.2:8080/saludgoft/saludgo-backend/public/api/specialties`
- ✅ Existe el archivo `.htaccess` en `public/`

**App no compila:**
```bash
flutter clean
flutter pub get
flutter run
```

---

## 📷 Verificar en Base de Datos

Después de un registro exitoso:

1. Abre: `http://localhost/phpmyadmin`
2. Selecciona tu base de datos
3. Click en tabla `usuarios`
4. Verás el nuevo usuario

---

## 📚 Documentación Completa

- **Esta guía rápida:** `INICIO_RAPIDO_ANDROID.md` (este archivo)
- **Guía Android completa:** `GUIA_ANDROID_EMULATOR.md`
- **Guía conexión detallada:** `GUIA_CONEXION_BACKEND.md`
- **Comandos útiles:** `COMANDOS_UTILES.md`

---

## 🔧 Configuración Actual

```dart
// lib/core/config/api_config.dart
static const String baseUrl = 'http://10.0.2.2:8080/saludgoft/saludgo-backend/public/api';
```

Esta es la configuración correcta para el emulador de Android Studio usando puerto 8080.

---

## 💡 Información Útil

**¿Por qué 10.0.2.2:8080?**  
- `10.0.2.2` es una IP especial del emulador Android que apunta al `localhost` de tu PC
- `:8080` es el puerto donde Apache está corriendo en tu XAMPP

**Ver logs en Flutter:**  
Aparecen automáticamente en la terminal donde corrió `flutter run`:
```
🌐 REQUEST: POST http://10.0.2.2/.../api/register/patient
✅ RESPONSE: 200
```

**Ver logs en Android Studio:**  
View → Tool Windows → Logcat

---

## ⚡ Comandos Rápidos

```bash
# Ver dispositivos disponibles
flutter devices

# Ejecutar en dispositivo específico
flutter run -d <device_id>

# Limpiar y reconstruir
flutter clean && flutter pub get && flutter run

# Ver emuladores
flutter emulators
```

---

**¡Listo! Ahora ejecuta `flutter run` y presiona los botones de prueba.** 🚀

Si ves ✅ significa que tu app Flutter se comunica perfectamente con el backend PHP.
