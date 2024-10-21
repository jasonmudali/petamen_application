import 'package:flutter/material.dart';
import 'package:aplikasi_petamen/pages/dashboard.dart';

void main() {
  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: Dashboard());
  }
}
