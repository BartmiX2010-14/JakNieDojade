import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  User? _user;
  User? get user => _user;
  bool get isLoggedIn => _user != null;

  String? _error;
  String? get error => _error;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  AuthProvider() {
    _auth.authStateChanges().listen((User? user) {
      _user = user;
      notifyListeners();
    });
  }

  // Rejestracja e-mail + hasło
  Future<bool> registerWithEmail(String email, String password) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      await _auth.createUserWithEmailAndPassword(email: email, password: password);
      _isLoading = false;
      notifyListeners();
      return true;
    } on FirebaseAuthException catch (e) {
      _isLoading = false;
      _error = _translateError(e.code, e.message);
      notifyListeners();
      return false;
    } catch (e) {
      _isLoading = false;
      _error = 'Nieoczekiwany błąd: $e';
      notifyListeners();
      return false;
    }
  }

  // Logowanie e-mail + hasło
  Future<bool> loginWithEmail(String email, String password) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      await _auth.signInWithEmailAndPassword(email: email, password: password);
      _isLoading = false;
      notifyListeners();
      return true;
    } on FirebaseAuthException catch (e) {
      _isLoading = false;
      _error = _translateError(e.code, e.message);
      notifyListeners();
      return false;
    } catch (e) {
      _isLoading = false;
      _error = 'Nieoczekiwany błąd: $e';
      notifyListeners();
      return false;
    }
  }

  // Logowanie przez Google
  Future<bool> loginWithGoogle() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        _isLoading = false;
        notifyListeners();
        return false;
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await _auth.signInWithCredential(credential);
      _isLoading = false;
      notifyListeners();
      return true;
    } on FirebaseAuthException catch (e) {
      _isLoading = false;
      _error = 'Firebase Auth Error: ${_translateError(e.code, e.message)}';
      notifyListeners();
      return false;
    } catch (e) {
      _isLoading = false;
      _error = 'Błąd Google Sign-In: $e';
      notifyListeners();
      return false;
    }
  }

  // Wylogowanie
  Future<void> logout() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
    notifyListeners();
  }

  // Onboarding check
  Future<bool> hasSeenOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('seen_onboarding') ?? false;
  }

  Future<void> markOnboardingSeen() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('seen_onboarding', true);
  }

  String _translateError(String code, String? message) {
    switch (code) {
      case 'user-not-found':
        return 'Nie znaleziono użytkownika z tym adresem e-mail.';
      case 'wrong-password':
        return 'Nieprawidłowe hasło. Spróbuj ponownie.';
      case 'email-already-in-use':
        return 'Ten adres e-mail jest już zajęty.';
      case 'weak-password':
        return 'Hasło jest za słabe. Użyj minimum 6 znaków.';
      case 'invalid-email':
        return 'Nieprawidłowy format adresu e-mail.';
      case 'invalid-credential':
        return 'Nieprawidłowy e-mail lub hasło (lub provider jest wyłączony).';
      case 'operation-not-allowed':
        return 'Ta metoda logowania (np. Google lub Email) nie jest włączona w konsoli Firebase!';
      case 'network-request-failed':
        return 'Problem z połączeniem internetowym.';
      default:
        return 'Błąd ($code): ${message ?? "Nieznany problem"}';
    }
  }
}
