# Torre de Gatos 🐱

Un divertido juego móvil desarrollado en Flutter donde debes apilar gatos uno encima de otro hasta que pierdan el equilibrio.

## 🎮 Características del Juego

- **Mecánica Simple**: Toca la pantalla para soltar cada gato
- **Física Realista**: Los gatos caen con gravedad y pueden perder el equilibrio
- **Sistema de Puntuación**: Guarda tu altura máxima alcanzada
- **Indicador de Estabilidad**: Muestra qué tan estable está tu torre
- **Gatos Únicos**: Cada gato tiene colores y tamaños ligeramente diferentes
- **Efectos Visuales**: Animaciones suaves y feedback háptico

## 🚀 Cómo Jugar

1. **Inicio**: Presiona "COMENZAR" para empezar el juego
2. **Apilar**: Toca la pantalla para soltar el gato que se mueve de lado a lado
3. **Equilibrio**: Trata de mantener los gatos bien alineados para evitar que se caigan
4. **Objetivo**: Alcanza la mayor altura posible antes de que la torre colapse

## 🛠️ Instalación y Desarrollo

### Prerrequisitos
- Flutter SDK (>=3.10.0)
- Dart SDK (>=3.0.0)
- Android Studio o VS Code
- Dispositivo Android o emulador

### Configuración del Proyecto

1. **Clonar el repositorio**:
   ```bash
   git clone <repository-url>
   cd Torre-de-Gatos
   ```

2. **Instalar dependencias**:
   ```bash
   flutter pub get
   ```

3. **Ejecutar el juego**:
   ```bash
   flutter run
   ```

### Dependencias Principales

- `flutter`: Framework principal
- `shared_preferences`: Para guardar el récord del jugador
- `cupertino_icons`: Iconos de iOS

## 🏗️ Arquitectura del Proyecto

```
lib/
├── main.dart                 # Punto de entrada de la aplicación
├── models/
│   └── cat.dart             # Modelo del gato con propiedades físicas
├── game/
│   └── game_manager.dart    # Lógica principal del juego
├── widgets/
│   └── cat_painter.dart     # Widget personalizado para dibujar gatos
└── screens/
    └── game_screen.dart     # Pantalla principal del juego
```

## 🎨 Características Técnicas

### Física del Juego
- **Gravedad**: Los gatos caen con aceleración realista
- **Colisiones**: Detección de superposición entre gatos
- **Estabilidad**: Cálculo dinámico de la estabilidad de la torre
- **Rotación**: Los gatos rotan al caer para mayor realismo

### Renderizado
- **Custom Painter**: Dibujado personalizado de gatos con Canvas
- **Animaciones**: 60 FPS para movimientos suaves
- **Efectos Visuales**: Gradientes, sombras y transparencias

### Persistencia
- **SharedPreferences**: Guarda el récord máximo del jugador
- **Estado del Juego**: Manejo de estados (esperando, jugando, game over)

## 🎯 Mecánicas de Juego

### Sistema de Estabilidad
- La estabilidad se calcula basada en la alineación de los gatos
- Una torre inestable (< 30% estabilidad) colapsa automáticamente
- El indicador visual muestra el estado actual de la torre

### Generación de Gatos
- Cada gato tiene propiedades aleatorias (color, tamaño)
- Los gatos se mueven horizontalmente antes de ser soltados
- La dificultad puede aumentar con la altura

### Condiciones de Victoria/Derrota
- **Victoria**: No hay límite, el objetivo es superar tu propio récord
- **Derrota**: Cuando cualquier gato cae fuera de la pantalla

## 🔧 Personalización

### Agregar Nuevos Colores de Gatos
Edita el array `colors` en `cat.dart`:
```dart
final colors = [
  Colors.orange,
  Colors.grey,
  Colors.brown,
  // Agregar más colores aquí
];
```

### Modificar la Física
Ajusta los parámetros en `game_manager.dart`:
```dart
velocityY += 980 * deltaTime; // Cambiar gravedad
double overlapThreshold = min(cat.width, topStableCat.width) * 0.3; // Cambiar tolerancia
```

## 📱 Compilación para Android

```bash
flutter build apk --release
```

El APK se generará en: `build/app/outputs/flutter-apk/app-release.apk`

## 🐛 Solución de Problemas

### Problemas Comunes
1. **Error de dependencias**: Ejecuta `flutter clean` y luego `flutter pub get`
2. **Problemas de renderizado**: Verifica que el dispositivo soporte OpenGL ES 2.0+
3. **Rendimiento lento**: Usa un dispositivo físico en lugar del emulador

## 🤝 Contribuciones

¡Las contribuciones son bienvenidas! Algunas ideas para mejoras:

- [ ] Efectos de sonido
- [ ] Diferentes tipos de gatos (con habilidades especiales)
- [ ] Power-ups y bonificaciones
- [ ] Modo multijugador
- [ ] Temas y fondos personalizables
- [ ] Logros y estadísticas

## 📄 Licencia

Este proyecto está bajo la Licencia MIT. Ver el archivo `LICENSE` para más detalles.

## 🎉 Créditos

Desarrollado con ❤️ usando Flutter.

---

¡Disfruta apilando gatos! 🐱🏗️