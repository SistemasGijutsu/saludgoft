# 🛠️ Comandos Útiles

## Flutter

### Ejecutar la app
```bash
flutter run
```

### Ejecutar en dispositivo específico
```bash
flutter devices                    # Ver dispositivos disponibles
flutter run -d chrome              # Ejecutar en navegador
flutter run -d android             # Ejecutar en Android
flutter run -d ios                 # Ejecutar en iOS
```

### Instalar dependencias
```bash
flutter pub get
```

### Generar archivos de serialización JSON
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

### Limpiar caché
```bash
flutter clean
flutter pub get
```

### Ver logs en tiempo real
```bash
flutter logs
```

---

## Backend PHP (XAMPP)

### Iniciar servicios
1. Abre **XAMPP Control Panel**
2. Click en **Start** junto a Apache
3. Click en **Start** junto a MySQL

### Verificar que el servidor funciona
Abre en el navegador:
```
http://localhost/saludgoft/saludgo-backend/public/api/specialties
```

### Ver logs de Apache
En XAMPP Control Panel → Click en **Logs** junto a Apache

---

## MySQL / phpMyAdmin

### Abrir phpMyAdmin
```
http://localhost/phpmyadmin
```

### Ver tabla usuarios
1. Selecciona tu base de datos en el panel izquierdo
2. Click en la tabla `usuarios`
3. Verás todos los registros

### Consulta SQL para ver usuarios
```sql
SELECT * FROM usuarios ORDER BY id DESC;
```

### Eliminar un usuario por email
```sql
DELETE FROM usuarios WHERE email = 'test@example.com';
```

### Ver últimos usuarios registrados
```sql
SELECT id, nombre, email, fecha_registro 
FROM usuarios 
ORDER BY fecha_registro DESC 
LIMIT 10;
```

---

## Git

### Ver estado del repositorio
```bash
git status
```

### Agregar cambios
```bash
git add .
```

### Hacer commit
```bash
git commit -m "descripción del cambio"
```

### Subir a GitHub
```bash
git push origin main
```

### Ver historial de commits
```bash
git log --oneline
```

---

## Debugging

### Ver IP local (Windows)
```bash
ipconfig
```
Busca "IPv4 Address" → será algo como `192.168.1.10`

### Ver IP local (Mac/Linux)
```bash
ifconfig
```

### Probar endpoint con curl
```bash
curl http://localhost/saludgoft/saludgo-backend/public/api/specialties
```

### Probar registro con curl
```bash
curl -X POST http://localhost/saludgoft/saludgo-backend/public/api/register/patient \
  -H "Content-Type: application/json" \
  -d '{"nombre":"Test","email":"test@test.com","password":"123456"}'
```

---

## Postman

### Importar colección
1. Abre Postman
2. File → Import
3. Selecciona `SaludGo_Postman_Collection.json` (si está en tu backend)

### Crear petición GET
1. New → Request
2. Método: **GET**
3. URL: `http://localhost/saludgoft/saludgo-backend/public/api/specialties`
4. Click **Send**

### Crear petición POST (registro)
1. New → Request
2. Método: **POST**
3. URL: `http://localhost/saludgoft/saludgo-backend/public/api/register/patient`
4. Body → raw → JSON:
   ```json
   {
     "nombre": "Test User",
     "email": "test@example.com",
     "password": "123456"
   }
   ```
5. Click **Send**

### Guardar token para peticiones protegidas
1. Después de login/registro, copia el `token` de la respuesta
2. En la petición protegida → Headers:
   - Key: `Authorization`
   - Value: `Bearer <TU_TOKEN>`

---

## Verificación Rápida

### ✅ Backend funcionando
```
http://localhost/saludgoft/saludgo-backend/public/api/specialties
```
✓ Debe devolver JSON con especialidades

### ✅ Base de datos conectada
En phpMyAdmin → Selecciona tu BD → Verifica que existen las tablas:
- usuarios
- pacientes
- profesionales
- especialidades
- solicitudes_servicio
- ofertas
- servicios

### ✅ Flutter compila sin errores
```bash
flutter doctor
flutter pub get
flutter analyze
```

---

## Atajos VS Code

- `Ctrl + Shift + P` → Buscar comandos
- `Ctrl + Shift + F` → Buscar en todo el proyecto
- `F5` → Iniciar depuración
- `Ctrl + Space` → Autocompletado
- `Ctrl + Click` → Ir a definición

---

## Notas Importantes

### URLs según plataforma

| Plataforma | URL base |
|------------|----------|
| Web / iOS Simulator | `http://localhost/saludgoft/saludgo-backend/public/api` |
| Android Emulator | `http://10.0.2.2/saludgoft/saludgo-backend/public/api` |
| Dispositivo Físico | `http://TU_IP_LOCAL/saludgoft/saludgo-backend/public/api` |

### Archivo a editar
`lib/core/config/api_config.dart` o directamente en `test_backend_connection.dart`

---

**Guarda este archivo como referencia rápida.** 📌
