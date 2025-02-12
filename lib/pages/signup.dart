import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pookie/pages/login_page.dart';
import 'package:pookie/auth/auth_services.dart';
import 'package:pookie/pages/home.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final nameController = TextEditingController();
  final ageController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    ageController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  void signUserUp() async {
    // Show loading indicator
    showDialog(
      context: context,
      builder: (context) {
        return const Center(child: CircularProgressIndicator());
      },
    );
    try {
      // Create user
      if(passwordConfirmed()){
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
      // Update user profile with name
      addUserDetails(
        nameController.text.trim(),
        int.parse(ageController.text.trim()),
        emailController.text.trim(),
        );
      }
      // Close the loading indicator
      Navigator.pop(context);
      // Navigate to Home Page after successful sign-up
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context); // Close loading

      if (e.code == 'email-already-in-use') {
        showErrorMessage("Email is already in use.");
      } else if (e.code == 'weak-password') {
        showErrorMessage("Password is too weak.");
      } else {
        showErrorMessage(e.message ?? "An error occurred.");
      }
    }
  }

  bool passwordConfirmed() {
    if(passwordController.text.trim() == confirmPasswordController.text.trim()){
      return true;
    } else {
      return false;
    }
  }
  void showErrorMessage(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(message),
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
  Future addUserDetails(String name, int age, String email) async {
    await FirebaseFirestore.instance.collection('users').add({
      'name': name,
      'age': age,
      'email': email,
    });
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
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Top-right image
                  Align(
                    alignment: Alignment.topRight,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 20.0, top: 40.0),
                      child: Image.asset(
                        'assets/catr.png',
                        width: 100,
                        height: 100,
                      ),
                    ),
                  ),

                  const SizedBox(height: 1),

                  // Welcome text
                  const Text(
                    'Hello to POOKIE!',
                    style: TextStyle(
                      color: Color(0xFF333333),
                      fontSize: 18,
                    ),
                  ),

                  const SizedBox(height: 5),

                  
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

                        // Name TextField
                        TextField(
                          controller: nameController,
                          style: const TextStyle(color: Colors.black), // Set the text color to black
                          decoration: InputDecoration(
                            hintText: 'Name',
                            hintStyle: const TextStyle(color: Colors.grey), // Hint text color
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(color: Colors.grey, width: 1), // Thin border
                            ),
                            filled: true,
                            fillColor: Colors.white,
                          ),
                        ),

                        const SizedBox(height: 5),

                        // Age TextField
                        TextField(
                          controller: ageController,
                          keyboardType: TextInputType.number, // Ensures numeric input
                          style: const TextStyle(color: Colors.black), // Set text color to black
                          decoration: InputDecoration(
                            hintText: 'Age',
                            hintStyle: const TextStyle(color: Colors.grey), // Hint text color
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(color: Colors.grey, width: 1), // Thin border
                            ),
                            filled: true,
                            fillColor: Colors.white, // Background color
                          ),
                        ),


                        const SizedBox(height: 5),

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


                        const SizedBox(height: 5),

                        // Password TextField
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


                        const SizedBox(height: 5),

                        // Confirm Password TextField
                        TextField(
                          controller: confirmPasswordController,
                          obscureText: true, // Ensures password is obscured
                          style: const TextStyle(color: Colors.black), // Set text color to black
                          decoration: InputDecoration(
                            hintText: 'Confirm Password',
                            hintStyle: const TextStyle(color: Colors.grey), // Hint text color
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(color: Colors.grey, width: 1), // Thin border
                            ),
                            filled: true,
                            fillColor: Colors.white, // Background color
                          ),
                        ),

                        const SizedBox(height: 5),

                        // Terms and Conditions
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {
                              // Add terms and conditions logic
                            },
                            child: const Text(
                              'Terms and Conditions',
                              style: TextStyle(color: Colors.blue),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 8),

                  // Sign up button
                  ElevatedButton(
                    onPressed: signUserUp,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding: const EdgeInsets.symmetric(horizontal: 100, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Sign Up',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),

                  const SizedBox(height: 5),

                  // Or continue with
                  const Text(
                    'Or continue with',
                    style: TextStyle(color: Colors.grey, fontSize: 14),
                  ),

                  const SizedBox(height: 10),

                  // Google button
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
                        //color: Colors.grey,
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  // Already have an account? Login
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Already have an account? ',
                        style: TextStyle(color: Colors.black),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const LoginPage()),
                          );
                        },
                        child: const Text(
                          'Login',
                          style: TextStyle(color: Colors.blue),
                        ),
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
