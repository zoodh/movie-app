import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moviesapp/routes/routes.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: 'AIzaSyDEAwVwvb359LCqioOnHoZQN71tW4WrGJM',
      appId: '1:1081857925062:android:1e2ac4f7f2ebc1d7b81cc7',
      messagingSenderId: '1081857925062',
      projectId: 'aflami-908c6',
    ),
  );
  runApp(const ProviderScope(child: MyApp()));
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
        routerConfig: router,
        title: "Go router",
      theme: ThemeData(
        primaryColor: Colors.deepPurple,
        primarySwatch: Colors.blue,
      ),
    );
  }
}