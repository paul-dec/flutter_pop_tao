import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Auth {
  static Future<String?> mailRegister(
      String mail, String pwd, String pseudo) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: mail, password: pwd);
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user?.uid)
          .set({'pseudo': pseudo, 'role': 'user', 'servers': []});
      return null;
    } on FirebaseAuthException catch (ex) {
      return "${ex.code}: ${ex.message}";
    }
  }

  static Future<String?> signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
      return null;
    } on FirebaseAuthException catch (ex) {
      return "${ex.code}: ${ex.message}";
    }
  }

  static Future<String?> mailSignIn(String mail, String pwd) async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: mail, password: pwd);
      return null;
    } on FirebaseAuthException catch (ex) {
      return "${ex.code}: ${ex.message}";
    }
  }
}
