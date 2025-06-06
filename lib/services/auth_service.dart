import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

class AuthService extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  
  AppUser? user;
  bool isLoading = true;

  AuthService() {
    // Listen to auth state changes
    _auth.authStateChanges().listen(_onAuthStateChanged);
  }

  // Handle authentication state changes
  Future<void> _onAuthStateChanged(User? firebaseUser) async {
    if (firebaseUser == null) {
      _updateState(user: null, isLoading: false);
      return;
    }

    try {
      final userDoc = await _db
          .collection('users')
          .doc(firebaseUser.uid)
          .get();

      final appUser = userDoc.exists
          ? AppUser.fromMap(userDoc.data()!)
          : AppUser(
              uid: firebaseUser.uid,
              email: firebaseUser.email ?? '',
              name: '',
              createdAt: DateTime.now(),
            );

      _updateState(user: appUser, isLoading: false);
    } catch (e) {
      _updateState(user: null, isLoading: false);
    }
  }

  // Helper method to update state
  void _updateState({AppUser? user, bool? isLoading}) {
    this.user = user;
    if (isLoading != null) this.isLoading = isLoading;
    notifyListeners();
  }

  // Register new user
  Future<String?> register(String name, String email, String password) async {
    try {
      _updateState(isLoading: true);
      
      // Create auth user
      final cred = await _auth.createUserWithEmailAndPassword(
        email: email, 
        password: password
      );

      // Create user document
      final newUser = AppUser(
        uid: cred.user!.uid,
        email: email,
        name: name,
        createdAt: DateTime.now(),
      );

      await _db
          .collection('users')
          .doc(newUser.uid)
          .set(newUser.toMap());

      return null;
    } on FirebaseAuthException catch (e) {
      _updateState(isLoading: false);
      return e.message;
    }
  }

  // Login existing user
  Future<String?> login(String email, String password) async {
    try {
      _updateState(isLoading: true);
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password
      );
      return null;
    } on FirebaseAuthException catch (e) {
      _updateState(isLoading: false);
      return e.message;
    }
  }

  // Logout user
  Future<void> logout() async {
    await _auth.signOut();
  }
}