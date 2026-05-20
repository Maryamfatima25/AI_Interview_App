import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  static final _auth = FirebaseAuth.instance;
  static final _db   = FirebaseFirestore.instance;

  // ── Getters ──────────────────────────────────────────────
  static User?   get currentUser  => _auth.currentUser;
  static String? get currentUid   => _auth.currentUser?.uid;
  static String? get currentEmail => _auth.currentUser?.email;
  static String  get currentName  =>
      _auth.currentUser?.displayName ?? '';

  // ── Sign Up ──────────────────────────────────────────────
  // Role is always "applicant" — recruiters added manually
  static Future<String?> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final cred = await _auth.createUserWithEmailAndPassword(
        email:    email,
        password: password,
      );

      // Set display name in Firebase Auth
      await cred.user!.updateDisplayName(name);

      // Save profile in Firestore — role always applicant
      await _db
          .collection('users')
          .doc(cred.user!.uid)
          .set({
        'name':            name,
        'email':           email,
        'role':            'applicant', // always applicant on signup
        'createdAt':       FieldValue.serverTimestamp(),
        'profileComplete': false,
      });

      return null; // null = success

    } on FirebaseAuthException catch (e) {
      return _errorMsg(e.code);
    } catch (e) {
      return 'Something went wrong. Try again.';
    }
  }

  // ── Sign In ──────────────────────────────────────────────
  // Returns user data map, or map with 'error' key on failure
  static Future<Map<String, dynamic>> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final cred = await _auth.signInWithEmailAndPassword(
        email:    email,
        password: password,
      );

      // Fetch role from Firestore
      final doc = await _db
          .collection('users')
          .doc(cred.user!.uid)
          .get();

      if (!doc.exists) {
        // Create profile if missing (edge case)
        await _db
            .collection('users')
            .doc(cred.user!.uid)
            .set({
          'name':      cred.user!.displayName ?? '',
          'email':     email,
          'role':      'applicant',
          'createdAt': FieldValue.serverTimestamp(),
        });
        return {
          'uid':   cred.user!.uid,
          'name':  cred.user!.displayName ?? '',
          'email': email,
          'role':  'applicant',
        };
      }

      return {
        'uid':   cred.user!.uid,
        'name':  doc['name']  ?? '',
        'email': doc['email'] ?? '',
        'role':  doc['role']  ?? 'applicant',
      };

    } on FirebaseAuthException catch (e) {
      return {'error': _errorMsg(e.code)};
    } catch (e) {
      return {'error': 'Something went wrong. Try again.'};
    }
  }

  // ── Sign Out ─────────────────────────────────────────────
  static Future<void> signOut() async {
    await _auth.signOut();
  }

  // ── Check if already logged in ───────────────────────────
  // Use this in main.dart to auto-login returning users
  static Future<Map<String, dynamic>?> getLoggedInUser() async {
    final user = _auth.currentUser;
    if (user == null) return null;

    try {
      final doc = await _db
          .collection('users')
          .doc(user.uid)
          .get();
      if (!doc.exists) return null;

      return {
        'uid':   user.uid,
        'name':  doc['name']  ?? '',
        'email': doc['email'] ?? '',
        'role':  doc['role']  ?? 'applicant',
      };
    } catch (_) {
      return null;
    }
  }

  // ── Error messages ───────────────────────────────────────
  static String _errorMsg(String code) {
    switch (code) {
      case 'email-already-in-use':
        return 'This email is already registered';
      case 'wrong-password':
      case 'invalid-credential':
        return 'Incorrect email or password';
      case 'user-not-found':
        return 'No account found with this email';
      case 'weak-password':
        return 'Password must be at least 6 characters';
      case 'invalid-email':
        return 'Enter a valid email address';
      case 'network-request-failed':
        return 'No internet connection';
      case 'too-many-requests':
        return 'Too many attempts. Try again later';
      default:
        return 'Login failed. Please try again';
    }
  }
}