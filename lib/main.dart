import 'package:flutter/material.dart';
import 'package:password_generator/views/widgets/PasswordGenerator.dart';

void main() {
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Password Generator',
      theme: ThemeData(
        primarySwatch: Colors.red,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.red,
          titleTextStyle: TextStyle(color: Colors.white),
        ),
      ),
      home: PasswordGenerator(),
    );
  }
}
