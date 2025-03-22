import 'package:beauporientation/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import '../services/api_service.dart';
import '../routing/routes.dart';
import '../providers/runner_provider.dart';
import '../providers/teacherid_provider.dart';
import '../providers/course_provider.dart';

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
        SnackBar(
          content: Text('Please enter a valid code.'),
          backgroundColor: CustomColors.error,
        ),
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
          SnackBar(
            content: Text('Login successful.'),
            backgroundColor: CustomColors.success,
          ),
        );

        if (runner.isTeacher) {
          Provider.of<TeacherProvider>(context, listen: false).setTeacherId(runner.teacherId ?? 0);
          Provider.of<CourseProvider>(context, listen: false).setCourseId(runner.courseId);
          Navigator.pushNamed(context, AppRoutes.profHome);
        } else {
          Navigator.pushNamed(context, AppRoutes.eleveHome);
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Login failed. Please try again.'),
            backgroundColor: CustomColors.error,
          ),
        );
      }
    } catch (e) {
      Logger().e('An error occurred: $e');
      setState(() {
        isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('An error occurred. Please try again.'),
            backgroundColor: CustomColors.error
        ),
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
