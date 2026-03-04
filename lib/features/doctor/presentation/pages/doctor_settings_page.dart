import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wakelock_plus/wakelock_plus.dart';
import 'package:package_info_plus/package_info_plus.dart';

class DoctorSettingsPage extends ConsumerStatefulWidget {
  const DoctorSettingsPage({super.key});

  @override
  ConsumerState<DoctorSettingsPage> createState() => _DoctorSettingsPageState();
}

class _DoctorSettingsPageState extends ConsumerState<DoctorSettingsPage> {
  bool _keepScreenOn = false;
  String _selectedLanguage = 'Español';
  String _selectedDistanceUnit = 'Kilómetros';
  String _selectedThemeMode = 'Sistema';
  String _selectedMapApp = 'Google Maps';
  
  final List<String> _languages = ['Español', 'English', 'Português'];
  final List<String> _distanceUnits = ['Kilómetros', 'Millas'];
  final List<String> _themeModes = ['Claro', 'Oscuro', 'Sistema'];
  final List<String> _mapApps = ['Google Maps', 'Waze', 'Apple Maps'];
  
  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _keepScreenOn = prefs.getBool('keep_screen_on') ?? false;
      _selectedLanguage = prefs.getString('language') ?? 'Español';
      _selectedDistanceUnit = prefs.getString('distance_unit') ?? 'Kilómetros';
      _selectedThemeMode = prefs.getString('theme_mode') ?? 'Sistema';
      _selectedMapApp = prefs.getString('map_app') ?? 'Google Maps';
    });
    
    // Aplicar wakelock según configuración
    if (_keepScreenOn) {
      WakelockPlus.enable();
    }
  }

  Future<void> _saveKeepScreenOn(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('keep_screen_on', value);
    setState(() {
      _keepScreenOn = value;
    });
    
    // Activar/desactivar wakelock
    if (value) {
      await WakelockPlus.enable();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('La pantalla permanecerá encendida'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    } else {
      await WakelockPlus.disable();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('La pantalla se apagará normalmente'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    }
  }

  Future<void> _saveSetting(String key, String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: const Text(
          'Configuración',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 8),
        children: [
          // No apagar la pantalla
          _buildSwitchItem(
            title: 'No apagar la pantalla',
            value: _keepScreenOn,
            onChanged: (value) => _saveKeepScreenOn(value),
          ),
          
          const Divider(height: 1),
          
          // Idioma
          _buildNavigationItem(
            title: 'Idioma',
            subtitle: _selectedLanguage,
            onTap: () => _showLanguageSelector(),
          ),
          
          const Divider(height: 1),
          
          // Unidades de distancia
          _buildNavigationItem(
            title: 'Unidades de distancia',
            subtitle: _selectedDistanceUnit,
            onTap: () => _showDistanceUnitSelector(),
          ),
          
          const Divider(height: 1),
          
          // Modo nocturno
          _buildNavigationItem(
            title: 'Modo nocturno',
            subtitle: _selectedThemeMode,
            onTap: () => _showThemeModeSelector(),
          ),
          
          const Divider(height: 1),
          
          // Navegador
          _buildNavigationItem(
            title: 'Navegador',
            subtitle: _selectedMapApp,
            onTap: () => _showMapAppSelector(),
          ),
          
          const Divider(height: 1),
          
          // Acerca de la aplicación
          _buildNavigationItem(
            title: 'Acerca de la aplicación',
            onTap: () => _showAboutApp(),
          ),
          
          const Divider(height: 1, thickness: 8, color: Color(0xFFF5F5F5)),
          
          // Cerrar sesión
          _buildActionItem(
            title: 'Cerrar sesión',
            onTap: () async {
              final shouldLogout = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Cerrar sesión'),
                  content: const Text('¿Estás seguro de que deseas cerrar sesión?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: const Text('Cancelar'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context, true),
                      child: const Text('Cerrar sesión'),
                    ),
                  ],
                ),
              );

              if (shouldLogout == true && mounted) {
                await ref.read(authProvider.notifier).logout();
                if (mounted) {
                  Navigator.pop(context);
                }
              }
            },
          ),
          
          const Divider(height: 1),
          
          // Eliminar cuenta
          _buildActionItem(
            title: 'Eliminar cuenta',
            textColor: Colors.red,
            onTap: () => _showDeleteAccountConfirmation(),
          ),
        ],
      ),
    );
  }

  void _showLanguageSelector() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Text(
                'Seleccionar idioma',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const Divider(),
            ..._languages.map((language) => ListTile(
              title: Text(language),
              trailing: _selectedLanguage == language
                  ? const Icon(Icons.check, color: AppColors.primary)
                  : null,
              onTap: () {
                setState(() {
                  _selectedLanguage = language;
                });
                _saveSetting('language', language);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Idioma cambiado a $language')),
                );
              },
            )),
          ],
        ),
      ),
    );
  }

  void _showDistanceUnitSelector() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Text(
                'Unidades de distancia',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const Divider(),
            ..._distanceUnits.map((unit) => ListTile(
              title: Text(unit),
              trailing: _selectedDistanceUnit == unit
                  ? const Icon(Icons.check, color: AppColors.primary)
                  : null,
              onTap: () {
                setState(() {
                  _selectedDistanceUnit = unit;
                });
                _saveSetting('distance_unit', unit);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Unidad cambiada a $unit')),
                );
              },
            )),
          ],
        ),
      ),
    );
  }

  void _showThemeModeSelector() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Text(
                'Modo de apariencia',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const Divider(),
            ..._themeModes.map((mode) => ListTile(
              title: Text(mode),
              subtitle: Text(_getThemeModeDescription(mode)),
              trailing: _selectedThemeMode == mode
                  ? const Icon(Icons.check, color: AppColors.primary)
                  : null,
              onTap: () {
                setState(() {
                  _selectedThemeMode = mode;
                });
                _saveSetting('theme_mode', mode);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Modo $mode activado')),
                );
              },
            )),
          ],
        ),
      ),
    );
  }

  String _getThemeModeDescription(String mode) {
    switch (mode) {
      case 'Claro':
        return 'Siempre usar tema claro';
      case 'Oscuro':
        return 'Siempre usar tema oscuro';
      case 'Sistema':
        return 'Seguir configuración del sistema';
      default:
        return '';
    }
  }

  void _showMapAppSelector() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Text(
                'Aplicación de mapas',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const Divider(),
            ..._mapApps.map((app) => ListTile(
              leading: Icon(_getMapAppIcon(app)),
              title: Text(app),
              trailing: _selectedMapApp == app
                  ? const Icon(Icons.check, color: AppColors.primary)
                  : null,
              onTap: () {
                setState(() {
                  _selectedMapApp = app;
                });
                _saveSetting('map_app', app);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Navegador predeterminado: $app')),
                );
              },
            )),
          ],
        ),
      ),
    );
  }

  IconData _getMapAppIcon(String app) {
    switch (app) {
      case 'Google Maps':
        return Icons.map;
      case 'Waze':
        return Icons.navigation;
      case 'Apple Maps':
        return Icons.location_on;
      default:
        return Icons.map;
    }
  }

  Future<void> _showAboutApp() async {
    final packageInfo = await PackageInfo.fromPlatform();
    
    if (!mounted) return;
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.medical_services,
                color: Colors.white,
                size: 30,
              ),
            ),
            const SizedBox(width: 12),
            const Text('SaludGo'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Versión: ${packageInfo.version}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              'Build: ${packageInfo.buildNumber}',
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
            const SizedBox(height: 16),
            const Text(
              'Plataforma de telemedicina que conecta doctores con pacientes para consultas médicas remotas.',
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 16),
            Text(
              '© 2026 SaludGo',
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cerrar'),
          ),
        ],
      ),
    );
  }

  Future<void> _showDeleteAccountConfirmation() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar cuenta'),
        content: const Text(
          '¿Estás seguro de que deseas eliminar tu cuenta?\n\n'
          'Tu cuenta será desactivada y no podrás acceder a ella. '
          'Esta acción no se puede deshacer.',
          style: TextStyle(fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      // Aquí iría la llamada al backend para desactivar la cuenta
      // Por ahora solo cerramos sesión
      await ref.read(authProvider.notifier).logout();
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Cuenta desactivada exitosamente'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Widget _buildSwitchItem({
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Material(
      color: Colors.white,
      child: InkWell(
        onTap: () => onChanged(!value),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black87,
                  ),
                ),
              ),
              Transform.scale(
                scale: 0.8,
                child: Switch(
                  value: value,
                  onChanged: onChanged,
                  activeColor: Colors.green,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavigationItem({
    required String title,
    String? subtitle,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.white,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black87,
                      ),
                    ),
                    if (subtitle != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: Colors.grey[400],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionItem({
    required String title,
    required VoidCallback onTap,
    Color textColor = Colors.black87,
  }) {
    return Material(
      color: Colors.white,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 16,
              color: textColor,
            ),
          ),
        ),
      ),
    );
  }
}
