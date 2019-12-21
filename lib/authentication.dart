import "package:firebase_auth/firebase_auth.dart";

abstract class AuthImplementation
{
  Future<String> signIn(String email, String password);
  Future<String> signUp(String email, String password);
  Future<String> currentUser();
  Future<void> signOut();
}

class Auth implements AuthImplementation
{

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<String> signIn(String email, String password) async
  {
    AuthResult result = await _firebaseAuth.signInWithEmailAndPassword(email: email , password: password);
    FirebaseUser user = result.user;
    return user.uid;
  }
  
  Future<String> signUp(String email, String password) async
  {
    AuthResult result = await _firebaseAuth.createUserWithEmailAndPassword(email: email , password: password);
    FirebaseUser user = result.user;
    return user.uid;
  }

  Future<String> currentUser() async
  {
    FirebaseUser user = await _firebaseAuth.currentUser();
    return user.uid;
  }

  Future<void> signOut() async
  {
    _firebaseAuth.signOut();
  }

}