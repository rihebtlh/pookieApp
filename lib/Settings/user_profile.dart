import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';

// Define the standard profile picture path as a constant
const String STANDARD_PROFILE_PICTURE = 'assets/standard.png';

// User profile model
class UserProfile {
  String name;
  String email;
  String uid;
  String profilePicture;

  UserProfile({
    required this.name,
    required this.email,
    required this.uid,
    this.profilePicture = STANDARD_PROFILE_PICTURE, // Use the constant here
  });

  // Getter for full name (keeping for backward compatibility)
  String get fullName => name;

  // Convert to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'profilePicture': profilePicture,
    };
  }

  // Create from Firestore document
  factory UserProfile.fromDocument(DocumentSnapshot doc, String email) {
    final data = doc.data() as Map<String, dynamic>;
    
    // Handle both old format (firstName/lastName) and new format (name)
    String name = data['name'] ?? '';
    if (name.isEmpty && data['firstName'] != null) {
      // Convert old format to new format
      name = "${data['firstName'] ?? ''} ${data['lastName'] ?? ''}".trim();
    }
    
    return UserProfile(
      name: name,
      email: email, // Email comes from Firebase Auth
      uid: doc.id,
      profilePicture: data['profilePicture'] ?? STANDARD_PROFILE_PICTURE,
    );
  }
}

// Updated Provider that handles Firebase interaction
class UserProfileProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  StreamSubscription<User?>? _authListener;
  
  // Default empty profile
  UserProfile _userProfile = UserProfile(
    name: "",
    email: "",
    uid: "",
    profilePicture: STANDARD_PROFILE_PICTURE,
  );
  
  bool _isLoading = false;
  String _error = '';

  // Getters
  UserProfile get profile => _userProfile;
  bool get isLoading => _isLoading;
  String get error => _error;

  // Constructor - fetch user data when provider is created
  UserProfileProvider() {
    // Set up auth state listener
    _authListener = _auth.authStateChanges().listen((User? user) {
      if (user != null) {
        loadUserProfile();
      } else {
        // Clear profile when logged out
        _userProfile = UserProfile(
          name: "", 
          email: "", 
          uid: "",
          profilePicture: STANDARD_PROFILE_PICTURE,
        );
        notifyListeners();
      }
    });
  }

  @override
  void dispose() {
    _authListener?.cancel();
    super.dispose();
  }

  // Fetch user data from Firestore
  Future<void> loadUserProfile() async {
    final User? currentUser = _auth.currentUser;
    
    if (currentUser == null) {
      _error = 'No user is signed in';
      notifyListeners();
      return;
    }
    
    try {
      _isLoading = true;
      notifyListeners();

      // Get user document from Firestore
      final docSnapshot = await _firestore
          .collection('users')
          .doc(currentUser.uid)
          .get();

      // If user document exists, load it
      if (docSnapshot.exists) {
        _userProfile = UserProfile.fromDocument(
          docSnapshot, 
          currentUser.email ?? ''
        );
      } else {
        // If no document exists yet, create one with default values
        _userProfile = UserProfile(
          name: currentUser.displayName ?? '',
          email: currentUser.email ?? '',
          uid: currentUser.uid,
          profilePicture: STANDARD_PROFILE_PICTURE,
        );
        
        // Save the initial profile to Firestore
        await _firestore
            .collection('users')
            .doc(currentUser.uid)
            .set(_userProfile.toMap());
      }
    } catch (e) {
      _error = 'Failed to load profile: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Update profile both locally and in Firestore
  Future<void> updateProfile({
    String? name,
    String? email,
    String? profilePicture
  }) async {
    try {
      _isLoading = true;
      notifyListeners();
      
      // Update local profile
      if (name != null) _userProfile.name = name;
      if (email != null) _userProfile.email = email;
      if (profilePicture != null) _userProfile.profilePicture = profilePicture;
      
      // Update in Firestore
      await _firestore
          .collection('users')
          .doc(_userProfile.uid)
          .update(_userProfile.toMap());
      
      // Update display name in Firebase Auth if needed
      if (name != null) {
        await _auth.currentUser?.updateDisplayName(_userProfile.name);
      }
      
      _error = '';
    } catch (e) {
      _error = 'Failed to update profile: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  
  // New method specifically for removing profile picture
  Future<void> removeProfilePicture() async {
    try {
      _isLoading = true;
      notifyListeners();
      
      // Set profile picture to standard
      _userProfile.profilePicture = STANDARD_PROFILE_PICTURE;
      
      // Update in Firestore
      await _firestore
          .collection('users')
          .doc(_userProfile.uid)
          .update(_userProfile.toMap());
      
      _error = '';
    } catch (e) {
      _error = 'Failed to remove profile picture: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
