import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:projet_carnet_de_depenses/pages/home.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  initLocalStorage();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Carnet de Depenses app',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHome(),
    );
  }
}

