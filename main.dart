
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:project/provider/provider.dart';
import 'package:project/screens/login_screen.dart';
import 'package:provider/provider.dart';

void main()async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const InstagramApp());
}


class InstagramApp extends StatelessWidget{
  const InstagramApp({super.key});

  @override
  Widget build(BuildContext context){
    return  MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => UserProvider(),)
      ],
      child: MaterialApp(
        theme: ThemeData(
          fontFamily: 'Lato'
        ),
        debugShowCheckedModeBanner: false,
          // home: StreamBuilder(
          //     stream: FirebaseAuth.instance.authStateChanges(),
          //     builder: (context, snapshot) {
          //       if(snapshot.connectionState == ConnectionState.active){
          //         if(snapshot.hasData){
          //           return const HomeView();
          //         }else if(snapshot.hasError){
          //           return Center(
          //             child: Text('${snapshot.error}'),
          //           );
          //         }
          //       }
          //       if(snapshot.connectionState == ConnectionState.waiting){
          //         return const Center(
          //           child: CircularProgressIndicator(),
          //         );
          //       }
          //       return const LoginScreen();
          //     },
          // )
        home: const LoginScreen(),
      ),
    );
  }
}