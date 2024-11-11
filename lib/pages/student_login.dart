import 'package:beauporientation/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';

class StudentLoginPage extends StatefulWidget {
  @override
  _StudentLoginPageState createState() => _StudentLoginPageState();
}

class _StudentLoginPageState extends State<StudentLoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _codeEleveController = TextEditingController();
  final TextEditingController _codeCourseController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Connexion à l\'interface Professeur',
        showMenuButton: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                controller: _codeEleveController,
                decoration: InputDecoration(labelText: 'Code éleve'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Merci d\'entrer votre code élève';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _codeCourseController,
                decoration: InputDecoration(labelText: 'Code course'),
                obscureText: false,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Merci d\'entrer votre code course';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // Perform login action
                  }
                },
                child: Text('Connexion'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}