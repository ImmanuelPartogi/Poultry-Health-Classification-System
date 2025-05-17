import 'package:flutter/material.dart';
import 'package:chicken_health_app/screens/home_screen.dart';
import 'package:chicken_health_app/theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Klasifikasi Kesehatan Ayam',
      theme: AppTheme.lightTheme(),
      home: const HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}