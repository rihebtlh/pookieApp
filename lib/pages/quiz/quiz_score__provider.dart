import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class QuizScore {
  final int correctAnswers;
  final int totalQuestions;
  final bool isCompleted;
  final DateTime timestamp;

  QuizScore({
    required this.correctAnswers,
    required this.totalQuestions,
    required this.isCompleted,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'correctAnswers': correctAnswers,
      'totalQuestions': totalQuestions,
      'isCompleted': isCompleted,
      'timestamp': timestamp.millisecondsSinceEpoch,
    };
  }

  factory QuizScore.fromMap(Map<String, dynamic> map) {
    return QuizScore(
      correctAnswers: map['correctAnswers'] ?? 0,
      totalQuestions: map['totalQuestions'] ?? 0,
      isCompleted: map['isCompleted'] ?? false,
      timestamp: DateTime.fromMillisecondsSinceEpoch(map['timestamp'] ?? DateTime.now().millisecondsSinceEpoch),
    );
  }
}

class QuizScoreProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  
  List<QuizScore> _scores = [];
  bool _isLoading = false;

  List<QuizScore> get scores => _scores;
  bool get isLoading => _isLoading;
  
  // Get the most recent score
  QuizScore? get latestScore => _scores.isNotEmpty ? _scores.first : null;

  QuizScoreProvider() {
    // Listen for authentication state changes
    _auth.authStateChanges().listen((User? user) {
      if (user != null) {
        // User logged in, load their scores
        loadScores();
      } else {
        // User logged out, clear the scores
        _scores = [];
        notifyListeners();
      }
    });
  }

  Future<void> loadScores() async {
    User? currentUser = _auth.currentUser;
    if (currentUser == null) {
      _scores = [];
      notifyListeners();
      return;
    }

    _isLoading = true;
    notifyListeners();
    
    try {
      // Get scores from Firestore for the current user
      final QuerySnapshot querySnapshot = await _firestore
          .collection('users')
          .doc(currentUser.uid)
          .collection('quiz_scores')
          .orderBy('timestamp', descending: true)
          .get();
      
      _scores = querySnapshot.docs
          .map((doc) => QuizScore.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('Error loading scores: $e');
      _scores = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> saveScore(QuizScore score) async {
    User? currentUser = _auth.currentUser;
    if (currentUser == null) {
      print('Cannot save score: No user is logged in');
      return;
    }

    _isLoading = true;
    notifyListeners();
    
    try {
      // Add new score to Firestore
      await _firestore
          .collection('users')
          .doc(currentUser.uid)
          .collection('quiz_scores')
          .add(score.toMap());
      
      // Reload scores to reflect the update
      await loadScores();
    } catch (e) {
      print('Error saving score: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  
  Future<void> clearScores() async {
    User? currentUser = _auth.currentUser;
    if (currentUser == null) {
      print('Cannot clear scores: No user is logged in');
      return;
    }

    _isLoading = true;
    notifyListeners();
    
    try {
      // Get all score documents
      QuerySnapshot snapshot = await _firestore
          .collection('users')
          .doc(currentUser.uid)
          .collection('quiz_scores')
          .get();
      
      // Delete each document in a batch
      WriteBatch batch = _firestore.batch();
      for (var doc in snapshot.docs) {
        batch.delete(doc.reference);
      }
      await batch.commit();
      
      // Clear the local list
      _scores = [];
    } catch (e) {
      print('Error clearing scores: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
