import 'package:flutter/material.dart';

class BackgroundScaffold extends StatelessWidget {
  final PreferredSizeWidget? appBar;
  final Widget body;
  final Widget? floatingActionButton;
  final Widget? bottomNavigationBar;
  final Color? backgroundColor;
  final bool showBackground;

  const BackgroundScaffold({
    super.key,
    this.appBar,
    required this.body,
    this.floatingActionButton,
    this.bottomNavigationBar,
    this.backgroundColor,
    this.showBackground = true,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      floatingActionButton: floatingActionButton,
      bottomNavigationBar: bottomNavigationBar,
      body: Container(
        decoration: showBackground
            ? const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/fondo.png'),
                  fit: BoxFit.cover,
                  opacity: 0.3, // Hace el fondo más claro
                ),
              )
            : null,
        child: Container(
          color: backgroundColor ?? Colors.white.withOpacity(0.7), // Capa blanca transparente
          child: body,
        ),
      ),
    );
  }
}
