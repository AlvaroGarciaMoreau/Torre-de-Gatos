import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/cat.dart';

enum GameState { waiting, playing, gameOver }

class GameManager extends ChangeNotifier {
  static const String _highScoreKey = 'high_score';
  
  List<Cat> cats = [];
  GameState gameState = GameState.waiting;
  int currentHeight = 0;
  int highScore = 0;
  double towerStability = 1.0; // 1.0 = perfectamente estable, 0.0 = completamente inestable
  Timer? _gameTimer;
  
  Cat? _nextCat;
  double _nextCatX = 200; // Posición X del próximo gato
  bool _movingRight = true;
  
  GameManager() {
    _loadHighScore();
    _initializeGame();
  }

  void _initializeGame() {
    cats.clear();
    currentHeight = 0;
    towerStability = 1.0;
    gameState = GameState.waiting;
    
    // Crear el primer gato (base)
    final baseCat = Cat.createRandomCat(200, 500);
    baseCat.isStable = true;
    cats.add(baseCat);
    
    // Crear el próximo gato
    _createNextCat();
    
    notifyListeners();
  }

  void _createNextCat() {
    _nextCat = Cat.createRandomCat(_nextCatX, 100);
    _nextCat!.isStable = false;
  }

  void startGame() {
    if (gameState == GameState.waiting) {
      gameState = GameState.playing;
      _startGameLoop();
      notifyListeners();
    }
  }

  void _startGameLoop() {
    _gameTimer = Timer.periodic(const Duration(milliseconds: 16), (timer) {
      _updateGame();
    });
  }

  void _updateGame() {
    if (gameState != GameState.playing) return;

    // Mover el próximo gato de lado a lado
    if (_nextCat != null) {
      if (_movingRight) {
        _nextCatX += 2;
        if (_nextCatX > 350) {
          _movingRight = false;
        }
      } else {
        _nextCatX -= 2;
        if (_nextCatX < 50) {
          _movingRight = true;
        }
      }
      _nextCat!.x = _nextCatX;
    }

    // Actualizar física de gatos inestables
    for (var cat in cats) {
      if (!cat.isStable) {
        cat.updatePhysics(0.016); // 60 FPS
      }
    }

    // Verificar estabilidad de la torre
    _checkTowerStability();

    // Verificar si algún gato se cayó
    _checkFallenCats();

    notifyListeners();
  }

  void dropCat() {
    if (gameState != GameState.playing || _nextCat == null) return;

    // Encontrar la posición Y correcta (encima del gato más alto)
    double highestY = cats.isEmpty ? 500 : cats.map((c) => c.y - c.height / 2).reduce(min);
    _nextCat!.y = highestY - _nextCat!.height / 2 - 5;

    // Verificar si el gato está bien posicionado sobre la torre
    bool isWellPositioned = _isGatWellPositioned(_nextCat!);
    
    if (isWellPositioned) {
      _nextCat!.isStable = true;
      cats.add(_nextCat!);
      currentHeight++;
      
      // Crear el siguiente gato
      _createNextCat();
      
      // Aumentar dificultad gradualmente
      _increaseDifficulty();
    } else {
      // El gato no está bien posicionado, cae
      _nextCat!.isStable = false;
      _nextCat!.velocityX = Random().nextDouble() * 200 - 100; // Velocidad aleatoria
      cats.add(_nextCat!);
      
      // Crear el siguiente gato
      _createNextCat();
      
      // La torre se vuelve inestable
      _destabilizeTower();
    }
  }

  bool _isGatWellPositioned(Cat cat) {
    if (cats.isEmpty) return true;
    
    // Encontrar el gato más alto de la torre estable
    Cat? topStableCat;
    double highestStableY = double.infinity;
    
    for (var c in cats) {
      if (c.isStable && c.y < highestStableY) {
        highestStableY = c.y;
        topStableCat = c;
      }
    }
    
    if (topStableCat == null) return false;
    
    // Verificar superposición horizontal
    double overlapThreshold = min(cat.width, topStableCat.width) * 0.3; // 30% de superposición mínima
    double horizontalDistance = (cat.x - topStableCat.x).abs();
    double maxDistance = (cat.width + topStableCat.width) / 2 - overlapThreshold;
    
    return horizontalDistance <= maxDistance;
  }

  void _checkTowerStability() {
    double totalInstability = 0;
    int stableCats = 0;
    
    for (var cat in cats) {
      if (cat.isStable) {
        stableCats++;
        // Calcular inestabilidad basada en la posición relativa
        if (stableCats > 1) {
          // Encontrar el gato debajo
          Cat? catBelow = _findCatBelow(cat);
          if (catBelow != null) {
            double horizontalOffset = (cat.x - catBelow.x).abs();
            double maxStableOffset = (cat.width + catBelow.width) / 4;
            totalInstability += (horizontalOffset / maxStableOffset).clamp(0.0, 1.0);
          }
        }
      }
    }
    
    towerStability = stableCats > 1 ? 1.0 - (totalInstability / (stableCats - 1)) : 1.0;
    towerStability = towerStability.clamp(0.0, 1.0);
    
    // Si la estabilidad es muy baja, la torre colapsa
    if (towerStability < 0.3) {
      _destabilizeTower();
    }
  }

  Cat? _findCatBelow(Cat cat) {
    Cat? catBelow;
    double closestDistance = double.infinity;
    
    for (var c in cats) {
      if (c != cat && c.isStable && c.y > cat.y) {
        double distance = c.y - cat.y;
        if (distance < closestDistance) {
          closestDistance = distance;
          catBelow = c;
        }
      }
    }
    
    return catBelow;
  }

  void _destabilizeTower() {
    final random = Random();
    
    for (var cat in cats) {
      if (cat.isStable) {
        cat.isStable = false;
        cat.velocityX = (random.nextDouble() - 0.5) * 200; // Velocidad horizontal aleatoria
        cat.velocityY = -random.nextDouble() * 100; // Pequeño impulso hacia arriba
      }
    }
    
    towerStability = 0;
  }

  void _checkFallenCats() {
    bool anyFallen = cats.any((cat) => cat.y > 600); // Si un gato cae fuera de la pantalla
    
    if (anyFallen && gameState == GameState.playing) {
      _endGame();
    }
  }

  void _increaseDifficulty() {
    // La dificultad aumenta haciendo que el próximo gato se mueva más rápido
    // Esto se puede implementar más tarde
  }

  void _endGame() {
    gameState = GameState.gameOver;
    _gameTimer?.cancel();
    
    if (currentHeight > highScore) {
      highScore = currentHeight;
      _saveHighScore();
    }
    
    notifyListeners();
  }

  void resetGame() {
    _gameTimer?.cancel();
    _initializeGame();
  }

  Future<void> _loadHighScore() async {
    final prefs = await SharedPreferences.getInstance();
    highScore = prefs.getInt(_highScoreKey) ?? 0;
    notifyListeners();
  }

  Future<void> _saveHighScore() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_highScoreKey, highScore);
  }

  Cat? get nextCat => _nextCat;

  @override
  void dispose() {
    _gameTimer?.cancel();
    super.dispose();
  }
}