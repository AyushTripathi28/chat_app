import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  //instace of firebase auth
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //get current user
  User? getCurrentUser() {
    return _auth.currentUser;
  }

  //sign in with email and password
  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      //save user data to firestore
      _firestore.collection('Users').doc(userCredential.user!.uid).update({
        "uid": userCredential.user!.uid,
        "email": email,
      });
      return userCredential;
    } on FirebaseAuthException catch (e) {
      print(e.toString());
      throw Exception(e.code);
    }
  }

  //sign up with email and password
  Future signUpWithEmailAndPassword(
      String name, String email, String password) async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await userCredential.user!.updateDisplayName(name);

      //save user data to firestore
      _firestore.collection('Users').doc(userCredential.user!.uid).set({
        "uid": userCredential.user!.uid,
        "email": email,
        "name": name,
      });

      return userCredential;
    } on FirebaseAuthException catch (e) {
      print(e.toString());
      throw Exception(e.code);
    }
  }

  //sign out
  Future<void> signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return;
    }
  }
}
