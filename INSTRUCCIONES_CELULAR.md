# SaludGo - Instrucciones para Probar en Celular

## 📱 Configuración para Probar en tu Celular

### Paso 1: Obtener la IP de tu PC

#### Windows:
1. Abre CMD (Símbolo del sistema)
2. Escribe: `ipconfig`
3. Busca "Dirección IPv4" (ejemplo: `192.168.1.100`)

#### Mac/Linux:
1. Abre Terminal
2. Escribe: `ifconfig` o `ip addr`
3. Busca tu IP local (ejemplo: `192.168.1.100`)

### Paso 2: Configurar la URL del Backend

Abre el archivo: `lib/core/network/dio_client.dart`

**Línea 13** - Cambia la baseUrl según donde pruebes:

```dart
// Para EMULADOR Android:
baseUrl: 'http://10.0.2.2:8000/api',

// Para CELULAR REAL (cambia por tu IP):
baseUrl: 'http://192.168.1.100:8000/api',

// Para iOS Simulator:
baseUrl: 'http://localhost:8000/api',
```

**O usa el método helper:**
```dart
// En cualquier lugar de tu código:
DioClient.updateBaseUrl('http://TU_IP:8000/api');
```

### Paso 3: Asegúrate de que el Backend esté Corriendo

1. Ve a tu carpeta `saludgo-backend`
2. Inicia el servidor (ejemplo con Laravel):
   ```bash
   php artisan serve --host=0.0.0.0 --port=8000
   ```
   
   **Importante:** Usa `--host=0.0.0.0` para que acepte conexiones desde otros dispositivos en la red.

### Paso 4: Conectar tu Celular

#### Opción A: USB (Recomendado para desarrollo)

1. **Android:**
   - Habilita "Opciones de desarrollador" en tu celular
   - Activa "Depuración USB"
   - Conecta por USB
   - Verifica la conexión: `flutter devices`

2. **iOS:**
   - Conecta tu iPhone por cable
   - Confía en tu computadora
   - Verifica: `flutter devices`

#### Opción B: WiFi (Misma red)

1. **Android:**
   ```bash
   # Primero conecta por USB
   adb tcpip 5555
   # Obtén la IP del celular (en Configuración > Acerca del teléfono > Estado)
   adb connect IP_DEL_CELULAR:5555
   ```

2. **iOS:**
   - Requiere Xcode y configuración adicional

### Paso 5: Ejecutar la App

```bash
# Ver dispositivos disponibles
flutter devices

# Ejecutar en el dispositivo conectado
flutter run

# O específica el dispositivo
flutter run -d DEVICE_ID
```

## 🔧 Solución de Problemas Comunes

### Error: "No se puede conectar al servidor"

1. **Verifica que ambos estén en la misma red WiFi**
2. **Desactiva el firewall temporalmente** (Windows/Mac)
3. **Confirma que el backend esté corriendo:** Abre en tu navegador PC: `http://localhost:8000/api`
4. **Prueba desde el celular:** Abre el navegador del celular y ve a `http://TU_IP:8000/api`

### Error de CORS

Si el backend está en Laravel, asegúrate de tener configurado CORS:

```php
// config/cors.php
'allowed_origins' => ['*'],
'allowed_methods' => ['*'],
'allowed_headers' => ['*'],
```

### El celular no aparece en `flutter devices`

**Android:**
- Revisa que USB debugging esté activado
- Prueba otro cable USB
- Instala drivers USB del fabricante

**iOS:**
- Confía en la computadora
- Verifica que Xcode esté instalado

## 📂 Estructura del Proyecto

```
lib/
├── core/
│   ├── network/
│   │   └── dio_client.dart         # ⚠️ Configura tu IP aquí
│   ├── router/
│   │   └── app_router.dart
│   ├── constants/
│   │   └── api_constants.dart      # Endpoints del API
│   └── theme/
│       ├── app_colors.dart
│       └── app_theme.dart
│
├── features/
│   ├── auth/                       # Autenticación
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   │
│   ├── patient/                    # Funcionalidades de Paciente
│   │   └── presentation/
│   │       └── pages/
│   │
│   └── doctor/                     # Funcionalidades de Médico
│       └── presentation/
│           └── pages/
│
└── main.dart
```

## 🚀 Próximos Pasos

### Funcionalidades Pendientes:

#### Paciente:
- [ ] Crear solicitud de servicio médico
- [ ] Ver solicitudes activas
- [ ] Ver ofertas recibidas de médicos
- [ ] Aceptar/rechazar ofertas
- [ ] Historial de servicios
- [ ] Calificar médicos

#### Médico:
- [ ] Ver solicitudes disponibles (por especialidad)
- [ ] Enviar ofertas a solicitudes
- [ ] Ver mis ofertas activas
- [ ] Servicios en curso
- [ ] Historial de servicios
- [ ] Perfil profesional (certificaciones)

## 💡 Tips de Desarrollo

1. **Hot Reload:** Presiona `r` en la terminal para recargar cambios
2. **Hot Restart:** Presiona `R` para reiniciar la app
3. **Ver logs:** Los errores aparecen en la terminal
4. **Debug en VSCode:** Usa F5 para debugger con breakpoints

## 🎨 Personalización

### Cambiar Colores:
Edita `lib/core/theme/app_colors.dart`

### Cambiar Logo:
1. Agrega tu logo en `assets/images/logo.png`
2. Actualiza `pubspec.yaml`:
   ```yaml
   flutter:
     assets:
       - assets/images/
   ```
3. En `welcome_page.dart` descomenta:
   ```dart
   Image.asset('assets/images/logo.png', height: 120)
   ```

## 📞 Contacto

Si tienes problemas, verifica:
1. ✅ Backend corriendo en `http://0.0.0.0:8000`
2. ✅ IP configurada correctamente
3. ✅ Celular y PC en la misma red
4. ✅ Firewall desactivado o con excepciones
