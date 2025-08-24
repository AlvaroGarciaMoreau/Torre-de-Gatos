import 'package:flutter/material.dart';
import '../models/cat.dart';
import 'dart:ui' as ui;
import 'dart:async';


class CatPainter extends CustomPainter {
  final Cat cat;
  final bool isNext;
  static ui.Image? _catImage;

  CatPainter(this.cat, {this.isNext = false});

  // Cargar la imagen solo una vez
  static Future<void> loadCatImage(BuildContext context) async {
    if (_catImage != null) return;
  const imageProvider = AssetImage('assets/images/gato1.png');
    final completer = Completer<ui.Image>();
    final stream = imageProvider.resolve(ImageConfiguration.empty);
    stream.addListener(ImageStreamListener((ImageInfo info, bool _) {
      completer.complete(info.image);
    }));
    _catImage = await completer.future;
  }

  @override
  void paint(Canvas canvas, Size size) {
    if (_catImage == null) {
      // Si la imagen no está cargada, dibuja un placeholder
      final paint = Paint()
        ..color = Colors.grey
        ..style = PaintingStyle.fill;
      canvas.drawOval(
        Rect.fromCenter(center: Offset(cat.x, cat.y), width: cat.width, height: cat.height),
        paint,
      );
      return;
    }

    canvas.save();
    if (!cat.isStable) {
      canvas.translate(cat.x, cat.y);
      canvas.rotate(cat.rotation);
      canvas.translate(-cat.x, -cat.y);
    }

    // Dibuja la imagen escalada al tamaño del gato
    final dstRect = Rect.fromCenter(
      center: Offset(cat.x, cat.y),
      width: cat.width,
      height: cat.height,
    );
    paintImage(
      canvas: canvas,
      rect: dstRect,
      image: _catImage!,
      fit: BoxFit.fill,
    );

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}