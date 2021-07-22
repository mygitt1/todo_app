import 'package:flutter/material.dart';
import 'package:todo_app/auth/authform.dart';

class AuthScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [
            Colors.brown.shade900,
            Colors.brown.shade50,
          ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
        ),
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AuthForm(),
          ],
        ),
      ),
    );
  }
}
