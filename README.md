# Presupresto

¡Bienvenido/a! Este proyecto es una aplicación Flutter para gestión de presupuestos.

## Requisitos previos

- [Flutter SDK](https://docs.flutter.dev/get-started/install) (recomendado: última versión estable)
- [Dart SDK](https://dart.dev/get-dart) (incluido con Flutter)
- [Git](https://git-scm.com/)
- Un editor de código (recomendado: VS Code o Android Studio)
- Para Android: Android Studio y emulador configurado
- Para iOS (solo macOS): Xcode instalado

## Instalación

1. **Clona el repositorio:**
	 ```sh
	 git clone https://github.com/RobRojas930/presupresto.git
	 cd presupresto
	 ```

2. **Instala las dependencias:**
	 ```sh
	 flutter pub get
	 ```

3. **Configura plataformas (opcional):**
	 - Para Android: asegúrate de tener un emulador o dispositivo conectado.
	 - Para iOS: abre el proyecto en Xcode y resuelve permisos si es necesario.
	 - Para web: asegúrate de tener Chrome instalado.

## Ejecución

- **Android:**
	```sh
	flutter run -d android
	```
- **iOS:**
	```sh
	flutter run -d ios
	```
- **Web:**
	```sh
	flutter run -d chrome
	```

## Problemas comunes

- Si ves errores de Gradle, asegúrate de tener la versión correcta (ver mensajes en consola y actualiza si es necesario).
- Si tienes problemas con dependencias, ejecuta:
	```sh
	flutter clean
	flutter pub get
	```
- Para Android, asegúrate de aceptar las licencias de Android SDK:
	```sh
	flutter doctor --android-licenses
	```

## Comandos útiles

- Verifica tu entorno:
	```sh
	flutter doctor
	```
- Limpia el proyecto:
	```sh
	flutter clean
	```
- Actualiza dependencias:
	```sh
	flutter pub upgrade
	```

## Estructura del proyecto

- `lib/` — Código principal de la app
- `android/`, `ios/`, `web/`, `linux/`, `macos/`, `windows/` — Archivos de plataforma
- `assets/` — Imágenes y recursos
- `test/` — Pruebas unitarias y de widgets

## Contacto

Para dudas o sugerencias, abre un issue en GitHub o contacta a RobRojas930.

---
¡Listo para programar! 🚀

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
