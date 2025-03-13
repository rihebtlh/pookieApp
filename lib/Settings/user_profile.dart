import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// User profile model
class UserProfile {
  String firstName;
  String lastName;
  String email;
  String uid; // Add UID to track the user

  UserProfile({
    required this.firstName,
    required this.lastName, 
    required this.email,
    required this.uid,
  });

  // Getter for full name
  String get fullName => "$firstName $lastName";

  // Convert to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
    };
  }

  // Create from Firestore document
  factory UserProfile.fromDocument(DocumentSnapshot doc, String email) {
    final data = doc.data() as Map<String, dynamic>;
    
    return UserProfile(
      firstName: data['firstName'] ?? '',
      lastName: data['lastName'] ?? '',
      email: email, // Email comes from Firebase Auth
      uid: doc.id,
    );
  }
}

// Provider that handles Firebase interaction
class UserProfileProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  // Default empty profile
  UserProfile _userProfile = UserProfile(
    firstName: "",
    lastName: "",
    email: "",
    uid: "",
  );
  
  bool _isLoading = false;
  String _error = '';

  // Getters
  UserProfile get profile => _userProfile;
  bool get isLoading => _isLoading;
  String get error => _error;

  // Constructor - fetch user data when provider is created
  UserProfileProvider() {
    loadUserProfile();
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
          firstName: currentUser.displayName?.split(' ').first ?? '',
          lastName: currentUser.displayName?.split(' ').last ?? '',
          email: currentUser.email ?? '',
          uid: currentUser.uid,
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
    String? firstName, 
    String? lastName,
    String? email
  }) async {
    try {
      _isLoading = true;
      notifyListeners();
      
      // Update local profile
      if (firstName != null) _userProfile.firstName = firstName;
      if (lastName != null) _userProfile.lastName = lastName;
      if (email != null) _userProfile.email = email;
      
      // Update in Firestore
      await _firestore
          .collection('users')
          .doc(_userProfile.uid)
          .update(_userProfile.toMap());
      
      // Update display name in Firebase Auth if needed
      if (firstName != null || lastName != null) {
        await _auth.currentUser?.updateDisplayName(_userProfile.fullName);
      }
      
      _error = '';
    } catch (e) {
      _error = 'Failed to update profile: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}