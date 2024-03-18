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
        primaryColor: Colors.red,
        brightness: Brightness.light,
        dividerColor: Colors.red.shade300,
        colorScheme: const ColorScheme.light(primary: Colors.red),
        primarySwatch: Colors.red,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.red,
          titleTextStyle: TextStyle(color: Colors.white),
        ),
      ),
      home: PasswordGenerator(),
    );
  }
}
