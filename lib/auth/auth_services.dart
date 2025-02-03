import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthServices {
  //instance of auth
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  User? getCurrentUser (){
    return _firebaseAuth.currentUser;
  }
  //Email sign in 
  
  //Email sign up
  
  //Sign out
  Future<void> signOut() async{
    return await _firebaseAuth.signOut();
  }
  //GOOGLE SIGN IN 
  signInWithGoogle() async {
  // Begin interactive sign-in process
  final GoogleSignInAccount? gUser = await GoogleSignIn().signIn();

  // User cancels Google sign-in pop-up screen
  if (gUser == null) return;

  // Obtain auth details from request
  final GoogleSignInAuthentication gAuth = await gUser.authentication;

  // Create new credential for user
  final credential = GoogleAuthProvider.credential(
    idToken: gAuth.idToken,
  );

  // Finally, sign in
  return await _firebaseAuth.signInWithCredential(credential);
}

  //Possible error message
  String getErrorMessage(String errorCode) {
    switch(errorCode){
      case 'Exception: wrong-password':
        return 'The password is incorrect. Please Try again.';
      case 'Exception: user-not-found':
        return 'No user found with this email. Please Try again.';
      case 'Exception: invalid-email':
        return 'This email does not exist. Please Try again.';
      default :
        return 'An unexpected error occurred. Please try again later.';
    }
  }
  }