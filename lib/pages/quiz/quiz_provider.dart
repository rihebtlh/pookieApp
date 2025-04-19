import 'package:flutter/foundation.dart';
  import 'package:firebase_auth/firebase_auth.dart';
import 'package:pookie/pages/quiz/quiz_question.dart';
import 'package:pookie/pages/quiz/quiz_score__provider.dart';
import 'package:pookie/services/firebase_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'dart:math';

class QuizProvider with ChangeNotifier {
  final FirebaseService _firebaseService = FirebaseService();
  final QuizScoreProvider _scoreProvider; // Add reference to score provider
  
  List<QuizQuestion> _questions = [];
  int _currentQuestionIndex = 0;
  int _score = 0;
  bool _isQuizFinished = false;
  
  String? _selectedAnswer;
  bool _answerLocked = false;
  bool _quizInProgress = false;

  List<Map<String, dynamic>> _savedQuestionStates = [];

  List<QuizQuestion> get questions => _questions;
  int get currentQuestionIndex => _currentQuestionIndex;
  int get score => _score;
  bool get isQuizFinished => _isQuizFinished;
  
  QuizQuestion? get currentQuestion {
    if (_questions.isEmpty) {
      return null;
    }
    return _questions[_currentQuestionIndex];
  }
  
  String? get selectedAnswer => _selectedAnswer;
  bool get answerLocked => _answerLocked;
  bool get quizInProgress => _quizInProgress;

  // Constructor with QuizScoreProvider dependency
  QuizProvider(this._scoreProvider);

  Future<void> loadQuestions() async {
    // Check if there's a saved quiz state
    final savedState = await _loadSavedState();
    
    if (savedState != null && 
        savedState['quizInProgress'] == true && 
        savedState['questions'] != null) {
      try {
        // Safely cast and parse questions
        _questions = (savedState['questions'] as List)
            .map((q) => QuizQuestion.fromMap(q))
            .toList();
        
        _currentQuestionIndex = savedState['currentQuestionIndex'] ?? 0;
        _score = savedState['score'] ?? 0;
        _isQuizFinished = savedState['isQuizFinished'] ?? false;
        _quizInProgress = true;
        _selectedAnswer = savedState['selectedAnswer'];
        _answerLocked = savedState['answerLocked'] ?? false;
        
        // Safely restore saved question states
        _savedQuestionStates = savedState['savedQuestionStates'] != null
            ? List<Map<String, dynamic>>.from(savedState['savedQuestionStates'])
            : [];
        // Ensure we're always starting from the first question when explicitly restarting
        if (_currentQuestionIndex > 0 && _savedQuestionStates.isEmpty) {
          _currentQuestionIndex = 0;
        }
      } catch (e) {
        print('Error loading saved quiz state: $e');
        await _startFreshQuiz();
      }
    } else {
      // Start a new quiz if no valid saved state exists
      await _startFreshQuiz();
    }
    
    _saveCurrentState();
    notifyListeners();
  }

  Future<void> _startFreshQuiz() async {
    _questions = await _firebaseService.getQuizQuestions();
    _randomizeQuestions();
    
    _currentQuestionIndex = 0;
    _score = 0;
    _isQuizFinished = false;
    _quizInProgress = true;
    _selectedAnswer = null;
    _answerLocked = false;
    _savedQuestionStates = [];
  }

  void _randomizeQuestions() {
    final random = Random();
    
    // Shuffle questions
    for (int i = _questions.length - 1; i > 0; i--) {
      final j = random.nextInt(i + 1);
      final temp = _questions[i];
      _questions[i] = _questions[j];
      _questions[j] = temp;
    }

    // Shuffle options for each question
    for (var question in _questions) {
      _shuffleQuestionOptions(question, random);
    }
  }

  void _shuffleQuestionOptions(QuizQuestion question, Random random) {
    final options = List<String>.from(question.options);
    final correctAnswer = question.correctAnswer;
    
    options.remove(correctAnswer);
    
    for (int i = options.length - 1; i > 0; i--) {
      final j = random.nextInt(i + 1);
      final temp = options[i];
      options[i] = options[j];
      options[j] = temp;
    }
    
    final insertIndex = random.nextInt(options.length + 1);
    options.insert(insertIndex, correctAnswer);
    
    (question as dynamic).options = options;
  }

