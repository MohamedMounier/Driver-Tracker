
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


class FireMethods{
  final FirebaseAuth _auth=FirebaseAuth.instance;
  FirebaseFirestore _fireStore=FirebaseFirestore.instance;
  Stream<User?> get authChanges=>_auth.authStateChanges();




  Future<void> logout()async{
    await _auth.signOut();
  }




  Future<void> resetPassword(String email)async{
    await _auth.sendPasswordResetEmail(email: email);
  }

}