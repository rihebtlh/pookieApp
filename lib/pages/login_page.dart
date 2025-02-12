import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pookie/auth/auth_services.dart';
import 'package:pookie/pages/forgetPass.dart';
import 'package:pookie/pages/signup.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  void signUserIn() async {
    //show loading circle
    showDialog(context: context, builder: (context) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    });
    //try sign in
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      //pop the loading circle
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      //pop the loading circle
    Navigator.pop(context);
      //wrong EMAIL
      if(e.code == 'user-not-found'){
        //show error to user
        wrongEmailMessage();
      } 
      //wrong PASSWORD
      if (e.code == 'wrong-password'){
        wrongPasswordMessage();
      }
    }
  }
    // Wrong Email Message
  void wrongEmailMessage() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Error'),
          content: const Text('Incorrect Email'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  // Wrong Password Message
  void wrongPasswordMessage() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Error'),
          content: const Text('Incorrect Password'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/Hey.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Stack(
                children: [
                  Positioned(
                    top: 50,
                    left: 20,
                    child: Image.asset(
                      'assets/catr.png',
                      width: 100,
                      height: 100,
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 120),
                      const Text(
                        'Welcome back to POOKIE!',
                        style: TextStyle(color: Color(0xFF333333), fontSize: 16),
                      ),
                      const SizedBox(height: 30),

                      Container(
                        padding: const EdgeInsets.all(20), // Adds padding inside the container
                        margin: const EdgeInsets.symmetric(horizontal: 20), // Adds spacing from the screen edges
                        decoration: BoxDecoration(
                          color: Colors.white, // Background color of the container
                          borderRadius: BorderRadius.circular(15), // Rounded corners
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black12, // Soft shadow
                              blurRadius: 10,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: Column(
                        children: [
                        // Email TextField
                        TextField(
                          controller: emailController,
                          keyboardType: TextInputType.emailAddress, // Ensures email input
                          style: const TextStyle(color: Colors.black), // Set text color to black
                          decoration: InputDecoration(
                            hintText: 'Email',
                            hintStyle: const TextStyle(color: Colors.grey), // Hint text color
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(color: Colors.grey, width: 1), // Thin border
                            ),
                            filled: true,
                            fillColor: Colors.white, // Background color
                          ),
                        ),
                      const SizedBox(height: 15),

                      //password field
                        TextField(
                          controller: passwordController,
                          obscureText: true, // Ensures password is obscured
                          style: const TextStyle(color: Colors.black), // Set text color to black
                          decoration: InputDecoration(
                            hintText: 'Password',
                            hintStyle: const TextStyle(color: Colors.grey), // Hint text color
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(color: Colors.grey, width: 1), // Thin border
                            ),
                            filled: true,
                            fillColor: Colors.white, // Background color
                          ),
                        ),
                      const SizedBox(height: 10),


                      //forget password
                      
                        Padding(
  padding: const EdgeInsets.symmetric(horizontal: 25.0),
  child: Row(
    mainAxisAlignment: MainAxisAlignment.end, // Aligns to the right
    children: [
      GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) {
              return const forgetPasswordPage();
            }),
          );
        },
        child: const Text(
          'Forgot Password?',
          style: TextStyle(color: Colors.blue),
        ),
      ),
    ],
  ),
),

                      ],
                      ),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: signUserIn,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          padding: const EdgeInsets.symmetric(horizontal: 100, vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Sign In',
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ),
                      const SizedBox(height: 30),
                      const Text(
                        'Or continue with',
                        style: TextStyle(color: Colors.grey, fontSize: 14),
                      ),
                      const SizedBox(height: 20),
                      GestureDetector(
                        onTap: () => AuthServices().signInWithGoogle(),
                        child: Container(
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: Colors.grey),
                          ),
                          child: const Image(
                            image: AssetImage('assets/google.webp'),
                            height: 40,
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('Not a member? ', style: TextStyle(color: Colors.black)),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const SignUp()),
                              );
                            },
                            child: const Text(
                              'Register now',
                              style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}