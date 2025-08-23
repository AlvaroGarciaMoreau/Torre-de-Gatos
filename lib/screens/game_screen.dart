import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../game/game_manager.dart';
import '../widgets/cat_painter.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late GameManager gameManager;

  @override
  void initState() {
    super.initState();
    gameManager = GameManager();
    gameManager.addListener(_onGameStateChanged);
  }

  void _onGameStateChanged() {
    setState(() {});
    
    // Vibrar cuando el juego termina
    if (gameManager.gameState == GameState.gameOver) {
      HapticFeedback.heavyImpact();
    }
  }

  @override
  void dispose() {
    gameManager.removeListener(_onGameStateChanged);
    gameManager.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF87CEEB), // Azul cielo
      body: SafeArea(
        child: Stack(
          children: [
            // Fondo con nubes
            _buildBackground(),
            
            // Área de juego
            GestureDetector(
              onTap: _handleTap,
              child: Container(
                width: double.infinity,
                height: double.infinity,
                child: CustomPaint(
                  painter: GamePainter(gameManager),
                ),
              ),
            ),
            
            // UI superior
            _buildTopUI(),
            
            // UI de juego terminado
            if (gameManager.gameState == GameState.gameOver)
              _buildGameOverOverlay(),
              
            // UI de inicio
            if (gameManager.gameState == GameState.waiting)
              _buildStartOverlay(),
          ],
        ),
      ),
    );
  }

  Widget _buildBackground() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF87CEEB), // Azul cielo claro
            Color(0xFF98FB98), // Verde claro (pasto)
          ],
          stops: [0.7, 1.0],
        ),
      ),
      child: Stack(
        children: [
          // Nubes decorativas
          Positioned(
            top: 50,
            left: 50,
            child: _buildCloud(),
          ),
          Positioned(
            top: 100,
            right: 80,
            child: _buildCloud(),
          ),
          Positioned(
            top: 150,
            left: 150,
            child: _buildCloud(),
          ),
        ],
      ),
    );
  }

  Widget _buildCloud() {
    return Container(
      width: 80,
      height: 40,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.8),
        borderRadius: BorderRadius.circular(20),
      ),
    );
  }

  Widget _buildTopUI() {
    return Positioned(
      top: 20,
      left: 20,
      right: 20,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Altura actual
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.9),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.pets, color: Colors.orange),
                const SizedBox(width: 8),
                Text(
                  'Altura: ${gameManager.currentHeight}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
          
          // Récord
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.amber.withOpacity(0.9),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.emoji_events, color: Colors.orange),
                const SizedBox(width: 8),
                Text(
                  'Récord: ${gameManager.highScore}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStartOverlay() {
    return Container(
      color: Colors.black.withOpacity(0.5),
      child: Center(
        child: Container(
          margin: const EdgeInsets.all(40),
          padding: const EdgeInsets.all(30),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                '🐱 Torre de Gatos 🐱',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.orange,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              const Text(
                '¡Apila los gatos lo más alto que puedas!\n\nToca la pantalla para soltar cada gato.\nTrata de mantener el equilibrio.',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  gameManager.startGame();
                  HapticFeedback.lightImpact();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                child: const Text(
                  'COMENZAR',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGameOverOverlay() {
    final isNewRecord = gameManager.currentHeight == gameManager.highScore && gameManager.currentHeight > 0;
    
    return Container(
      color: Colors.black.withOpacity(0.5),
      child: Center(
        child: Container(
          margin: const EdgeInsets.all(40),
          padding: const EdgeInsets.all(30),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                isNewRecord ? '🎉 ¡NUEVO RÉCORD! 🎉' : '😿 ¡Se cayeron los gatos! 😿',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: isNewRecord ? Colors.green : Colors.red,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Text(
                'Altura alcanzada: ${gameManager.currentHeight}',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Mejor récord: ${gameManager.highScore}',
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      gameManager.resetGame();
                      HapticFeedback.lightImpact();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: const Text(
                      'JUGAR DE NUEVO',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleTap() {
    if (gameManager.gameState == GameState.playing) {
      gameManager.dropCat();
      HapticFeedback.lightImpact();
    }
  }
}

class GamePainter extends CustomPainter {
  final GameManager gameManager;

  GamePainter(this.gameManager);

  @override
  void paint(Canvas canvas, Size size) {
    // Dibujar línea del suelo
    final groundPaint = Paint()
      ..color = Colors.brown
      ..strokeWidth = 4;
    
    canvas.drawLine(
      Offset(0, size.height - 50),
      Offset(size.width, size.height - 50),
      groundPaint,
    );

    // Dibujar todos los gatos de la torre
    for (final cat in gameManager.cats) {
      final catPainter = CatPainter(cat);
      catPainter.paint(canvas, size);
    }

    // Dibujar el próximo gato
    if (gameManager.nextCat != null && gameManager.gameState == GameState.playing) {
      final nextCatPainter = CatPainter(gameManager.nextCat!, isNext: true);
      nextCatPainter.paint(canvas, size);
    }

    // Dibujar indicador de estabilidad
    if (gameManager.gameState == GameState.playing) {
      _drawStabilityIndicator(canvas, size);
    }
  }

  void _drawStabilityIndicator(Canvas canvas, Size size) {
    final stability = gameManager.towerStability;
    final barWidth = 200.0;
    final barHeight = 20.0;
    final barX = (size.width - barWidth) / 2;
    final barY = size.height - 100;

    // Fondo de la barra
    final backgroundPaint = Paint()
      ..color = Colors.black.withOpacity(0.3)
      ..style = PaintingStyle.fill;
    
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(barX, barY, barWidth, barHeight),
        const Radius.circular(10),
      ),
      backgroundPaint,
    );

    // Barra de estabilidad
    final stabilityColor = Color.lerp(Colors.red, Colors.green, stability)!;
    final stabilityPaint = Paint()
      ..color = stabilityColor
      ..style = PaintingStyle.fill;
    
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(barX, barY, barWidth * stability, barHeight),
        const Radius.circular(10),
      ),
      stabilityPaint,
    );

    // Texto de estabilidad
    final textPainter = TextPainter(
      text: TextSpan(
        text: 'Estabilidad',
        style: TextStyle(
          color: Colors.white,
          fontSize: 14,
          fontWeight: FontWeight.bold,
          shadows: [
            Shadow(
              color: Colors.black.withOpacity(0.5),
              offset: const Offset(1, 1),
              blurRadius: 2,
            ),
          ],
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    
    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(barX + (barWidth - textPainter.width) / 2, barY - 25),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}