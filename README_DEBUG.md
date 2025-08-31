# Gezin Boodschappen App — Debug Build

## Lokale debug APK bouwen
1. Installeer Flutter: https://docs.flutter.dev/get-started/install
2. Android SDK/Platform tools via Android Studio (minstens 1 Android emulator of apparaat).
3. In de projectmap:
   ```bash
   flutter pub get
   flutter build apk --debug
   ```
4. APK staat in `build/app/outputs/flutter-apk/app-debug.apk`.

## Codemagic (CI) — zonder lokale installatie
1. Maak een gratis account op https://codemagic.io
2. Maak een nieuwe app en koppel je GitHub-repo of upload dit project als zip.
3. Codemagic detecteert `codemagic.yaml` en bouwt automatisch een debug APK.
4. Download de APK vanuit de build-artifacts.

> Tip: Verwijder of vervang het e-mailadres in `codemagic.yaml` bij `publishing.email`.