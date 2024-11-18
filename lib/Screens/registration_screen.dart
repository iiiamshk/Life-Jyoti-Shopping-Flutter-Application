import 'package:flutter/material.dart';

class RegistrationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Hero(
                tag: 'logo', 
                child: Image.asset('assets/logo.png'),
              ),
              TextField(),
              TextField(),
              TextField(),
              TextField(),
            ],

          ),
        ),
      ),
      
    );
  }
}