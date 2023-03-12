import 'package:flutter/material.dart';
import 'web_view.dart';

void main() {
  runApp(const MyApp());

}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override

  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shakib Sir',

      debugShowCheckedModeBanner: true,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const WebViewX(),
    );
  }
}
