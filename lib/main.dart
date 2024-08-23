import 'package:auth/screens/emails_auth/loginscreen.dart';
import 'package:auth/screens/notification_service.dart';
import 'package:auth/screens/phone_auth/sign_in_with_phone.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:auth/screens/homescreen.dart';



import 'package:flutter/material.dart';

import 'screens/homescreen.dart';
import 'screens/homescreenTemp.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  );
   await NotificationService.initialize();


  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(

      debugShowCheckedModeBanner: false,
      home: (FirebaseAuth.instance.currentUser != null)?Homescreentemp():LoginScreen(),
    );
  }
}

