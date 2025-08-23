import 'package:flutter/material.dart';
import '../models/cat.dart';

class CatPainter extends CustomPainter {
  final Cat cat;
  final bool isNext;

  CatPainter(this.cat, {this.isNext = false});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = isNext ? cat.color.withOpacity(0.7) : cat.color
      ..style = PaintingStyle.fill;

    final strokePaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    canvas.save();
    
    // Aplicar rotación si el gato no es estable
    if (!cat.isStable) {
      canvas.translate(cat.x, cat.y);
      canvas.rotate(cat.rotation);
      canvas.translate(-cat.x, -cat.y);
    }

    // Cuerpo del gato (óvalo)
    final bodyRect = Rect.fromCenter(
      center: Offset(cat.x, cat.y),
      width: cat.width,
      height: cat.height,
    );
    canvas.drawOval(bodyRect, paint);
    canvas.drawOval(bodyRect, strokePaint);

    // Cabeza del gato (círculo más pequeño)
    final headRadius = cat.width * 0.25;
    final headCenter = Offset(cat.x, cat.y - cat.height * 0.3);
    canvas.drawCircle(headCenter, headRadius, paint);
    canvas.drawCircle(headCenter, headRadius, strokePaint);

    // Orejas (triángulos)
    final earPaint = Paint()
      ..color = cat.color.withOpacity(0.8)
      ..style = PaintingStyle.fill;

    // Oreja izquierda
    final leftEarPath = Path();
    leftEarPath.moveTo(headCenter.dx - headRadius * 0.6, headCenter.dy - headRadius * 0.3);
    leftEarPath.lineTo(headCenter.dx - headRadius * 0.3, headCenter.dy - headRadius * 1.2);
    leftEarPath.lineTo(headCenter.dx - headRadius * 0.1, headCenter.dy - headRadius * 0.3);
    leftEarPath.close();
    canvas.drawPath(leftEarPath, earPaint);
    canvas.drawPath(leftEarPath, strokePaint);

    // Oreja derecha
    final rightEarPath = Path();
    rightEarPath.moveTo(headCenter.dx + headRadius * 0.1, headCenter.dy - headRadius * 0.3);
    rightEarPath.lineTo(headCenter.dx + headRadius * 0.3, headCenter.dy - headRadius * 1.2);
    rightEarPath.lineTo(headCenter.dx + headRadius * 0.6, headCenter.dy - headRadius * 0.3);
    rightEarPath.close();
    canvas.drawPath(rightEarPath, earPaint);
    canvas.drawPath(rightEarPath, strokePaint);

    // Ojos
    final eyePaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.fill;

    canvas.drawCircle(
      Offset(headCenter.dx - headRadius * 0.3, headCenter.dy - headRadius * 0.2),
      3,
      eyePaint,
    );
    canvas.drawCircle(
      Offset(headCenter.dx + headRadius * 0.3, headCenter.dy - headRadius * 0.2),
      3,
      eyePaint,
    );

    // Nariz (triángulo pequeño)
    final nosePaint = Paint()
      ..color = Colors.pink
      ..style = PaintingStyle.fill;

    final nosePath = Path();
    nosePath.moveTo(headCenter.dx, headCenter.dy);
    nosePath.lineTo(headCenter.dx - 3, headCenter.dy + 5);
    nosePath.lineTo(headCenter.dx + 3, headCenter.dy + 5);
    nosePath.close();
    canvas.drawPath(nosePath, nosePaint);

    // Cola (si es visible)
    if (cat.isStable) {
      final tailPaint = Paint()
        ..color = cat.color
        ..style = PaintingStyle.stroke
        ..strokeWidth = 8
        ..strokeCap = StrokeCap.round;

      final tailPath = Path();
      tailPath.moveTo(cat.x + cat.width * 0.4, cat.y);
      tailPath.quadraticBezierTo(
        cat.x + cat.width * 0.7,
        cat.y - cat.height * 0.5,
        cat.x + cat.width * 0.5,
        cat.y - cat.height * 0.8,
      );
      canvas.drawPath(tailPath, tailPaint);
    }

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}