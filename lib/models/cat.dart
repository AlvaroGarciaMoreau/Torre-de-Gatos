import 'dart:math';
import 'package:flutter/material.dart';

class Cat {
  final String id;
  final Color color;
  final double width;
  final double height;
  double x;
  double y;
  double velocityX;
  double velocityY;
  double rotation;
  bool isStable;
  
  Cat({
    required this.id,
    required this.color,
    required this.width,
    required this.height,
    required this.x,
    required this.y,
    this.velocityX = 0,
    this.velocityY = 0,
    this.rotation = 0,
    this.isStable = true,
  });

  static Cat createRandomCat(double x, double y) {
    final random = Random();
    final colors = [
      Colors.orange,
      Colors.grey,
      Colors.brown,
      Colors.black,
      Colors.white,
      Colors.amber,
      Colors.deepOrange,
    ];
    
    return Cat(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      color: colors[random.nextInt(colors.length)],
      width: 60 + random.nextDouble() * 20, // 60-80 pixels
      height: 40 + random.nextDouble() * 10, // 40-50 pixels
      x: x,
      y: y,
    );
  }

  void updatePhysics(double deltaTime) {
    if (!isStable) {
      // Aplicar gravedad
      velocityY += 980 * deltaTime; // 980 pixels/s²
      
      // Actualizar posición
      x += velocityX * deltaTime;
      y += velocityY * deltaTime;
      
      // Actualizar rotación
      rotation += velocityX * deltaTime * 0.01;
    }
  }

  Rect get bounds => Rect.fromLTWH(x - width / 2, y - height / 2, width, height);
  
  Offset get center => Offset(x, y);
}