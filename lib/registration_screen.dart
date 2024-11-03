import 'package:flutter/material.dart';

class RegistrationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // Navigate to a specific page
            Navigator.pushNamed(context, '/home');
          },
          child: Text('Register'),
        ),
      ),
    );
  }
}
