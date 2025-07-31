import 'package:flutter/material.dart';
import 'package:habib_reminder/app.dart';
import 'package:habib_reminder/services.dart';

Future main() async {
  await initServices();
  runApp(const MyApp());
}
