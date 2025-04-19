import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

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
  List<QuizScore> _scores = [];
  bool _isLoading = false;

  List<QuizScore> get scores => _scores;
  bool get isLoading => _isLoading;
  
  // Get the most recent score
  QuizScore? get latestScore => _scores.isNotEmpty ? _scores.first : null;

  QuizScoreProvider() {
    loadScores();
  }

  Future<void> loadScores() async {
    _isLoading = true;
    notifyListeners();
    
    try {
      final prefs = await SharedPreferences.getInstance();
      final scoresJson = prefs.getStringList('quiz_scores') ?? [];
      
      _scores = scoresJson
          .map((scoreJson) => QuizScore.fromMap(jsonDecode(scoreJson)))
          .toList();
      
      // Sort scores by timestamp, most recent first
      _scores.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    } catch (e) {
      print('Error loading scores: $e');
      _scores = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> saveScore(QuizScore score) async {
    _isLoading = true;
    notifyListeners();
    
    try {
      // Add new score to the list
      _scores.insert(0, score);
      
      // Save to SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      final scoresJson = _scores.map((score) => 
          jsonEncode(score.toMap())).toList();
      
      await prefs.setStringList('quiz_scores', scoresJson);
    } catch (e) {
      print('Error saving score: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  
  Future<void> clearScores() async {
    _isLoading = true;
    notifyListeners();
    
    try {
      _scores = [];
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('quiz_scores');
    } catch (e) {
      print('Error clearing scores: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}