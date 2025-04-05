import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pookie/pages/quiz/quiz_question.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<QuizQuestion>> getQuizQuestions() async {
    try {
      QuerySnapshot querySnapshot = await _firestore.collection('questions').get();

      List<QuizQuestion> questions = querySnapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return QuizQuestion.fromMap({
          'id': doc.id,
          ...data,
        });
      }).toList();

      // If no questions found in Firebase, return an empty list
      if (questions.isEmpty) {
        return [];
      }

      return questions;
    } catch (e) {
      print('Error fetching questions: $e');
      // Return empty list if Firebase fetch fails
      return [];
    }
  }
}
