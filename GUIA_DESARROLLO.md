# Guía de Desarrollo - SaludGo

## 🎯 Estado Actual del Proyecto

### ✅ Completado:

1. **Arquitectura Base (Clean Architecture)**
   - Estructura de carpetas organizada
   - Separación entre features (auth, patient, doctor)
   - Core con utilidades compartidas

2. **Sistema de Autenticación**
   - Modelos de Usuario y AuthState
   - Repository para llamadas al API
   - Provider con Riverpod para estado global
   - Persistencia de sesión con SharedPreferences
   - Pantallas: Welcome, Login, Register (Patient/Doctor)

3. **Navegación**
   - GoRouter configurado
   - Rutas protegidas según autenticación
   - Redirección automática según rol (patient/doctor)

4. **Tema y Estilos**
   - Colores basados en el logo de SaludGo
   - Tema unificado con Material 3
   - Componentes reutilizables

5. **Páginas Home**
   - PatientHomePage: Menú básico para pacientes
   - DoctorHomePage: Menú básico para médicos
   - Logout funcional

### 🚧 Pendiente de Implementar:

## Para Pacientes:

### 1. Crear Solicitud de Servicio
**Archivos a crear:**
```
lib/features/patient/
├── data/
│   ├── models/
│   │   └── service_request.dart
│   └── repositories/
│       └── service_request_repository.dart
├── domain/
│   └── models/
│       └── specialty.dart
└── presentation/
    ├── pages/
    │   └── create_request_page.dart
    └── providers/
        └── service_request_provider.dart
```

**Funcionalidad:**
- Formulario para describir el problema
- Selector de especialidad (cargar desde API)
- Botón para enviar solicitud
- POST a `/api/service-requests`

### 2. Ver Mis Solicitudes
**Archivos a crear:**
```
lib/features/patient/presentation/pages/
└── my_requests_page.dart
```

**Funcionalidad:**
- Lista de solicitudes activas
- Estado: pendiente, con ofertas, aceptada, completada
- GET a `/api/service-requests`
- Ver ofertas recibidas por solicitud

### 3. Ver y Gestionar Ofertas
**Archivos a crear:**
```
lib/features/patient/
├── data/
│   ├── models/
│   │   └── offer.dart
│   └── repositories/
│       └── offer_repository.dart
└── presentation/
    └── pages/
        └── offers_page.dart
```

**Funcionalidad:**
- Ver ofertas de médicos
- Información del médico (perfil, calificación)
- Precio propuesto
- Botones: Aceptar / Rechazar
- PUT a `/api/patient/offers/{id}/accept`

## Para Médicos:

### 1. Ver Solicitudes Disponibles
**Archivos a crear:**
```
lib/features/doctor/
├── data/
│   ├── models/
│   │   └── available_request.dart
│   └── repositories/
│       └── doctor_repository.dart
└── presentation/
    └── pages/
        └── available_requests_page.dart
```

**Funcionalidad:**
- Filtrar por especialidad del médico
- Ver detalles de cada solicitud
- Información del paciente
- GET a `/api/doctor/service-requests`

### 2. Enviar Oferta
**Archivos a crear:**
```
lib/features/doctor/presentation/pages/
└── create_offer_page.dart
```

**Funcionalidad:**
- Formulario con precio propuesto
- Tiempo estimado
- Mensaje opcional
- POST a `/api/doctor/offers`

### 3. Mis Ofertas
**Archivos a crear:**
```
lib/features/doctor/presentation/pages/
└── my_offers_page.dart
```

**Funcionalidad:**
- Ver ofertas enviadas
- Estados: pendiente, aceptada, rechazada
- GET a `/api/doctor/offers`

## Características Comunes:

### 1. Perfil de Usuario
**Archivos a crear:**
```
lib/features/profile/
├── data/
│   └── repositories/
│       └── profile_repository.dart
└── presentation/
    └── pages/
        ├── profile_page.dart
        └── edit_profile_page.dart
```

### 2. Historial
**Archivos a crear:**
```
lib/features/history/
└── presentation/
    └── pages/
        └── history_page.dart
```

### 3. Sistema de Calificaciones
**Archivos a crear:**
```
lib/features/rating/
├── data/
│   ├── models/
│   │   └── rating.dart
│   └── repositories/
│       └── rating_repository.dart
└── presentation/
    └── widgets/
        └── rating_dialog.dart
```

## 📝 Ejemplos de Código para Implementar

### Crear un Repository:

