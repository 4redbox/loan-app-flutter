import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'services/home_screen.dart';

void main() async{

  WidgetsFlutterBinding.ensureInitialized();


  if (kIsWeb) {
    await Firebase.initializeApp(options: FirebaseOptions(
      apiKey: "AIzaSyA6B5vFPd2SvIs7MfbTGFuzzwtZdAda3Bo",
      authDomain: "simple-app-notify.firebaseapp.com",
      projectId: "simple-app-notify",
      storageBucket: "simple-app-notify.firebasestorage.app",
      messagingSenderId: "780986996030",
      appId: "1:780986996030:web:9fa10ba7d3c0e1203e486f"));
    runApp(const MyApp());
  }else {
    await Firebase.initializeApp();
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Data Loader App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomeScreen(),
    );
  }
}