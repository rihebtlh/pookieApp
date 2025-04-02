import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pookie/pages/quiz/quiz_provider.dart';
import 'package:pookie/pages/quiz/widgets/quiz_option.dart';
import 'package:pookie/pages/quiz/result_screen.dart';
import 'package:pookie/theme/themeProvider.dart';
import 'package:pookie/theme/boy.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  late QuizProvider _quizProvider;
  bool _isLoading = true;
  
  @override
  void initState() {
    super.initState();
    _quizProvider = Provider.of<QuizProvider>(context, listen: false);
    _loadQuestions();
  }
  
  Future<void> _loadQuestions() async {
    setState(() => _isLoading = true);
    await _quizProvider.loadQuestions();
    setState(() => _isLoading = false);
  }

  // Show confirmation dialog when user attempts to exit
  Future<bool> _confirmExit() async {
    // If quiz is in progress and not finished, show confirmation dialog
    if (_quizProvider.quizInProgress && !_quizProvider.isQuizFinished) {
      final shouldExit = await showDialog<bool>(
        context: context,
        barrierDismissible: false, // User must tap a button to close dialog
        builder: (context) {
          return AlertDialog(
            title: const Text('Exit Quiz?'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Do you want to exit the quiz?', 
                  style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                const Text('Your progress will be saved and you can continue later.'),
                const SizedBox(height: 16),
                Text(
                  'Current progress: Question ${_quizProvider.currentQuestionIndex + 1}/${_quizProvider.questions.length}',
                  style: const TextStyle(fontStyle: FontStyle.italic),
                ),
              ],
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(false); // Don't exit
                },
                child: const Text('CANCEL', 
                  style: TextStyle(fontWeight: FontWeight.bold)),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Colors.white,
                ),
                onPressed: () {
                  // User confirmed exit, save state but don't reset
                  Navigator.of(context).pop(true); // Allow exit
                },
                child: const Text('SAVE & EXIT', 
                  style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ],
          );
        },
      );
      
      return shouldExit ?? false;
    }
    
    // If quiz is not in progress or is finished, allow exit without confirmation
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _confirmExit, // Handle back button/gesture
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () async {
              // Use the same exit confirmation for the back button
              if (await _confirmExit()) {
                Navigator.pop(context);
              }
            },
          ),
        ),
        body: _isLoading 
            ? const Center(child: CircularProgressIndicator())
            : Consumer<QuizProvider>(
                builder: (context, quizProvider, child) {
                  if (quizProvider.questions.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("No questions available"),
                          ElevatedButton(
                            onPressed: _loadQuestions,
                            child: const Text("Retry"),
                          ),
                        ],
                      ),
                    );
                  }
                  
                  if (quizProvider.isQuizFinished) {
                    return ResultScreen(
                      score: quizProvider.score,
                      totalQuestions: quizProvider.questions.length,
                      feedback: quizProvider.getFeedbackMessage(),
                      onRestart: () => quizProvider.resetQuiz(),
                    );
                  }
                  
                  final currentQuestion = quizProvider.currentQuestion;
                  
                  // Handle null currentQuestion
                  if (currentQuestion == null) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("Failed to load question"),
                          ElevatedButton(
                            onPressed: _loadQuestions,
                            child: const Text("Retry"),
                          ),
                        ],
                      ),
                    );
                  }
                  
                  // Get the theme provider to check current theme
                  final themeProvider = Provider.of<ThemeProvider>(context);
                  final bool isBoyTheme = themeProvider.currentTheme == boyTheme;
                  
                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          width: double.infinity,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.secondary,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Text(
                            "QuizPookie 🐱",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Question ${quizProvider.currentQuestionIndex + 1}/${quizProvider.questions.length}",
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              "Score: ${quizProvider.score}",
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 30),
                        Container(
                          padding: const EdgeInsets.all(20),
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.secondary,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            children: [
                              Text(
                                currentQuestion.question,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 20),
                              ...currentQuestion.options.map((option) {
                                return QuizOption(
                                  text: option,
                                  onPressed: () => quizProvider.selectAnswer(option),
                                  isSelected: quizProvider.selectedAnswer == option,
                                  isCorrect: option == currentQuestion.correctAnswer,
                                  answerLocked: quizProvider.answerLocked,
                                  isBoyTheme: isBoyTheme,
                                );
                              }).toList(),
                            ],
                          ),
                        ),
                        const SizedBox(height: 120),
                        // Explicit quit button
                        Center(
                          child: ElevatedButton.icon(
                            icon: const Icon(Icons.save_outlined),
                            label: const Text("Save & Quit Quiz"),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color.fromARGB(255, 230, 229, 229),
                              foregroundColor: Colors.black87,
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            onPressed: () async {
                              if (await _confirmExit()) {
                                Navigator.pop(context);
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
      ),
    );
  }
}