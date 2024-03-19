import 'package:flutter/material.dart';
import 'package:gitprueba/pages/LoginPage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primaryColor: Color.fromRGBO(58, 66, 86, 1.0),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: LoginPage(),
    );
  }
}
