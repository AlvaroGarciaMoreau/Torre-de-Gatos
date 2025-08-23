import 'package:flutter/material.dart';
import 'screens/game_screen.dart';

void main() {
  runApp(const TorreDeGatosApp());
}

class TorreDeGatosApp extends StatelessWidget {
  const TorreDeGatosApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Torre de Gatos',
      theme: ThemeData(
        primarySwatch: Colors.orange,
        fontFamily: 'Comic Sans MS',
      ),
      home: const GameScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}