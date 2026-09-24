import 'package:flutter/material.dart';
import 'package:waqti/app/app.dart';
import 'package:waqti/core/di/injection_container.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await setupDependencies();

  runApp(const WaqtiApp());
}
