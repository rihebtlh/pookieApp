
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:pookie/pages/login_page.dart';
import 'package:pookie/pages/profile.dart';
import 'package:pookie/pages/terms_conditions.dart';
import 'package:pookie/pages/user_profile.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool notificationsEnabled = true;

  @override
  Widget build(BuildContext context) {
    // Get user profile from provider and listen for changes
    final userProfileProvider = Provider.of<UserProfileProvider>(context);
    final userProfile = userProfileProvider.profile;
    final isLoading = userProfileProvider.isLoading;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/Setting.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: isLoading 
            ? const Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  // Back button and Title
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        IconButton(
                          icon: const Icon(Ionicons.chevron_back, color: Colors.black),
                          onPressed: () => Navigator.pop(context),
                        ),
                        const Text(
                          'Settings',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 15, 15, 15),
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 100),
                  
                  // User info card 
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 245, 220, 248),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        // Profile Picture Circle
                        Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: const Color.fromARGB(255, 237, 191, 237),
                              width: 2,
                            ),
                            color: Colors.white,
                          ),
                          child: ClipOval(
                            child: Padding(
                              padding: const EdgeInsets.all(5),
                              child: Image.asset(
                                userProfile.profilePicture,
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        ),
                        
                        const SizedBox(width: 15),
                        
                        // User Info
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                userProfile.fullName,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromARGB(255, 15, 15, 15),
                                ),
                              ),
                              Text(
                                userProfile.email,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Color.fromARGB(255, 79, 78, 78),
                                ),
                              ),
                            ],
                          ),
                        ),
                        
                        // Edit Button
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.white),
                          onPressed: () {
                            // Navigate to profile page using the class directly
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const ProfilePage()),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 30),
                  
                  // Notifications toggle
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 220, 233, 244),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Turn off Notifications',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Color.fromARGB(255, 15, 15, 15),
                          ),
                        ),
                        Switch(
                          value: notificationsEnabled,
                          onChanged: (value) {
                            setState(() {
                              notificationsEnabled = value;
                            });
                          },
                          activeColor: Colors.white,
                          activeTrackColor: const Color.fromARGB(255, 241, 178, 199),
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 30),
                  
                  // Terms of Service container
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 235, 249, 217),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: InkWell(
                      onTap: () {
                        // Navigate to Terms page using the class directly
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const TermsConditions(fromScreen: 'settings'),
                          ),
                        );
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Terms of Service',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Color.fromARGB(255, 15, 15, 15),
                            ),
                          ),
                          Icon(Ionicons.chevron_forward, color: Colors.black),
                        ],
                      ),
                    ),
                  ),
                  
                  const Spacer(),
                  
                  // Logout button with Firebase sign out
                  Align(
                    alignment: Alignment.center,
                    child: Container(
                      width: 120,
                      margin: const EdgeInsets.only(bottom: 220),
                      child: ElevatedButton(
                        onPressed: () async {
                          // Sign out with Firebase
                          await FirebaseAuth.instance.signOut();
                          // Navigate to login screen
                          Navigator.pushReplacement(
                          context,
                            MaterialPageRoute(builder: (context) => const LoginPage()),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(255, 245, 220, 248),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: const Text(
                          'LogOut',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 15, 15, 15),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
          ),
        ),
      );
  }
}
