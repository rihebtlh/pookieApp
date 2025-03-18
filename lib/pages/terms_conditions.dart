import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

class TermsConditions extends StatelessWidget {
  final String fromScreen; // Determine which screen the user came from

  const TermsConditions({super.key, required this.fromScreen});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/terms_conditions.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: const EdgeInsets.only(top: 40),
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(141, 205, 184, 203),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: IconButton(
                    onPressed: () {
                      if (fromScreen == "SignUp") {
                        Navigator.pushReplacementNamed(context, '/signUp');
                      } else if (fromScreen == "AccountScreen") {
                        Navigator.pushReplacementNamed(context, '/accountScreen');
                      } else {
                        Navigator.pop(context);
                      }
                    },
                    icon: const Icon(
                      Ionicons.arrow_back_outline,
                      color: Colors.black,
                      size: 28,
                    ),
                    style: IconButton.styleFrom(
                      fixedSize: const Size(50, 50),
                    ),
                  ),
                ),
              ),
            ),

            // Terms & Conditions Box
            Center(
              child: Container(
                alignment: Alignment.center,
                height: 600,
                width: MediaQuery.of(context).size.width * 0.9,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey, width: 1.5),
                ),
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Terms and Conditions for Pookie",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        "Last Updated: 09-11-2024",
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600 , color: Colors.black),
                      ),
                      const SizedBox(height: 5),
                      const Text(
                        "Welcome to Pookie, an AI-powered assistant designed for children. "
                        "By using Pookie, you agree to the following terms and conditions. "
                        "If you do not agree, please do not use our app.\n",
                        style: TextStyle(fontSize: 12, height: 1.5 , color: Colors.black),
                      ),
                      _buildSectionTitle("1. Eligibility"),
                      _buildSectionContent(
                          "The app is designed for children but must be used under the "
                          "supervision of a parent or legal guardian who agrees to these "
                          "terms on their behalf.\n"),
                      _buildSectionTitle("2. Account Registration"),
                      _buildSectionContent(
                          "To access certain features, parents or guardians may need to create an account.\n"
                          "Personal data collected will be handled in accordance with our [Privacy Policy].\n"),
                      _buildSectionTitle("3. User Conduct"),
                      _buildSectionContent(
                          "Users must use the app for educational and entertainment purposes only.\n"
                          "The app may not be used to engage in harmful, harassing, or inappropriate behavior.\n"),
                      _buildSectionTitle("4. Parental Supervision"),
                      _buildSectionContent(
                          "Parents or guardians are responsible for monitoring their child’s use "
                          "of the app, ensuring a safe experience.\n"),
                      _buildSectionTitle("5. Data Collection and Privacy"),
                      _buildSectionContent(
                          "The app collects limited data as described in our [Privacy Policy].\n"
                          "No personal data will be shared with third parties without explicit parental consent, except as required by law.\n"),
                      _buildSectionTitle("6. Content and Services"),
                      _buildSectionContent(
                          "The app may provide interactive, educational, and entertainment content.\n"
                          "Content updates and changes may occur regularly without prior notice.\n"),
                      _buildSectionTitle("7. Third-Party Services"),
                      _buildSectionContent(
                          "The app may include or link to third-party services, which have their own terms and policies.\n"
                          "Pookie is not responsible for the content or practices of these services.\n"),
                      _buildSectionTitle("8. Disclaimers and Limitation of Liability"),
                      _buildSectionContent(
                          "The app is provided 'as is,' without warranties of any kind.\n"
                          "Pookie is not liable for any damages arising from the use or inability to use the app, to the extent permitted by law.\n"),
                      _buildSectionTitle("9. Termination"),
                      _buildSectionContent(
                          "We reserve the right to suspend or terminate access to the app for any user who violates these terms.\n"),
                      _buildSectionTitle("10. Modifications to Terms"),
                      _buildSectionContent(
                          "We may update these terms from time to time. We will notify users through the app or other means.\n"),
                      _buildSectionTitle("11. Contact Information"),
                      _buildSectionContent(
                          "If you have questions or concerns about these terms, you can reach us at [Contact Email/Address]."),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 4),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
    );
  }

  Widget _buildSectionContent(String content) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0),
      child: Text(
        content,
        style: const TextStyle(fontSize: 10, height: 1.5, color: Colors.black),
      ),
    );
  }
}
