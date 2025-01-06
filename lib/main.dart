import 'package:auth/insta/screens/login_screen.dart';
import 'package:auth/providers/user_provider.dart';
import 'package:auth/responsive/mobile_screen_layout.dart';
import 'package:auth/responsive/responsive_layout_screen.dart';
import 'package:auth/responsive/web_screen_layout.dart';

import 'package:auth/utils/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

import 'insta/screens/profile_screen.dart';
void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  if(kIsWeb){
    await Firebase.initializeApp(
      options:  const FirebaseOptions(apiKey: "AIzaSyD7DFYg6RTt_519PNPiUIMUglZH5GxdZBo",
          appId: "1:437250826604:web:f98d665f7f73ba3f1e5349",
          messagingSenderId: "437250826604", projectId: "auth-2bffd",
          storageBucket: "auth-2bffd.appspot.com",),
    );
  }
  else {
    await Firebase.initializeApp(
    );
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Instagram Clone',
        theme : ThemeData.dark().copyWith(
          scaffoldBackgroundColor: mobileBackgroundColor,
        ),
          home: StreamBuilder(
            //1. idTokenChanges()
            //2. UserChanges() extra funct for updating password
            //authStateChanges() //this run only when users signIn or signOut
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.active) {
                if (snapshot.hasData) {
                  ProfileScreen(uid: snapshot.data!.uid);
                  return const ResponsiveLayout(
                    mobileScreenLayout: MobileScreenLayout(),
                    webScreenLayout: WebScreenLayout(),
                  );
                } else if (snapshot.hasError) {
                  return Center(child: Text('${snapshot.error}'));
                }
              }
              if(snapshot.connectionState == ConnectionState.waiting){
                return const Center(
                  child: CircularProgressIndicator(
                    color: primaryColor,
                  ),
                );
              }

              return const LoginScreen();
            },
          )),
    );
  }
}

// void main() async{
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp(
//     options: DefaultFirebaseOptions.currentPlatform
//   );
//    await NotificationService.initialize();
//
//
//   runApp(const MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//
//       debugShowCheckedModeBanner: false,
//       home: (FirebaseAuth.instance.currentUser != null)?Homescreentemp():LoginScreen(),
//     );
//   }
// }
