import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileForm extends StatefulWidget {
  const ProfileForm({Key? key}) : super(key: key);

  @override
  _ProfileFormState createState() => _ProfileFormState();
}

class _ProfileFormState extends State<ProfileForm> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(40),
      ),
      constraints: const BoxConstraints(maxWidth: 480),
      padding: const EdgeInsets.only(top: 44),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 48), // Moved right by 2cm
                child: GestureDetector(
                  onTap: () {
                     Navigator.pushReplacementNamed(context, '/home'); // Make sure '/home' is defined in routes
                  },
                  child: Image.asset(
                    'assets/back.png',
                    width: 24,
                    height: 24,
                    semanticLabel: 'Profile icon',
                  ),
                ),
              ),
            const SizedBox(height: 60),
            Center(
              child: SizedBox(
                width: 322,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Align(
                      alignment: Alignment.bottomLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Text(
                          'First Name',
                          style: GoogleFonts.caveatBrush(
                            fontSize: 20,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      right: 0,
                      bottom: -8, // Moves the cat closer to the input field
                      child: Image.asset(
                        'assets/catice.png',
                        width: 61,
                        height: 77,
                        semanticLabel: 'Decorative image',
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Center(
              child: Container(
                width: 348,
                margin: const EdgeInsets.only(top: 6), // Reduced space
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFF64B8FF), width: 2),
                ),
                child: TextFormField(
                  controller: _firstNameController,
                  style: GoogleFonts.rubik(fontSize: 20),
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 50,
                      vertical: 22,
                    ),
                    border: InputBorder.none,
                    suffixIcon: Padding(
                      padding: const EdgeInsets.only(right: 35),
                      child: Image.asset(
                        'assets/editB.png',
                        width: 24,
                        height: 24,
                        semanticLabel: 'Edit icon',
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 80, top: 8),
              child: Text(
                'Last Name',
                style: GoogleFonts.caveatBrush(
                  fontSize: 20,
                  color: Colors.black,
                ),
              ),
            ),
            Center(
              child: Container(
                width: 348,
                margin: const EdgeInsets.only(top: 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFF64B8FF), width: 2),
                ),
                child: TextFormField(
                  controller: _lastNameController,
                  style: GoogleFonts.rubik(fontSize: 20),
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 37,
                      vertical: 22,
                    ),
                    border: InputBorder.none,
                    suffixIcon: Padding(
                      padding: const EdgeInsets.only(right: 37),
                      child: Image.asset(
                        'assets/editB.png',
                        width: 24,
                        height: 24,
                        semanticLabel: 'Edit icon',
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 80, top: 8),
              child: Text(
                'Email',
                style: GoogleFonts.caveatBrush(
                  fontSize: 20,
                  color: Colors.black,
                ),
              ),
            ),
            Center(
              child: Container(
                width: 348,
                margin: const EdgeInsets.only(top: 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFF64B8FF), width: 2),
                ),
                child: TextFormField(
                  controller: _emailController,
                  style: GoogleFonts.rubik(
                    fontSize: 20,
                    color: const Color(0xFF1E1E1E),
                  ),
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 35,
                      vertical: 20,
                    ),
                    border: InputBorder.none,
                    suffixIcon: Padding(
                      padding: const EdgeInsets.only(right: 35, top: 4),
                      child: Image.asset(
                        'assets/editB.png',
                        width: 24,
                        height: 24,
                        semanticLabel: 'Edit icon',
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 172),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    super.dispose();
  }
}