import 'dart:convert';
import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../routing/routes.dart';
import 'package:logger/logger.dart';
import '../shared/runner.dart'; // Importez Runner

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController codeController = TextEditingController();
  bool isLoading = false;

  Future<void> login() async {
    final code = codeController.text.trim();

    if (code.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter a valid code.')),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      final runner = await ApiService().loginWithCode(code); // Utilisez la méthode loginWithCode

      setState(() {
        isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Login successful.')),
      );

      if (runner != null) {
        if (runner.isTeacher) {
          Navigator.pushNamed(context, AppRoutes.profHome); // Redirigez vers la page d'accueil des enseignants
        } else {
          Navigator.pushNamed(context, AppRoutes.eleveHome); // Redirigez vers la page d'accueil des étudiants
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Login failed. Please try again.')),
        );
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred. Please try again.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: codeController,
              decoration: InputDecoration(
                labelText: 'Enter your code (e.g., Course1-12)',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            isLoading
                ? CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: login,
                    child: Text('Login'),
                  ),
          ],
        ),
      ),
    );
  }
}
