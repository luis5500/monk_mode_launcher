import 'package:flutter/material.dart';

import 'home_screen.dart';

/// Pantalla de bloqueo que se muestra cuando el usuario intenta abrir
/// una aplicación no permitida durante Monk Mode.
///
/// Diseño austero: fondo negro, texto blanco, sin iconos.
/// Navega de vuelta al launcher cuando el usuario pulsa el botón.
class BlockScreen extends StatelessWidget {
  const BlockScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 48.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Spacer(),
              // Mensaje principal: "ENFOQUE ACTIVO"
              const Text(
                'ENFOQUE ACTIVO',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.w300,
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(height: 32),
              // Texto secundario explicativo
              const Text(
                'Esta aplicación no está disponible durante tu bloque de trabajo.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xB3FFFFFF), // Blanco al 70% (255 * 0.7 ≈ 178)
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  height: 1.5,
                ),
              ),
              const Spacer(),
              // Botón para volver al launcher
              _BackToLauncherButton(),
              const SizedBox(height: 48),
            ],
          ),
        ),
      ),
    );
  }
}

/// Botón para volver al launcher. Borde blanco fino, sin sombras.
class _BackToLauncherButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navegar de vuelta al launcher, reemplazando la pantalla actual.
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => const HomeScreen()),
          (route) => false,
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white, width: 1),
          borderRadius: BorderRadius.zero,
        ),
        child: const Text(
          '[ VOLVER AL LAUNCHER ]',
          style: TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w400,
            letterSpacing: 1,
          ),
        ),
      ),
    );
  }
}
