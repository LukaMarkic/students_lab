
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import '../models.dart';
import 'database/profileService.dart';

class AuthService {
  final userStream = FirebaseAuth.instance.authStateChanges();
  final user = FirebaseAuth.instance.currentUser;
  ProfileService service = ProfileService();

  Future<String?> SignInWithEmailPassword(String email, String password) async {
    try {
      UserCredential result = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email, password: password);
      return result.user?.uid;
    } on FirebaseAuthException catch (e) {
      return null;
    }
  }

  Future<String?> AdminSignInWithEmailPassword(String email, String password, String seckey) async{

  try {
  UserCredential result = await FirebaseAuth.instance.signInWithEmailAndPassword(
  email: email, password: password);
  return result.user?.uid;
  } on FirebaseAuthException catch (e) {
return null;
  }
}


  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  Future<String?> SignUpWithEmailPassword( ProfileUser profileUser, String collectionName, String email, String password) async {
    try {
      UserCredential result  = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
      User? usr = result.user;
      profileUser.id = usr!.uid;
      await service.addProfileData(collectionName, profileUser);
      return usr.uid;
    } on FirebaseAuthException catch (e) {
      return null;
    }
  }



}