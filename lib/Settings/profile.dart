import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:provider/provider.dart';
import 'package:pookie/pages/user_profile.dart';

// Add this constant at the top of the file
const String STANDARD_PROFILE_PICTURE = 'assets/standard.png';

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
  
  // Flag to show/hide profile picture selection dialog
  bool _showPictureSelector = false;
  
  // List of available profile pictures (you can add more)
  final List<String> _profilePictures = [
    'assets/profiles/green.png',
    'assets/profiles/purple.png',
    'assets/profiles/iceblue.png',
    'assets/profiles/lightpink.png',
    'assets/profiles/yellow.png',
    'assets/profiles/darkblue.png',
    'assets/profiles/blue.png',
    'assets/profiles/pinkbigeyes.png',
    'assets/profiles/pink.png',
  ];

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
    // Dismiss keyboard first
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) return;

    // Show loading dialog
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
  
  // Update profile picture
  Future<void> _updateProfilePicture(String picturePath) async {
    setState(() {
      _showPictureSelector = false;
    });
    
    // Show loading dialog
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
      // Update the profile picture in the provider
      await Provider.of<UserProfileProvider>(context, listen: false).updateProfile(
        profilePicture: picturePath,
      );
      
      // Pop the loading dialog
      Navigator.pop(context);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile picture updated successfully')),
        );
      }
    } catch (e) {
      // Pop the loading dialog
      Navigator.pop(context);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error updating profile picture: $e')),
        );
      }
    }
  }
  
  // New method to remove profile picture
  Future<void> _removeProfilePicture() async {
    setState(() {
      _showPictureSelector = false;
    });
    
    // Show loading dialog
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
      // Reset to standard profile picture
      await Provider.of<UserProfileProvider>(context, listen: false).updateProfile(
        profilePicture: STANDARD_PROFILE_PICTURE,
      );
      
      // Pop the loading dialog
      Navigator.pop(context);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile picture removed')),
        );
      }
    } catch (e) {
      // Pop the loading dialog
      Navigator.pop(context);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error removing profile picture: $e')),
        );
      }
    }
  }

  // Build the profile picture selector dialog
  Widget _buildPictureSelector() {
    return _showPictureSelector 
      ? Container(
          color: Colors.black.withOpacity(0.7),
          child: Center(
            child: Container(
              width: MediaQuery.of(context).size.width * 0.9, // 90% of screen width
              margin: const EdgeInsets.all(20),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Choose Profile Picture',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  // Grid with 3 pictures per line - with consistent image fitting
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.4, // Fixed height for grid
                    child: GridView.builder(
                      shrinkWrap: true,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        childAspectRatio: 1.0, // Square aspect ratio
                      ),
                      itemCount: _profilePictures.length,
                      itemBuilder: (context, index) {
                        final userProfile = Provider.of<UserProfileProvider>(context).profile;
                        final isSelected = userProfile.profilePicture == _profilePictures[index];
                        
                        return GestureDetector(
                          onTap: () => _updateProfilePicture(_profilePictures[index]),
                          child: Container(
                            padding: const EdgeInsets.all(8), // Add some padding inside each grid item
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: isSelected ? const Color.fromARGB(255, 162, 111, 208) : Colors.grey,
                                width: isSelected ? 3 : 1,
                              ),
                              borderRadius: BorderRadius.circular(12),
                              color: isSelected ? const Color.fromARGB(255, 245, 240, 250) : Colors.white,
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.asset(
                                _profilePictures[index],
                                fit: BoxFit.contain, // Changed to contain for consistent display
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 40),
                  // Row with both buttons side by side
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Remove Profile Picture button - white bg with purple border
                      Expanded(
                        flex: 2, // Give more space to the Remove button since it has longer text
                        child: ElevatedButton(
                          onPressed: _removeProfilePicture,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: const Color.fromARGB(255, 162, 111, 208),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                              side: const BorderSide(
                                color: Color.fromARGB(255, 162, 111, 208),
                                width: 2,
                              ),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          child: const Text(
                            'Remove Profile Picture',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10), // Space between buttons
                      // Close button - smaller width
                      Expanded(
                        flex: 1, // Take less space than the Remove button
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _showPictureSelector = false;
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color.fromARGB(255, 162, 111, 208),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          child: const Text(
                            'Close',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        )
      : const SizedBox.shrink();
  }

  @override
  Widget build(BuildContext context) {
    // Watch the provider for changes
    final userProfileProvider = Provider.of<UserProfileProvider>(context);
    final isLoadingProfile = userProfileProvider.isLoading;
    final userProfile = userProfileProvider.profile;
    
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
                      // Top bar with back button
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
                      
                      // Profile picture section
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _showPictureSelector = true;
                          });
                        },
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            // Profile picture container
                            Container(
                              width: 150,
                              height: 150,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: const Color.fromARGB(255, 162, 111, 208),
                                  width: 3,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.2),
                                    blurRadius: 10,
                                    offset: const Offset(0, 5),
                                  ),
                                ],
                                color: Colors.white, // Add white background to container
                              ),
                              child: ClipOval(
                                child: Padding(
                                  padding: const EdgeInsets.all(10), // Add padding
                                  child: Image.asset(
                                    userProfile.profilePicture,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                            ),
                            // Edit icon overlay
                            Positioned(
                              bottom: 5,
                              right: 5,
                              child: Container(
                                padding: const EdgeInsets.all(5),
                                decoration: const BoxDecoration(
                                  color: Color.fromARGB(255, 162, 111, 208),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.edit,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      const SizedBox(height: 20),
                      
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
          
          // Profile picture selector dialog (only shown when _showPictureSelector is true)
          _buildPictureSelector(),
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
