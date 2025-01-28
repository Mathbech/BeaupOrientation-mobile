import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/api_service.dart';
import '../routing/routes.dart';
import '../providers/runner_provider.dart';

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
      final runner = await ApiService().loginWithCode(code);

      setState(() {
        isLoading = false;
      });

      if (runner != null) {
        Provider.of<RunnerProvider>(context, listen: false).setRunner(runner);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Login successful.')),
        );

        if (runner.isTeacher) {
          Navigator.pushNamed(context, AppRoutes.profHome);
        } else {
          Navigator.pushNamed(context, AppRoutes.eleveHome);
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
                labelText: 'Code',
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
