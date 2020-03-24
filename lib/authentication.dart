import "package:firebase_auth/firebase_auth.dart";
import 'package:firebase_database/firebase_database.dart';
import 'package:oktoast/oktoast.dart';



abstract class AuthImplementation
{
  Future<String> signIn(String email, String password);
  Future<String> signUp(String email, String password, String name, String dateOfBirth);
  Future<String> getCurrentUser();
  Future<bool> isVerified();
  Future<void> signOut();
  Future<void> resetPassword(String email);
  Future<void> verifyUser();
}




class Auth implements AuthImplementation
{
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  //
  Future<String> signIn(String email, String password) async
  {
    AuthResult result = await _firebaseAuth.signInWithEmailAndPassword(email: email , password: password);
    FirebaseUser user = result.user;
    return user.uid;
  }
  //
  
  //
  Future<String> signUp(String email, String password, String name, String dateOfBirth) async
  {
    AuthResult result = await _firebaseAuth.createUserWithEmailAndPassword(email: email , password: password);
    FirebaseUser user = result.user;

    DatabaseReference userRef = FirebaseDatabase.instance.reference().child("Users");
    var data =
    {
      "name": name,
      "dob": dateOfBirth,
      "uid": user.uid,
    };
    userRef.push().set(data);

    try 
    {
      await user.sendEmailVerification();
      return user.uid;
    } 
    catch (e) 
    {
      showToast(e.message, duration: Duration(seconds: 3), position: ToastPosition.bottom);
    }
    return user.uid;
  }
  //

  //
  Future<String> getCurrentUser() async
  {
    FirebaseUser user = await _firebaseAuth.currentUser();
    return user.uid;
  }
  //

  //
  Future<void> signOut() async
  {
    _firebaseAuth.signOut();
  }
  //

  //
  Future<bool> isVerified() async
  {
    FirebaseUser user = await _firebaseAuth.currentUser();
    return(user.isEmailVerified);
  }
  //

  //
  Future<void> verifyUser() async
  {
    FirebaseUser user = await _firebaseAuth.currentUser();
    try 
    {
      await user.sendEmailVerification().whenComplete((){
        showToast("Check your mail to verify account!", duration: Duration(seconds: 3), position: ToastPosition.bottom);
      });
      _firebaseAuth.signOut();
    } 
    catch (e) 
    {
      showToast(e.message, duration: Duration(seconds: 3), position: ToastPosition.bottom);
    }
  }
  //

  //
  Future<void> resetPassword(String email) async 
  {
    await _firebaseAuth.sendPasswordResetEmail(email: email).whenComplete((){
      showToast("Check your mail to reset password!", duration: Duration(seconds: 3), position: ToastPosition.bottom);
    });
  }
  //
}