import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:pookie/pages/user_profile.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _formKey = GlobalKey<FormState>();
  
  // Controllers for the text fields
  late TextEditingController _nameController;
  late TextEditingController _emailController;

  @override
  void initState() {
    super.initState();
    // Initialize controllers with empty values, will be filled once data is loaded
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    
    // Load data from provider
    _loadUserData();
  }

  void _loadUserData() {
    final userProfile = Provider.of<UserProfileProvider>(context, listen: false).profile;
    _nameController.text = userProfile.name;
    _emailController.text = userProfile.email;
  }

  Future<void> _updateProfile() async {
    if (!_formKey.currentState!.validate()) return;

    // Show loading dialog (similar to login page)
    showDialog(
      context: context, 
      barrierDismissible: false,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      }
    );

    try {
      // Update the profile in the provider (which updates Firestore)
      await Provider.of<UserProfileProvider>(context, listen: false).updateProfile(
        name: _nameController.text,
      );
      
      // Pop the loading dialog
      Navigator.pop(context);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile updated successfully')),
        );
      }
    } catch (e) {
      // Pop the loading dialog
      Navigator.pop(context);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error updating profile: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Watch the provider for changes
    final userProfileProvider = Provider.of<UserProfileProvider>(context);
    final isLoadingProfile = userProfileProvider.isLoading;
    
    // If we're still loading data initially, show a loading indicator
    if (isLoadingProfile && _nameController.text.isEmpty) {
      return Scaffold(
        body: Stack(
          children: [
            // Background image
            Positioned.fill(
              child: Image.asset(
                'assets/Profile.png',
                fit: BoxFit.cover,
              ),
            ),
            // Transparent loading overlay
            Container(
              color: Colors.black.withOpacity(0.3),
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
          ],
        ),
      );
    }
    
    return Scaffold(
      resizeToAvoidBottomInset: false, // This prevents the screen from resizing
      body: Stack(
        children: [
          // Fixed background image that won't move
          Positioned.fill(
            child: Image.asset(
              'assets/Profile.png',
              fit: BoxFit.cover,
            ),
          ),
          // Original content layout
          SafeArea(
            child: SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: MediaQuery.of(context).size.height - 
                            MediaQuery.of(context).padding.top - 
                            MediaQuery.of(context).padding.bottom,
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      // Top bar with back button and cat image
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          children: [
                            // Back button
                            IconButton(
                              icon: const Icon(Ionicons.chevron_back, color: Colors.black),
                              onPressed: () => Navigator.pop(context),
                            ),
                            const Text(
                              'Profile',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 15, 15, 15),
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Cat image (keeping original position)
                      Positioned(
                        right: 0,
                        top: 20,
                        child: Image.asset(
                          'assets/catice.png',
                          height: 150,
                        ),
                      ),
                      
                      // Name Field
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Name',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 15, 15, 15),
                              ),
                            ),
                            const SizedBox(height: 8),
                            TextFormField(
                              controller: _nameController,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide.none,
                                ),
                                suffixIcon: const Icon(Icons.edit, color: Color.fromARGB(255, 185, 184, 184)),
                              ),
                              style: const TextStyle(color: Colors.black),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your name';
                                }
                                return null;
                              },
                            ),
                          ],
                        ),
                      ),
                      
                      // Email Field
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Email',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 15, 15, 15),
                              ),
                            ),
                            const SizedBox(height: 8),
                            TextFormField(
                              controller: _emailController,
                              enabled: false, // Email can't be edited, only displayed
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide.none,
                                ),
                                suffixIcon: const Icon(Icons.edit, color: Color.fromARGB(255, 216, 216, 216)),
                              ),
                              style: const TextStyle(color: Colors.black),
                            ),
                          ],
                        ),
                      ),
                      
                      // Save Button
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                        child: ElevatedButton(
                          onPressed: _updateProfile,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color.fromARGB(255, 162, 111, 208),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            minimumSize: const Size(double.infinity, 50),
                          ),
                          child: const Text(
                            'Save Changes',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }
}