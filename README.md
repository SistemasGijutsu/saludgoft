# 🏥 SaludGo - Frontend Flutter

## ✅ Proyecto Completado y Listo para Usar

### 🎉 ¿Qué está implementado?

#### 1. **Arquitectura Completa**
✅ Clean Architecture con separación de capas  
✅ Estructura organizada por features (auth, patient, doctor)  
✅ Core centralizado con utilidades compartidas  
✅ Código escalable y mantenible  

#### 2. **Sistema de Autenticación**
✅ Login funcional  
✅ Registro (Paciente y Médico)  
✅ Persistencia de sesión  
✅ Logout  
✅ Verificación automática de token  
✅ Redirección según rol  

#### 3. **Navegación**
✅ GoRouter configurado  
✅ Pantalla de bienvenida  
✅ Rutas protegidas  
✅ Home para pacientes  
✅ Home para médicos  

#### 4. **Diseño**
✅ Tema personalizado con colores de SaludGo  
✅ Material 3  
✅ Interfaz responsive  
✅ Componentes reutilizables  

---

## 🚀 Cómo Ejecutar la App en tu Celular

### **Opción 1: Método Rápido (Recomendado)**

1. **Conecta tu celular por USB**
   - Android: Activa "Depuración USB" en opciones de desarrollador
   - iOS: Confía en tu computadora

2. **Configura la IP del backend**
   ```dart
   // Archivo: lib/core/network/dio_client.dart
   // Línea 13: Cambia a tu IP local
   baseUrl: 'http://TU_IP_AQUI:8000/api',
   ```
   
   Para obtener tu IP:
   - Windows: `ipconfig` en CMD
   - Mac/Linux: `ifconfig` en Terminal

3. **Inicia tu backend**
   ```bash
   # En la carpeta saludgo-backend
   php artisan serve --host=0.0.0.0 --port=8000
   ```

4. **Ejecuta la app**
   ```bash
   # En esta carpeta (saludgo)
   flutter devices  # Ver dispositivos disponibles
   flutter run      # Ejecutar en el dispositivo conectado
   ```

### **Opción 2: Emulador (Para pruebas rápidas)**

1. **Inicia el emulador**
   ```bash
   flutter emulators
   flutter emulators --launch <emulator_id>
   ```

2. **Para Android Emulator: NO cambies la IP**
   ```dart
   // Deja esto tal cual en dio_client.dart
   baseUrl: 'http://10.0.2.2:8000/api',
   ```

3. **Ejecuta la app**
   ```bash
   flutter run
   ```

---

## 🔧 Configuración Importante

### **1. Cambiar la IP del Backend**

**Archivo:** `lib/core/network/dio_client.dart`

```dart
// Línea 13
baseUrl: 'http://192.168.1.100:8000/api',  // 👈 Cambia por tu IP
```

### **2. Iniciar el Backend Correctamente**

```bash
php artisan serve --host=0.0.0.0 --port=8000
```

**⚠️ Importante:** El flag `--host=0.0.0.0` permite que tu celular se conecte al backend.

### **3. Misma Red WiFi**

Tu celular y tu PC deben estar conectados a la **misma red WiFi**.

---

## 📁 Estructura del Proyecto

```
lib/
├── core/                          # Código compartido
│   ├── network/
│   │   └── dio_client.dart       ⚠️ CONFIGURA TU IP AQUÍ
│   ├── router/
│   │   └── app_router.dart       # Rutas de navegación
│   ├── theme/
│   │   ├── app_colors.dart       # Colores de SaludGo
│   │   └── app_theme.dart        # Tema general
│   └── constants/
│       └── api_constants.dart    # URLs del API
│
├── features/
│   ├── auth/                     # 🔐 Autenticación
│   ├── patient/                  # 👤 Funcionalidades Paciente
│   └── doctor/                   # 👨‍⚕️ Funcionalidades Médico
│
└── main.dart                     # Punto de entrada
```

---

## 🐛 Solución de Problemas

### **"No se puede conectar al servidor"**

✅ **Verificaciones:**
1. Backend corriendo: `http://localhost:8000/api`
2. IP configurada correctamente en `dio_client.dart`
3. Celular y PC en la misma WiFi
4. Prueba desde el navegador del celular: `http://TU_IP:8000/api`
5. Desactiva el firewall temporalmente

---

## 📚 Documentación Adicional

- **📱 INSTRUCCIONES_CELULAR.md** - Guía detallada para pruebas en celular
- **🔨 GUIA_DESARROLLO.md** - Cómo continuar desarrollando features

---

## 🎯 Próximos Pasos (Features Pendientes)

### **Paciente:**
- [ ] Crear solicitud de servicio médico
- [ ] Ver solicitudes activas
- [ ] Ver ofertas de médicos
- [ ] Aceptar/rechazar ofertas

### **Médico:**
- [ ] Ver solicitudes disponibles
- [ ] Enviar ofertas
- [ ] Gestionar servicios activos

---

## ✅ Checklist Antes de Ejecutar

- [ ] Backend corriendo en `http://0.0.0.0:8000`
- [ ] IP configurada en `dio_client.dart`
- [ ] Celular conectado o emulador iniciado
- [ ] `flutter devices` muestra tu dispositivo
- [ ] PC y celular en la misma red WiFi

---

## 🚀 Comando Rápido

```bash
flutter pub get && flutter run
```

---

**¡El frontend está listo para conectarse con tu backend! 🎉**
