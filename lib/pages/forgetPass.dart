import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class forgetPasswordPage extends StatefulWidget {
  const forgetPasswordPage({super.key});

  @override
  State<forgetPasswordPage> createState() => _forgetPasswordPageState();
}

class _forgetPasswordPageState extends State<forgetPasswordPage> {
  final emailController = TextEditingController();

  @override
  void dispose(){
    emailController.dispose();
    super.dispose();
  }
  Future passwordReset() async {
    try {
      await FirebaseAuth.instance
        .sendPasswordResetEmail(email: emailController.text.trim());
      showDialog(context: context, builder: (context){
          return const AlertDialog(
            content: Text('Password reset link sent! Check your email'),
          );
       });
    } on FirebaseAuthException catch(e){
      print(e);
       showDialog(context: context, builder: (context){
          return AlertDialog(
            content: Text(e.message.toString()),
          );
       });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/Hey.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          
          // Foreground Content
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 25.0),
                  child: Text(
                    'Enter your email and we will send you a password reset link',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18.0,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30.0),
                  child: TextField(
                    controller: emailController,
                    decoration: InputDecoration(
                      hintText: 'Email',
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.blue),
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                MaterialButton(
                  onPressed: () {
                    passwordReset();  // Pass the function call inside a closure
                  },
                  color: Colors.blue,
                  child: const Text('Reset Password'),
                )

              ],
            ),
          ),
        ],
      ),
    );
  }
}
