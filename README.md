# VitalMovil 📱❤️

**Asistente virtual para toma de signos vitales** - Aplicación educativa y comunitaria desarrollada con Flutter.

## 🎯 Características

### Para Estudiantes:
- Simulaciones de toma de signos vitales
- Guías paso a paso
- Interpretación de resultados
- Historial de prácticas

### Para la Comunidad:
- Ingreso simple de valores
- Interpretación clara de resultados
- Ubicación de centros de salud cercanos
- Información sobre patologías comunes

## 🛠️ Tecnologías

- **Flutter** (Dart)
- **Firebase** (Auth, Firestore)
- **Google Maps API**
- **Geolocator**

## 📋 Setup

1. Clonar repositorio
```bash
git clone https://github.com/fabrizioangelica16-gif/VitalMovil.git
cd VitalMovil
```

2. Instalar dependencias
```bash
flutter pub get
```

3. Configurar Firebase
- Crear proyecto en Firebase Console
- Descargar credenciales
- Actualizar `lib/firebase_options.dart`

4. Configurar Google Maps
- Crear API Key en Google Cloud
- Agregar en `android/app/src/main/AndroidManifest.xml`
- Agregar en `ios/Runner/Info.plist`

5. Ejecutar
```bash
flutter run
```

## 📁 Estructura

```
lib/
├── main.dart
├── firebase_options.dart
├── screens/
│   └── home_screen.dart
├── models/
│   ├── vital_signs.dart
│   └── health_center.dart
└── services/
    ├── firebase_service.dart
    └── location_service.dart
```

## 📝 Interpretación Signos Vitales

- **PA Normal**: < 120/80 mmHg
- **Frecuencia Cardíaca Normal**: 60-100 lpm
- **Temperatura Normal**: 36.5 - 37.5°C
- **Saturación O2 Normal**: ≥ 95%

## 🚀 Próximas Features

- [ ] Pantalla de login/registro
- [ ] Formulario de ingreso de signos vitales
- [ ] Mapa interactivo con centros de salud
- [ ] Historial de mediciones
- [ ] Reportes PDF
- [ ] Notificaciones de alertas

## 👤 Autor

**Fabrizio Angelica** - [@fabrizioangelica16-gif](https://github.com/fabrizioangelica16-gif)

---

**¡Ayudando a cuidar la salud de la comunidad! ❤️📱**