  void selectAnswer(String answer) {
    if (_answerLocked || currentQuestion == null) return;
    
    // Save the current question state before changing
    _savedQuestionStates.add({
      'questionIndex': _currentQuestionIndex,
      'selectedAnswer': answer,
      'answerLocked': true,
      'score': answer == currentQuestion!.correctAnswer ? _score + 1 : _score
    });
    
    _selectedAnswer = answer;
    _answerLocked = true;
    
    if (answer == currentQuestion!.correctAnswer) {
      _score++;
    }
    
    _saveCurrentState();
    notifyListeners();
    
    Future.delayed(const Duration(milliseconds: 1500), () {
      moveToNextQuestion();
    });
  }
  
  void moveToNextQuestion() {
    if (_currentQuestionIndex < _questions.length - 1) {
      _currentQuestionIndex++;
      _selectedAnswer = null;
      _answerLocked = false;
    } else {
      _isQuizFinished = true;
      _quizInProgress = false;
      
      // Save the final score when quiz is finished
      _saveQuizScore(true);
    }
    
    _saveCurrentState();
    notifyListeners();
  }

  void resetQuiz() {
    _currentQuestionIndex = 0;
    _score = 0;
    _isQuizFinished = false;
    _selectedAnswer = null;
    _answerLocked = false;
    _quizInProgress = true;
    _savedQuestionStates = [];
    
    _clearSavedState();
    
    _startFreshQuiz().then((_) {
      _saveCurrentState();
      notifyListeners();
    });
  }
  
  void quitQuiz() {
    // Save the current score when quitting
    if (_quizInProgress) {
      _saveQuizScore(false);
    }
    
    _saveCurrentState();
    notifyListeners();
  }
  
  // New method to save scores to the QuizScoreProvider
  Future<void> _saveQuizScore(bool isCompleted) async {
    final QuizScore score = QuizScore(
      correctAnswers: _score,
      totalQuestions: 50, // Hardcoded as per requirement
      isCompleted: isCompleted,
      timestamp: DateTime.now(),
    );
    
    await _scoreProvider.saveScore(score);
  }

  String getFeedbackMessage() {
    if (_questions.isEmpty) return "No quiz data available.";
    
    double percentage = (_score / _questions.length) * 100;
    
    if (percentage >= 90) {
      return "Amazing work ! You're a quiz master! 🏆";
    } else if (percentage >= 70) {
      return "Great job ! Your knowledge is impressive! 🌟";
    } else if (percentage >= 50) {
      return "Good effort ! Keep learning! 👍";
    } else {
      return "Don't give up ! practice makes perfect! 📚";
    }
  }

// Add this as a class member
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Update _saveCurrentState method
  Future<void> _saveCurrentState() async {
    User? currentUser = _auth.currentUser;
    if (currentUser == null) {
      print('Cannot save quiz state: No user is logged in');
      return;
    }

    final prefs = await SharedPreferences.getInstance();
  
    // Convert questions to a format that can be saved
    final questionsToSave = _questions.map((q) => q.toMap()).toList();
    
    final quizState = {
      'quizInProgress': _quizInProgress,
      'questions': questionsToSave,
      'currentQuestionIndex': _currentQuestionIndex,
      'score': _score,
      'isQuizFinished': _isQuizFinished,
      'selectedAnswer': _selectedAnswer,
      'answerLocked': _answerLocked,
      'savedQuestionStates': _savedQuestionStates,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    };
    
    // Store with user ID in the key to separate different users' data
    await prefs.setString('quiz_state_${currentUser.uid}', jsonEncode(quizState));
  }

  // Update _loadSavedState method
  Future<Map<String, dynamic>?> _loadSavedState() async {
    User? currentUser = _auth.currentUser;
    if (currentUser == null) {
      print('Cannot load quiz state: No user is logged in');
      return null;
    }

    final prefs = await SharedPreferences.getInstance();
    
    // Use the user ID in the key
    final savedStateString = prefs.getString('quiz_state_${currentUser.uid}');
    
    if (savedStateString != null) {
      return jsonDecode(savedStateString) as Map<String, dynamic>;
    }
    
    return null;
  }

  // Update _clearSavedState method
  Future<void> _clearSavedState() async {
    User? currentUser = _auth.currentUser;
    if (currentUser == null) {
      print('Cannot clear quiz state: No user is logged in');
      return;
    }
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('quiz_state_${currentUser.uid}');
}
}