```dart
import 'package:dio/dio.dart';
import '../../../../core/network/dio_client.dart';

class ServiceRequestRepository {
  final Dio _dio = DioClient.dio;

  Future<List<ServiceRequest>> getMyRequests() async {
    try {
      final response = await _dio.get('/service-requests');
      return (response.data as List)
          .map((json) => ServiceRequest.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Error al obtener solicitudes');
    }
  }

  Future<ServiceRequest> createRequest({
    required String description,
    required int specialtyId,
  }) async {
    try {
      final response = await _dio.post(
        '/service-requests',
        data: {
          'description': description,
          'specialty_id': specialtyId,
        },
      );
      return ServiceRequest.fromJson(response.data);
    } catch (e) {
      throw Exception('Error al crear solicitud');
    }
  }
}
```

### Crear un Provider:

```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/repositories/service_request_repository.dart';

final serviceRequestRepositoryProvider = Provider<ServiceRequestRepository>((ref) {
  return ServiceRequestRepository();
});

final myRequestsProvider = FutureProvider<List<ServiceRequest>>((ref) async {
  final repository = ref.read(serviceRequestRepositoryProvider);
  return await repository.getMyRequests();
});
```

### Usar en una Página:

```dart
class MyRequestsPage extends ConsumerWidget {
  const MyRequestsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final requestsAsync = ref.watch(myRequestsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Mis Solicitudes')),
      body: requestsAsync.when(
        data: (requests) => ListView.builder(
          itemCount: requests.length,
          itemBuilder: (context, index) {
            final request = requests[index];
            return ListTile(
              title: Text(request.description),
              subtitle: Text(request.status),
            );
          },
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
      ),
    );
  }
}
```

## 🔗 Agregar Rutas Nuevas

En `lib/core/router/app_router.dart`, agrega:

```dart
// Dentro de routes:
GoRoute(
  path: '/patient/create-request',
  builder: (context, state) => const CreateRequestPage(),
),
GoRoute(
  path: '/patient/my-requests',
  builder: (context, state) => const MyRequestsPage(),
),
```

## 🎨 Widgets Reutilizables Recomendados

Crea estos en `lib/core/widgets/`:

1. **loading_widget.dart** - Indicador de carga personalizado
2. **error_widget.dart** - Widget para mostrar errores
3. **empty_state_widget.dart** - Cuando no hay datos
4. **custom_button.dart** - Botones personalizados
5. **custom_text_field.dart** - Campos de texto personalizados

## 🐛 Gestión de Errores

Crea un interceptor global de Dio en `dio_client.dart`:

```dart
_dio!.interceptors.add(
  InterceptorsWrapper(
    onError: (DioException e, handler) {
      String message = 'Error desconocido';
      
      if (e.response != null) {
        message = e.response!.data['message'] ?? 'Error del servidor';
      } else {
        message = 'Error de conexión';
      }
      
      // Mostrar SnackBar global o manejar según necesites
      
      return handler.next(e);
    },
  ),
);
```

## 📱 Testing

Para probar funcionalidades sin backend:

1. Crea mocks de datos
2. Usa `FakeAsync` para simular respuestas
3. Ejemplo:

```dart
class MockServiceRequestRepository implements ServiceRequestRepository {
  @override
  Future<List<ServiceRequest>> getMyRequests() async {
    await Future.delayed(Duration(seconds: 1)); // Simular red
    return [
      ServiceRequest(
        id: 1,
        description: 'Dolor de cabeza',
        specialtyId: 1,
        status: 'pending',
      ),
    ];
  }
}
```

## 🚀 Próximos Pasos Inmediatos

1. **Implementar crear solicitud (paciente)**
   - Es la funcionalidad core del paciente
   - Necesitas el modelo, repository, provider y página

2. **Implementar ver solicitudes disponibles (médico)**
   - Funcionalidad core del médico
   - Cargar según la especialidad del médico

3. **Sistema de ofertas**
   - Médico envía oferta
   - Paciente la ve y acepta/rechaza

4. **Gestión de especialidades**
   - Cargar desde el backend
   - Mostrar en selectores

## 💡 Tips Importantes

- Siempre usa `ConsumerWidget` o `ConsumerStatefulWidget` para usar Riverpod
- Maneja los 3 estados: loading, data, error
- Usa `ref.listen` para navegar después de acciones exitosas
- Implementa primero las funcionalidades sin diseño bonito
- Una vez funcional, mejora el UI

## 🔐 Seguridad

El token se guarda automáticamente en `SharedPreferences` y se agrega a las peticiones mediante el interceptor de Dio. Para endpoints protegidos, el token ya se envía en el header `Authorization: Bearer {token}`.

Si necesitas actualizar el token en algún momento:

```dart
// En el interceptor onRequest
final prefs = await SharedPreferences.getInstance();
final token = prefs.getString('token');
if (token != null) {
  options.headers['Authorization'] = 'Bearer $token';
}
```

---

**¿Necesitas ayuda?** Revisa los archivos existentes en `features/auth` como referencia para implementar nuevas features siguiendo el mismo patrón.
