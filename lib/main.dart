import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/runner_provider.dart';
import 'providers/teacherid_provider.dart';
import 'routing/routes.dart';
import './theme/theme.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => RunnerProvider()),
        ChangeNotifierProvider(create: (_) => TeacherProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Beaup\'orientation',
      theme: CustomTheme,
      initialRoute: AppRoutes.home,
      routes: AppRoutes.getRoutes(),
    );
  }
}