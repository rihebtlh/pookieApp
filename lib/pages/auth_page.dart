import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pookieapp/pages/login_page.dart';
import 'package:pookieapp/pages/home.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),//if the user is logged in or not
        builder: (context, snapshot){
          if(snapshot.hasData){
            return const HomePage();
          }
          else {
            return const LoginPage();
          }
      }
      ),
    );
  }
}