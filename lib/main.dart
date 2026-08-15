import 'package:flutter/material.dart';
import 'auth_page.dart';
import 'home_shell.dart';

void main() => runApp(const VimarkApp());

class VimarkApp extends StatelessWidget {
  const VimarkApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'VIMARK',
    debugShowCheckedModeBanner: false,
    theme: ThemeData(useMaterial3: true, colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF087F5B))),
    home: const AuthPage(),
  );
}

