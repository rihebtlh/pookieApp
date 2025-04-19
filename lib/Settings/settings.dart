import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:pookie/pages/login_page.dart';
import 'package:pookie/pages/profile.dart';
import 'package:pookie/pages/quiz/quiz_score__provider.dart';
import 'package:pookie/pages/quiz/quiz_screen.dart';
import 'package:pookie/pages/terms_conditions.dart';
import 'package:pookie/pages/user_profile.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

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
    
    // Get quiz score provider
    final quizScoreProvider = Provider.of<QuizScoreProvider>(context);
    final latestScore = quizScoreProvider.latestScore;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/Settings.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: isLoading || quizScoreProvider.isLoading
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
                  
                  const SizedBox(height: 90),
                  
                  // User info card 
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 245, 220, 248),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: const Color.fromARGB(255, 237, 191, 237),
                        width: 1.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.purple.withOpacity(0.2),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: const Offset(0, 3),
                        ),
                      ],
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
                          icon: const Icon(Icons.edit, color: Color.fromARGB(255, 255, 253, 253)),
                          onPressed: () {
                            // Navigate to profile page
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const ProfilePage()),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 15),
                  
                  // Quiz Score Card - Enhanced
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 246, 242, 228),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.purple.withOpacity(0.2),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: const Offset(0, 3),
                        ),
                      ],
                      border: Border.all(
                        color: const Color.fromARGB(255, 241, 178, 199),
                        width: 1.5,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.quiz, color: Colors.purple),
                            const SizedBox(width: 8),
                            const Text(
                              'Quiz Progress',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 15, 15, 15),
                              ),
                            ),
                            const Spacer(),
                            if (latestScore != null)
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.purple.withOpacity(0.1),
                                      spreadRadius: 1,
                                      blurRadius: 2,
                                      offset: const Offset(0, 1),
                                    ),
                                  ],
                                ),
                                child: Text(
                                  '${latestScore.correctAnswers}/50',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.purple,
                                  ),
                                ),
                              ),
                          ],
                        ),
                        if (latestScore != null) ...[
                          const SizedBox(height: 12),
                          // Progress bar
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: LinearProgressIndicator(
                              value: latestScore.correctAnswers / latestScore.totalQuestions,
                              minHeight: 10,
                              backgroundColor: Colors.grey.shade200,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                latestScore.correctAnswers / latestScore.totalQuestions >= 0.7
                                    ? Colors.green
                                    : latestScore.correctAnswers / latestScore.totalQuestions >= 0.4
                                        ? Colors.orange
                                        : Colors.red,
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              Text(
                                latestScore.isCompleted 
                                    ? 'Quiz completed!' 
                                    : 'Quiz in progress',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  fontStyle: FontStyle.italic,
                                  color: latestScore.isCompleted 
                                      ? Colors.green[700]
                                      : Colors.orange[700],
                                ),
                              ),
                              const Spacer(),
                              Text(
                                DateFormat('MMM d, y').format(latestScore.timestamp),
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ] else ...[
                          const SizedBox(height: 8),
                          const Text(
                            'No quiz data available yet',
                            style: TextStyle(
                              fontSize: 14,
                              fontStyle: FontStyle.italic,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(height: 8),
                          ElevatedButton.icon(
                            onPressed: () {
                              // Navigate to quiz screen
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const QuizScreen()),
                              );
                            },
                            icon: const Icon(Icons.play_arrow),
                            label: const Text('Start Quiz'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.purple.shade200,
                              foregroundColor: Colors.black87,
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),

                  const SizedBox(height: 15),
                  
                  // Notifications toggle
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 220, 233, 244),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: const Color.fromARGB(255, 160, 200, 230),
                        width: 1.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.blue.withOpacity(0.15),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: const Offset(0, 3),
                        ),
                      ],
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
                  
                  const SizedBox(height: 15),
                  
                  // Terms of Service container
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 235, 249, 217),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: const Color.fromARGB(255, 200, 230, 170),
                        width: 1.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.green.withOpacity(0.15),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: const Offset(0, 3),
                        ),
                      ],
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
                      margin: const EdgeInsets.only(bottom: 160),
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
